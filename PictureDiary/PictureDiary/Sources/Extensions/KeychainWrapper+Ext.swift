//
//  KeychainWrapper+Ext.swift
//  PictureDiary
//
//  Created by byunghak on 2022/06/19.
//

import Foundation
import SwiftKeychainWrapper

enum KeychainKey: String {
    case accessToken
}

extension KeychainWrapper {
    static func setValue(_ value: String, forKey keyChainKey: KeychainKey) {
        self.standard.set(value, forKey: keyChainKey.rawValue)
    }
    
    static func getValue(forKey keychainKey: KeychainKey) -> String? {
        return KeychainWrapper.standard.string(forKey: keychainKey.rawValue)
    }
    
    static func removeValue(forKey keychainKey: KeychainKey) {
        KeychainWrapper.standard.removeObject(forKey: keychainKey.rawValue)
    }
}
