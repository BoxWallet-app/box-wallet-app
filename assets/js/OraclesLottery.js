const OraclesLottery = `
include "List.aes"


contract OraclesLottery =

    record answer = {
        content_cn : string,
        content_en : string,
        accounts   : list(address) }

    record problem = {
        content_cn    : string,
        content_en    : string,
        source_url    : string,
        answer        : map(int, answer),
        create_height : int,
        create_time   : int,
        over_time     : int,
        //0=start ing , 1=wait oracle , 2=confirm oracle 3=over 4.已发放
        status        : int,
        min_count     : int,
        result        : int,
        fee           : int,
        count         : int }

    record state = {
        index        : int,
        problems     : map(int, problem), 
        problems_oq  : map(int ,oracle_query(int, int)),
        records      : map(address, list(problem)),
        owner        : address,
        record_size  : int,
        decimals     : int }

  

    stateful entrypoint
        init : () => state
        init () =
            let owner = Call.caller
            { index       = 0,
              problems    = {},
              problems_oq = {},
              records     = {},
              owner       = owner,
              record_size = 100,
              decimals    = 1000000000000000000}

    stateful entrypoint
        add_problem : (string,string,string,int,int,map(int, answer)) => problem
        add_problem (content_cn,content_en,source_url,min_count,over_time,answers) =
            protocol_restrict()
            let problem = {
                content_cn = content_cn,
                content_en = content_en,
                source_url = source_url,
                min_count = min_count,
                answer = answers,
                create_height = Chain.block_height,
                create_time   = Chain.timestamp,
                over_time     = Chain.timestamp + over_time,
                status        = 0,
                result        = -1,
                fee           = 0,
                count         = 0 }
            put(state{ problems[state.index] = problem,index = state.index+1})
            problem

    
    stateful entrypoint
        update_problem : (int,string,string,string,int,int) => problem
        update_problem (problem_index,content_cn,content_en,source_url,min_count,over_time) =
            protocol_restrict()
            require(is_problem_exist(problem_index),"IS_PROBLEM_EXIST_FALSE")
            let last_problem = get_problem(problem_index)
            let problem = {
                content_cn    = content_cn,
                content_en    = content_en,
                source_url    = source_url,
                min_count     = min_count,
                answer        = last_problem.answer,
                create_height = Chain.block_height,
                create_time   = Chain.timestamp,
                over_time     = over_time,
                status        = last_problem.status,
                result        = last_problem.result,
                fee           = last_problem.fee,
                count         = last_problem.count }
            put(state{ problems[problem_index] = problem})
            problem

    stateful entrypoint
        update_answer : (int,int,string,string) => answer
        update_answer (problem_index,answer_index,content_cn,content_en) =
            protocol_restrict()
            require(is_problem_answer_exist(problem_index,answer_index),"IS_PROBLEM_ANSWER_EXIST_FALSE")
            let last_problem_aeswer = get_problem_answer(problem_index,answer_index)
            let answer = {
                content_cn = content_cn,
                content_en = content_en,
                accounts = last_problem_aeswer.accounts }
            put(state{ problems[problem_index].answer[answer_index] = answer})
            answer

    payable stateful entrypoint
        submit_answer : (int,int) => int
        submit_answer (problem_index,answer_index) =
            let problem = get_problem(problem_index)
            require(problem.min_count == Call.value,"PROBLEM_MIN_COUNT_ERROR")
            require(problem.over_time > Chain.timestamp,"PROBLEM_OVER_TIME_ERROR")
            require(problem.status == 0,"PROBLEM_STATUS_ERROR")
    
            put(state{ problems[problem_index].answer[answer_index].accounts = List.insert_at(0, Call.caller, state.problems[problem_index].answer[answer_index].accounts)})
            put(state{ problems[problem_index].count = problem.count + Call.value})
            Call.value

    stateful entrypoint
        wait_oracle : (int,oracle(int, int)) => oracle_query(int, int)
        wait_oracle (problem_index,o) =
            protocol_restrict()
            let problem = get_problem(problem_index)
            require(problem.status == 0,"PROBLEM_STATUS_ERROR")
            require(Oracle.check(o), "ORACLE_CHECK_FAILED")
            let fee = Oracle.query_fee(o)
            let oq = Oracle.query(o, problem_index, fee, RelativeTTL(20000), RelativeTTL(20000))
            put(state{ problems[problem_index].status = 1,problems[problem_index].count = problem.count - fee ,problems[problem_index].fee = fee })
            put(state {problems_oq[problem_index] = oq})
            oq


    entrypoint
        check_wait_oracle : (int,oracle(int, int)) => option(int)
        check_wait_oracle (problem_index,o) =
            protocol_restrict()
            let problem = get_problem(problem_index)
            require(problem.status == 1,"PROBLEM_STATUS_ERROR")
            Oracle.get_answer(o, state.problems_oq[problem_index])


    stateful entrypoint
        confrom_oracle : (int,oracle(int, int)) => int
        confrom_oracle (problem_index,o) =
            protocol_restrict()
            let problem = get_problem(problem_index)
            require(problem.status == 1,"PROBLEM_STATUS_ERROR")
            switch(Oracle.get_answer(o, state.problems_oq[problem_index]))
                Some(result) => 
                    put(state{ problems[problem_index].status = 2})
                    put(state{ problems[problem_index].result = result})
                    result
                None => -1


    stateful entrypoint
        over_confrom_oracle : (int) => problem
        over_confrom_oracle (problem_index) =
            protocol_restrict()
            let problem = get_problem(problem_index)
            put(state{ problems[problem_index].status = 3})
            problem


    stateful entrypoint
        over_oracle : (int,int) => problem
        over_oracle (problem_index,result) =
            protocol_restrict()
            let problem = get_problem(problem_index)
            put(state{ problems[problem_index].status = 3})
            put(state{ problems[problem_index].result = result})
            problem

    stateful entrypoint
        give_over_oracle : (int) => problem
        give_over_oracle (problem_index) =
            protocol_restrict()
            let problem = get_problem(problem_index)
            require(problem.status == 3,"PROBLEM_STATUS_ERROR")
            let accounts = problem.answer[problem.result].accounts
            List.foreach(accounts,  (addr) => Chain.spend(addr, problem.count / List.length(accounts)))
            put(state{ problems[problem_index].status = 4})
            problem

    entrypoint
        get_state:()=>state 
        get_state () =
            state 

    function
        is_problem_answer_exist : (int,int) => bool
        is_problem_answer_exist(problem_index,answer_index) =
            switch(Map.lookup(answer_index, state.problems[problem_index].answer))
                Some(answer) => true
                None => false

    function
        get_problem_answer : (int,int) => answer
        get_problem_answer(problem_index,answer_index) =
            switch(Map.lookup(answer_index, state.problems[problem_index].answer))
                Some(answer) => answer

    function
        is_problem_exist : (int) => bool
        is_problem_exist(index) =
            switch(Map.lookup(index, state.problems))
                Some(problem) => true
                None => false

    entrypoint
        get_problem : (int) => problem
        get_problem(index) =
            switch(Map.lookup(index, state.problems))
                Some(problem) => problem

    entrypoint
        get_problems : () => map(int, problem)
        get_problems() =
            state.problems

    function
        protocol_restrict : () => unit
        protocol_restrict() =
            require(Call.origin == Contract.creator, "PROTOCOL_RESTRICTED")
            


    

	`
