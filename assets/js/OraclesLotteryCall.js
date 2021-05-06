

const contractSubmitAnswer = function (secretKey, publicKey, oracleCtId, problemIndex, answerIndex, amount) {
    Ae.Node({url: nodeUrl}).then(node => {
        Ae.Universal({
            compilerUrl: compilerUrl,
            nodes: [{name: 'local', instance: node}],
            accounts: [Ae.MemoryAccount({
                keypair: {
                    secretKey: secretKey,
                    publicKey: publicKey
                }
            }),],
            address: publicKey,
        }).then(client => {
            status_JS.postMessage("contractEncodeCall");
            client.contractEncodeCall(OraclesLottery, 'submit_answer', [problemIndex, answerIndex]).then(callDataCall => {
                status_JS.postMessage("contractCall");
                client.contractCall(OraclesLottery, oracleCtId, "submit_answer", callDataCall, {amount: Ae.AmountFormatter.toAettos(amount)}).then(callResult => {
                    status_JS.postMessage("decode");
                    callResult.decode().then(callResultDecode => {
                        status_JS.postMessage("sucess");
                        contractSubmitAnswer_JS.postMessage(callResultDecode);
                    }).catch(err => {
                        status_JS.postMessage("error");
                        error_JS.postMessage(err.toString());
                    })
                }).catch(err => {
                    status_JS.postMessage("error");
                    if (err.toString().indexOf("Decoded") !== -1) {
                        var decode = err.toString().split('Decoded: ')
                        var msg = decode[1].substring(1, decode[1].length - 4)
                        error_JS.postMessage(msg);
                    } else {
                        error_JS.postMessage(err.toString());
                    }
                })
            }).catch(err => {
                status_JS.postMessage("error");
                error_JS.postMessage(err.toString());
            })
        }).catch(err => {
            status_JS.postMessage("error");
            error_JS.postMessage(err.toString());
        })
    }).catch(err => {
        status_JS.postMessage("error");
        error_JS.postMessage(err.toString());
    });
};