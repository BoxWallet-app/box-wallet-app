const FungibleTokenFullContract = `
// ISC License
//
// Copyright (c) 2017, aeternity developers
//
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
// REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
// AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
// INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
// LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
// OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
// PERFORMANCE OF THIS SOFTWARE.


// THIS IS NOT SECURITY AUDITED
// DO NEVER USE THIS WITHOUT SECURITY AUDIT FIRST

@compiler >= 4

include "Option.aes"

/// @title - Fungible token with all the extensions - burn, mint, allowances
contract FungibleTokenFull =

  // This defines the state of type record encapsulating the contract's mutable state
  record state =
    { owner        : address      // the smart contract's owner address
    , total_supply : int          // total token supply
    , balances     : balances     // balances for each account
    , meta_info    : meta_info    // token meta info (name, symbol, decimals)
    , allowances   : allowances   // owner of account approves the transfer of an amount to another account
    , swapped      : map(address, int) }

  // This is the meta-information record type
  record meta_info =
    { name     : string
    , symbol   : string
    , decimals : int }

  // This is the format of allowance record type that will be used in the state
  record allowance_accounts = { from_account : address, for_account : address }

  // This is a type alias for the balances map
  type balances = map(address, int)

  // This is a type alias for the allowances map
  type allowances = map(allowance_accounts, int)

  // Declaration and structure of datatype event
  // and events that will be emitted on changes
  datatype event =
    Transfer(address, address, int)
    | Allowance(address, address, int)
    | Burn(address, int)
    | Mint(address, int)
    | Swap(address, int)

  // List of supported extensions
  entrypoint aex9_extensions() : list(string) = ["allowances", "mintable", "burnable", "swappable"]

  // Create a fungible token with
  // the following \`name\` \`symbol\` and \`decimals\`
  // and set the inital smart contract state
  entrypoint init(name: string, decimals : int, symbol : string, initial_owner_balance : option(int)) =
    // If the \`name\` lenght is less than 1 symbol abort the execution
    require(String.length(name) >= 1, "STRING_TOO_SHORT_NAME")
    // If the \`symbol\` length is less than 1 symbol abort the execution
    require(String.length(symbol) >= 1, "STRING_TOO_SHORT_SYMBOL")
    // If the provided value for \`decimals\` is negative abort the execution
    require_non_negative_value(decimals)
    // If negative initial owner balance is passed, abort the execution
    let initial_supply = Option.default(0, initial_owner_balance)
    require_non_negative_value(initial_supply)

    let owner = Call.caller
    { owner        = owner,
      total_supply = initial_supply,
      balances     = Option.match({}, (balance) => { [owner] = balance }, initial_owner_balance),
      meta_info    = { name = name, symbol = symbol, decimals = decimals },
      allowances   = {},
      swapped      = {} }

  // Get the token meta info
  entrypoint meta_info() : meta_info =
    state.meta_info

  // Get the token total supply
  entrypoint total_supply() : int =
    state.total_supply

  // Get the token owner address
  entrypoint owner() : address =
    state.owner

  // Get the balances state
  entrypoint balances() : balances =
    state.balances

  // Get balance for address of \`owner\`
  // returns option(int)
  // If the \`owner\` address haven't had any token balance
  // in this smart contract the return value is None
  // Otherwise Some(int) is returned with the current balance
  entrypoint balance(account: address) : option(int) =
    Map.lookup(account, state.balances)

  // Get all swapped tokens stored in state
  entrypoint swapped() : map(address, int) =
    state.swapped

  // Get the allowances state
  entrypoint allowances() : allowances =
    state.allowances

  // Get the allowance for passed \`allowance_accounts\` record
  // returns option(int)
  // This will lookup and return the allowed spendable amount
  // from one address for another
  // If there is no such allowance present result is None
  // Otherwise Some(int) is returned with the allowance amount
  entrypoint allowance(allowance_accounts : allowance_accounts) : option(int) =
    Map.lookup(allowance_accounts, state.allowances)

  // Get the allowance for caller from \`from_account\` address
  // returns option(int)
  // This will look up the allowances and return the allowed spendable amount
  // from \`from_account\` for the transaction sender \`Call.caller\`
  // If there is no such allowance present result is None
  // Otherwise Some(int) is returned with the allowance amount
  entrypoint allowance_for_caller(from_account: address) : option(int) =
    allowance({ from_account = from_account, for_account = Call.caller })

  // Send \`value\` amount of tokens from address \`from_account\` to address \`to_account\`
  // The transfer_allowance method is used for a withdraw workflow, allowing contracts to send
  // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
  // fees in sub-token contract.
  // The execution will abort and fail if there is no allowance set up previous this call
  stateful entrypoint transfer_allowance(from_account: address, to_account: address, value: int) =
    let allowance_accounts = { from_account = from_account, for_account = Call.caller }
    internal_transfer(from_account, to_account, value)
    internal_change_allowance(allowance_accounts, -value)

  // Create allowance for \`for_account\` to withdraw from your account \`Call.caller\`,
  // multiple times, up to the \`value\` amount.
  // This function will abort and fail if called again when there is allowance
  // already set for these particular accounts pair.
  stateful entrypoint create_allowance(for_account: address, value: int) =
    // Check if the passed value is not negative
    require_non_negative_value(value)
    // Set the allowance account pair in the memory variable
    let allowance_accounts = { from_account =  Call.caller, for_account = for_account }
    // Check if there is no allowance already present in the state
    // for these particular accounts pair.
    require_allowance_not_existent(allowance_accounts)
    // Save the allowance value for these accounts pair in the state
    put(state{ allowances[allowance_accounts] = value })
    // Fire Allowance event to include it in the transaction event log
    Chain.event(Allowance(Call.caller, for_account, value))

  // Allows to change the allowed spendable value for \`for_account\` with \`value_change\`
  stateful entrypoint change_allowance(for_account: address, value_change: int) =
    let allowance_accounts = { from_account =  Call.caller, for_account = for_account }
    internal_change_allowance(allowance_accounts, value_change)

  // Resets the allowance given \`for_account\` to zero.
  stateful entrypoint reset_allowance(for_account: address) =
    let allowance_accounts = { from_account = Call.caller, for_account = for_account }
    internal_change_allowance(allowance_accounts, - state.allowances[allowance_accounts])

  /// Transfer the balance of \`value\` from \`Call.caller\` to \`to_account\` account
  stateful entrypoint transfer(to_account: address, value: int) =
    internal_transfer(Call.caller, to_account, value)

  // Destroys \`value\` tokens from \`Call.caller\`, reducing the total supply.
  // \`Burn\` event with \`Call.caller\` address and \`value\`.
  stateful entrypoint burn(value: int) =
    require_balance(Call.caller, value)
    require_non_negative_value(value)
    put(state{ total_supply = state.total_supply - value, balances[Call.caller] @ b = b - value })
    Chain.event(Burn(Call.caller, value))

  // Creates \`value\` tokens and assigns them to \`account\`, increasing the total supply.
  // Emits a \`Mint\` event with \`account\` and \`value\`.
  stateful entrypoint mint(account: address, value: int) =
   require_owner()
   require_non_negative_value(value)
   put(state{ total_supply = state.total_supply + value, balances[account = 0] @ b = b + value })
   Chain.event(Mint(account, value))

  stateful entrypoint swap() =
    let balance = Map.lookup_default(Call.caller, state.balances, 0)
    burn(balance)
    put(state{ swapped[Call.caller] = balance })
    Chain.event(Swap(Call.caller, balance))

  stateful entrypoint check_swap(account: address) : int =
    Map.lookup_default(account, state.swapped, 0)

  // INTERNAL FUNCTIONS

  function require_owner() =
    require(Call.caller == state.owner, "ONLY_OWNER_CALL_ALLOWED")

  function require_non_negative_value(value : int) =
    require(value >= 0, "NON_NEGATIVE_VALUE_REQUIRED")

  function require_balance(account : address, value : int) =
    switch(balance(account))
      Some(balance) =>
        require(balance >= value, "ACCOUNT_INSUFFICIENT_BALANCE")
      None => abort("BALANCE_ACCOUNT_NOT_EXISTENT")

  stateful function internal_transfer(from_account: address, to_account: address, value: int) =
    require_non_negative_value(value)
    require_balance(from_account, value)
    put(state{ balances[from_account] @ b = b - value })
    put(state{ balances[to_account = 0] @ b = b + value })
    Chain.event(Transfer(from_account, to_account, value))

  function require_allowance_not_existent(allowance_accounts : allowance_accounts) =
    switch(allowance(allowance_accounts))
      None => None
      Some(_) => abort("ALLOWANCE_ALREADY_EXISTENT")

  function require_allowance(allowance_accounts : allowance_accounts, value : int) : int =
    switch(allowance(allowance_accounts))
      Some(allowance) =>
        require_non_negative_value(allowance + value)
        allowance
      None => abort("ALLOWANCE_NOT_EXISTENT")

  stateful function internal_change_allowance(allowance_accounts : allowance_accounts, value_change : int) =
    let allowance = require_allowance(allowance_accounts, value_change)
    let new_allowance = allowance + value_change
    require_non_negative_value(new_allowance)
    put(state{ allowances[allowance_accounts] = new_allowance })
    Chain.event(Allowance(allowance_accounts.from_account, allowance_accounts.for_account, new_allowance))

		`
