//
//  Mask.swift
//  PhoneFieldNewComponent
//
//  Created by Bruno Marques on 10/08/23.
//

import Foundation

class Mask {
    static public var shared = Mask()
    
    public var maskFormat: String = "(###) ###-####"
    
    public func formateValue(_ value: String) -> String {
            let cleanPhoneNumber = value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let mask = maskFormat
            var result = ""
            var index = cleanPhoneNumber.startIndex
            for ch in mask where index < cleanPhoneNumber.endIndex {
                if ch == "#" {
                    result.append(cleanPhoneNumber[index])
                    index = cleanPhoneNumber.index(after: index)
                } else {
                    result.append(ch)
                }
            }
            return result
        }
}
