
const spend = function (secretKey, publicKey, receiveID, amount) {
    Ae.Node({url: nodeUrl}).then(node => {
        Ae.Universal({
            nodes: [{name: 'local', instance: node}],
            accounts: [Ae.MemoryAccount({
                keypair: {
                    secretKey: secretKey,
                    publicKey: publicKey
                }
            }),],
            address: publicKey,
        }).then(client => {
            status_JS.postMessage("broadcast");
            client.spend(
                Ae.AmountFormatter.toAettos(amount),
                receiveID,
                {
                    payload: 'Box aepp',
                    waitMined: false
                },
            ).then(res => {
                const {blockHeight, hash, tx} = res;
                status_JS.postMessage("sucess");
                spend_JS.postMessage(hash);

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
    })
};

const claimName = function (signingKey, publicKey, name) {
    Ae.Node({url: nodeUrl}).then(node => {
        Ae.Universal({
            nodes: [{name: 'local', instance: node}],
            accounts: [
                Ae.MemoryAccount({
                    keypair: {
                        secretKey: signingKey,
                        publicKey: publicKey
                    }
                }),
            ],
            address: publicKey,
        }).then(aeInstance => {
            status_JS.postMessage("aensPreclaim");
            aeInstance.aensPreclaim(name).then(function (preclaim) {
                status_JS.postMessage("aensClaim");
                aeInstance.aensClaim(name, preclaim.salt, {waitMined: false}).then(function (claim) {
                    status_JS.postMessage("sucess");
                    claimName_JS.postMessage(claim.hash);
                }).catch(function (err) {
                    status_JS.postMessage("error");
                    error_JS.postMessage(err.toString());
                });
            }).catch(function (err) {
                status_JS.postMessage("error");
                error_JS.postMessage(err.toString());
            })
        }).catch(err => {
            status_JS.postMessage("error");
            error_JS.postMessage(err.toString());
        });
    }).catch(err => {
        status_JS.postMessage("error");
        error_JS.postMessage(err.toString());
    });
}

const updateName = function (signingKey, publicKey, name , pointData) {
    Ae.Node({url: nodeUrl}).then(node => {
        Ae.Universal({
            nodes: [{name: 'local', instance: node}],
            accounts: [
                Ae.MemoryAccount({
                    keypair: {
                        secretKey: signingKey,
                        publicKey: publicKey
                    }
                }),
            ],
            address: publicKey,
        }).then(aeInstance => {
            const pointersArray = [pointData];
            status_JS.postMessage("aensUpdate");
            aeInstance.aensUpdate(name, pointersArray, {
                extendPointers: true,
                waitMined: true
            }).then(function (update) {
                status_JS.postMessage("sucess");
                updateName_JS.postMessage(update.hash);
            }).catch(function (err) {
                status_JS.postMessage("error");
                error_JS.postMessage(err.toString());
            })
        }).catch(function (err) {
            status_JS.postMessage("error");
            error_JS.postMessage(err.toString());
        })
    }).catch(function (err) {
        status_JS.postMessage("error");
        error_JS.postMessage(err.toString());
    });
}

const transferName = function (signingKey, publicKey, name , address) {
    Ae.Node({url: nodeUrl}).then(node => {
        Ae.Universal({
            nodes: [{name: 'local', instance: node}],
            accounts: [
                Ae.MemoryAccount({
                    keypair: {
                        secretKey: signingKey,
                        publicKey: publicKey
                    }
                }),
            ],
            address: publicKey,
        }).then(aeInstance => {
            status_JS.postMessage("aensTransfer");
            aeInstance.aensTransfer(name, address, {
                waitMined: true
            }).then(function (update) {
                status_JS.postMessage("sucess");
                transferName_JS.postMessage(update.hash);
            }).catch(function (err) {
                status_JS.postMessage("error");
                error_JS.postMessage(err.toString());
            })
        }).catch(function (err) {
            status_JS.postMessage("error");
            error_JS.postMessage(err.toString());
        })
    }).catch(function (err) {
        status_JS.postMessage("error");
        error_JS.postMessage(err.toString());
    });
}

const bidName = function (signingKey, publicKey, name, nameFee) {
    Ae.Node({url: nodeUrl}).then(node => {
        Ae.Universal({
            nodes: [{name: 'local', instance: node}],
            accounts: [
                Ae.MemoryAccount({
                    keypair: {
                        secretKey: signingKey,
                        publicKey: publicKey
                    }
                }),
            ],
            address: publicKey,
        }).then(aeInstance => {
            status_JS.postMessage("aensPreclaim");
            aeInstance.aensPreclaim(name).then(function (preclaim) {
                status_JS.postMessage("aensBid");
                aeInstance.aensBid(name, Ae.AmountFormatter.toAettos(nameFee), {waitMined: false}).then(function (bid) {
                    console.log("AE bid hash:" + bid.hash);
                    status_JS.postMessage("sucess");
                    bidName_JS.postMessage(bid.hash);
                }).catch(function (err) {
                    status_JS.postMessage("error");
                    error_JS.postMessage(err.toString());
                });
            }).catch(function (err) {
                status_JS.postMessage("error");
                error_JS.postMessage(err.toString());
            })
        }).catch(function (err) {
            status_JS.postMessage("error");
            error_JS.postMessage(err.toString());
        })
    }).catch(function (err) {
        status_JS.postMessage("error");
        error_JS.postMessage(err.toString());
    });
}

const getMnemonic = function () {
    const mnemonic = Ae.HdWallet.generateMnemonic();
    const publicKeyInsecretKey = Ae.HdWallet.getHdWalletAccountFromMnemonic(mnemonic, 0);
    const publicKey = publicKeyInsecretKey.publicKey;
    const secretKey = publicKeyInsecretKey.secretKey;
    getMnemonic_JS.postMessage(publicKey + "#" + secretKey + "#" + mnemonic);
};

const getSecretKey = function (mnemonic) {
    const publicKeyInsecretKey = Ae.HdWallet.getHdWalletAccountFromMnemonic(mnemonic, 0);
    const publicKey = publicKeyInsecretKey.publicKey;
    const secretKey = publicKeyInsecretKey.secretKey;
    getSecretKey_JS.postMessage(publicKey + "#" + secretKey);
};

const validationMnemonic = function (mnemonic) {
    try {
        Ae.HdWallet.generateSaveHDWallet(mnemonic, 0);
        validationMnemonic_JS.postMessage("sucess");
        return true;
    } catch (err) {
        validationMnemonic_JS.postMessage("error");
        return err.message
    }
}
