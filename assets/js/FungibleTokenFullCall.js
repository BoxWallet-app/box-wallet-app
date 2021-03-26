
const contractTransfer = function (secretKey, publicKey, ctId, receiveID, amount,type) {
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
            var source = FungibleTokenFullContract;
            client.contractEncodeCall(source, 'transfer', [receiveID, Ae.AmountFormatter.toAettos(amount)]).then(callDataCall => {
                status_JS.postMessage("contractCall");
                client.contractCall(source, ctId, "transfer", callDataCall).then(callResult => {
                    status_JS.postMessage("decode");
                    callResult.decode().then(callResultDecode => {
                        status_JS.postMessage("sucess");
                        contractTransfer_JS.postMessage(callResult.hash);

                    }).catch(err => {
                        status_JS.postMessage("error");
                        error_JS.postMessage(err.toString());
                    })
                }).catch(err => {
                    status_JS.postMessage("error");
                    if(err.toString().indexOf("Decoded") !== -1 ){
                        var decode = err.toString().split('Decoded: ')
                        var msg = decode[1].substring(1, decode[1].length - 4)
                        error_JS.postMessage(msg);
                    }else{
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
