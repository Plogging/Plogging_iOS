//
//  Crypto+Swift.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/05.
//

import Foundation
import CryptoSwift

let DEFINE_KEY: String = ""
let DEFINE_IV: String = ""

protocol Cryptoable {
    func encryption(password: String)
    func decryption(password: String)
}

extension Cryptoable {
    // 암호화
    func encryption(password: String) -> String? {
        do {
            let aes = try AES(key: DEFINE_KEY, iv: DEFINE_IV)
            if let chiperText = try aes.encrypt(password.bytes).toBase64() {
                return chiperText
            }
            return nil
        } catch {
            print(error)
            return nil
        }
    }
    
    // 복호화
    func decryption(chiperText: String) {
        do {
            let aes = try AES(key: DEFINE_KEY, iv: DEFINE_IV)
            let e64_data = Data(base64Encoded: chiperText) ?? Data()
            let decryptData = try aes.decrypt(e64_data.bytes)
            let decryptText = String(bytes: decryptData, encoding: .utf8)
            print(decryptText)
        } catch {
            print(error)
        }
    }
}
