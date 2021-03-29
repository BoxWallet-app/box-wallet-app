const ABCLockContractV3 = `
@compiler >= 4.3
include "List.aes"

contract FungibleTokenInterface =

  entrypoint balances                      : ()                      => map(address, int)
  entrypoint balance                       : (address)               => option(int)
  stateful entrypoint transfer             : (address, int)          => unit


contract ABCLockContractV3 =

    record info_data = {
        account      : address,
        count        : int,
        token        : int,
        after_height : int,
        min_height   : int,
        height       : int,
        all_count    : int}

    record account_blacklist = {
        account : address,
        count   : int,
        ae      : int,
        height  : int}

    record account = {
        account       : address,
        mapping_count : int,
        height        : int}

    record state = {
        mapping_accounts    : map(address,account),
        account_blacklists  : map(address,account_blacklist),
        all_count           : int,
        token               : FungibleTokenInterface,
        decimals            : int,
        base_token_count    : int,
        max_benefits_height : int,
        min_benefits_height : int,
        min_lock_count      : int
     }

    stateful entrypoint
        init : (FungibleTokenInterface) => state
        init (token) =
            { mapping_accounts    = {},
              account_blacklists  = {},
              all_count           = 0,
              token               = token,
              decimals            = 1000000000000000000,
              base_token_count    = 300000000000,
              max_benefits_height = 9999999,
              min_benefits_height = 100,
              min_lock_count      = 1000000000000000000}

    stateful entrypoint
        mapping_lock : (int) => int
        mapping_lock(count) =
            require(!is_mapping_account_blacklist(Call.caller), "IS_MAPPING_ACCOUNTS_BLACK_LIST_TRUE")
            require(!is_mapping_account(Call.caller), "IS_MAPPING_ACCOUNTS_TRUE")
            require(state.min_lock_count =< count,"MIN_LOCK_COUNT_LOW")
            require(Chain.balance(Call.caller) > count, "BALANCE_COUNT_LOW")
            let account = {account = Call.caller , mapping_count = count , height = Chain.block_height}
            put(state{mapping_accounts[Call.caller] = account, all_count = state.all_count + count})
            count

    stateful entrypoint
        mapping_unlock : () => int
        mapping_unlock() =
            require(!is_mapping_account_blacklist(Call.caller), "IS_MAPPING_ACCOUNTS_BLACK_LIST_TRUE")
            require(is_mapping_account(Call.caller), "IS_MAPPING_ACCOUNTS_FALSE")
            let account = get_mapping_account(Call.caller)
            let new_mapping_accounts = Map.delete(Call.caller,state.mapping_accounts)
            put(state{mapping_accounts = new_mapping_accounts,all_count = state.all_count - account.mapping_count})
            account.mapping_count


    stateful entrypoint
        account_check_balance : (address) => bool
        account_check_balance(addr) =
            require(is_mapping_account(addr), "IS_MAPPING_ACCOUNTS_FALSE")
            if(Chain.balance(addr) < get_mapping_account(addr).mapping_count)
                let account = get_mapping_account(addr)
                let new_mapping_accounts = Map.delete(addr,state.mapping_accounts)
                put(state{mapping_accounts = new_mapping_accounts,all_count = state.all_count - account.mapping_count})

                let account_blacklist = {account = addr , count = account.mapping_count ,ae = Chain.balance(addr), height = Chain.block_height}
                put(state{account_blacklists[addr] = account_blacklist})
                true
            else
                false

    stateful entrypoint
        benefits : () => int
        benefits() =
            require(!is_mapping_account_blacklist(Call.caller), "IS_MAPPING_ACCOUNTS_BLACK_LIST_TRUE")
            require(is_mapping_account(Call.caller), "IS_MAPPING_ACCOUNTS_FALSE")
            if(account_check_balance(Call.caller))
                -1
            else
                let account = get_mapping_account(Call.caller)
                let after_height = Chain.block_height - account.height
                if(after_height > state.max_benefits_height)
                    let token_count = state.base_token_count * (account.mapping_count / state.decimals) * state.max_benefits_height
                    state.token.transfer(account.account,token_count)

                    let update_account = {account = account.account,mapping_count = account.mapping_count,height = Chain.block_height}
                    put(state{mapping_accounts[Call.caller] = update_account})
                    token_count
                else
                    require(after_height > state.min_benefits_height, "MIN_BENEFITS_HEIGHT")
                    let token_count = state.base_token_count * (account.mapping_count / state.decimals) * after_height
                    state.token.transfer(account.account,token_count)

                    let update_account = {account = account.account,mapping_count = account.mapping_count,height = Chain.block_height}
                    put(state{mapping_accounts[Call.caller] = update_account})
                    token_count

    entrypoint
        get_status : () => state
        get_status()=
            let state = {
                mapping_accounts    = {},
                account_blacklists  = {},
                all_count           = state.all_count,
                token               = state.token,
                decimals            = state.decimals,
                base_token_count    = state.base_token_count,
                max_benefits_height = state.max_benefits_height,
                min_benefits_height = state.min_benefits_height,
                min_lock_count      = state.min_lock_count}
            state

    stateful entrypoint
        update_status : (int,int,int,int,FungibleTokenInterface) => state
        update_status(base_token_count,max_benefits_height,min_benefits_height,min_lock_count,token)=
            protocol_restrict()
            put(state{
                mapping_accounts    = state.mapping_accounts,
                account_blacklists  = state.account_blacklists,
                all_count           = state.all_count,
                token               = token,
                decimals            = state.decimals,
                base_token_count    = base_token_count,
                max_benefits_height = max_benefits_height,
                min_benefits_height = min_benefits_height,
                min_lock_count      = min_lock_count})
            get_status()

    stateful entrypoint
        withdraw_token : () => unit
        withdraw_token() =
            protocol_restrict()
            switch(state.token.balance(Contract.address))
                Some(balance) => state.token.transfer(Contract.creator,balance)
                None => state.token.transfer(Contract.creator,0)

    stateful entrypoint
        remove_account_blacklist : (address) => unit
        remove_account_blacklist(addr) =
            protocol_restrict()
            require(is_mapping_account_blacklist(addr), "IS_MAPPING_ACCOUNTS_BLACK_LIST_FALSE")
            let new_account_blacklists = Map.delete(addr,state.account_blacklists)
            put(state{account_blacklists = new_account_blacklists})

    entrypoint
        get_mapping_accounts : ()=> list(address * account)
        get_mapping_accounts() =
            let mapping_accounts_list = Map.to_list(state.mapping_accounts)
            mapping_accounts_list

    entrypoint
        get_accounts_blacklists : ()=> list(address * account_blacklist)
        get_accounts_blacklists() =
            let accounts_blacklists = Map.to_list(state.account_blacklists)
            accounts_blacklists

    entrypoint
        get_mapping_account : (address) => account
        get_mapping_account(addr) =
            switch(Map.lookup(addr, state.mapping_accounts))
                Some(account) => account
                None => {account = Call.caller , mapping_count = 0 , height = -1}

    entrypoint
        get_account_blacklist : (address) => account_blacklist
        get_account_blacklist(addr) =
            switch(Map.lookup(addr, state.account_blacklists))
                Some(account_blacklist) => account_blacklist
                None => {account = Call.caller , count = 0 ,ae = 0, height = -1}

    entrypoint
        get_data_info : (address) => info_data
        get_data_info(addr) =
            let account = get_mapping_account(addr)
            let after_height = Chain.block_height - account.height
            let token_count  = state.base_token_count * (account.mapping_count / state.decimals) * after_height
            {   account      = addr,
                count        = account.mapping_count,
                token        = token_count,
                min_height   = state.min_benefits_height,
                after_height = after_height,
                height       = account.height,
                all_count    = state.all_count}



    function
        is_mapping_account : (address) => bool
        is_mapping_account(addr) =
            switch(Map.lookup(addr, state.mapping_accounts))
                Some(account) => true
                None => false

    function
        is_mapping_account_blacklist : (address) => bool
        is_mapping_account_blacklist(addr) =
            switch(Map.lookup(addr, state.account_blacklists))
                Some(int) => true
                None => false

    function
        protocol_restrict : () => unit
        protocol_restrict() =
            require(Call.origin == Contract.creator, "PROTOCOL_RESTRICTED")





	`
