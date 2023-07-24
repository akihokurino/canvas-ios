import BigInt
import Foundation
import Web3Core
import web3swift

func signMessage(message: String, rawPrivateKey: String) async -> String {
    let provider = try! await Web3HttpProvider(url: URL(string: "https://avalanche-fuji.infura.io/v3/\(Env.infuraKey)")!, network: Networks.Custom(networkID: BigUInt(43113)))
    let web3 = Web3(provider: provider)
    let keystore = try! EthereumKeystoreV3(privateKey: Data.fromHex(rawPrivateKey)!, password: "web3swift")!
    let keystoreManager = KeystoreManager([keystore])
    web3.addKeystoreManager(keystoreManager)

    let data = message.data(using: .utf8)!
    let signature = try! await web3.personal.signPersonal(message: data, from: keystore.getAddress()!, password: "web3swift")
    
    return signature.toHexString()
}
