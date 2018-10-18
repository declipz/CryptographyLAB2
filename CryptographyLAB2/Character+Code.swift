//
//  Character+Code.swift
//  CryptographyLAB2
//
//  Created by Vladislav Kondrashkov on 10/18/18.
//  Copyright © 2018 Vladislav Kondrashkov. All rights reserved.
//

import Foundation

extension Character {
    var code: Int {
        get {
            let s = String(self).unicodeScalars
            return Int(s[s.startIndex].value)
        }
    }
}
