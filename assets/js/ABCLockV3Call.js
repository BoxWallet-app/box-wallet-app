const contractDefiV3Lock = function (secretKey, publicKey, ctId, amount) {
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
            client.contractEncodeCall(ABCLockContractV3, 'mapping_lock', [Ae.AmountFormatter.toAettos(amount)]).then(callDataCall => {
                status_JS.postMessage("contractCall");
                client.contractCall(ABCLockContractV3, ctId, "mapping_lock", callDataCall).then(callResult => {
                    status_JS.postMessage("decode");
                    callResult.decode().then(callResultDecode => {
                        status_JS.postMessage("sucess");
                        contractDefiV3Lock_JS.postMessage(callResultDecode);

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

const contractDefiV3UnLock = function (secretKey, publicKey, ctId) {
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
            client.contractEncodeCall(ABCLockContractV3, 'mapping_unlock').then(callDataCall => {
                status_JS.postMessage("contractCall");
                client.contractCall(ABCLockContractV3, ctId, "mapping_unlock", callDataCall, {}).then(callResult => {
                    status_JS.postMessage("decode");
                    callResult.decode().then(callResultDecode => {
                        status_JS.postMessage("sucess");
                        contractDefiV3UnLock_JS.postMessage(callResultDecode);
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

const contractDefiV3Benefits = function (secretKey, publicKey, ctId) {
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
            client.contractEncodeCall(ABCLockContractV3, 'benefits', []).then(callDataCall => {
                status_JS.postMessage("contractCall");
                client.contractCall(ABCLockContractV3, ctId, "benefits", callDataCall, {}).then(callResult => {
                    status_JS.postMessage("decode");
                    callResult.decode().then(callResultDecode => {
                        status_JS.postMessage("sucess");
                        contractDefiV3Benefits_JS.postMessage(callResultDecode);
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
