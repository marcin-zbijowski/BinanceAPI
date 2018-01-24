import Foundation
import CryptoSwift

extension String {

    func hmac(secret: String, variant: HMAC.Variant = .sha256) -> String? {
        do {
            let hmac = try HMAC(key: secret, variant: variant)
            let result = try hmac.authenticate([UInt8](self.utf8))
            return Data(bytes: result).base64EncodedString()
        } catch {
            print(error)
        }

        return nil
    }

}
