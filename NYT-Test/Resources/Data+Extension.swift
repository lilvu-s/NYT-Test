//
//  Data+Extension.swift
//  NYT-Test
//
//  Created by Ангеліна Семенченко on 07.07.2023.
//

import Foundation
import CryptoKit

extension Data {
    func sha1() -> String {
        let hash = Insecure.SHA1.hash(data: self)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
