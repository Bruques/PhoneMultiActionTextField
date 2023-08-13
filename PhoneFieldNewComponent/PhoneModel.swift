//
//  PhoneModel.swift
//  PhoneFieldNewComponent
//
//  Created by Bruno Marques on 10/08/23.
//

import Foundation

public struct PhoneModel: Decodable {
    public let countryFlag: String
    public let countryCode: String
    public let countryName: String
    public let countryMasks: [String]
    
    enum CodingKeys: String, CodingKey {
        case countryFlag = "iso"
        case countryCode = "code"
        case countryName = "name"
        case countryMasks = "mask"
    }
    
    public init(iso: String, code: String, nameToLocalize: String, masks: [String]) {
        self.countryFlag = iso
        self.countryCode = code
        let localizedString = NSLocalizedString(nameToLocalize, tableName: "CountryNamesLocalizable", bundle: Bundle(for: Mask.self), comment: "")
        self.countryName = localizedString
        self.countryMasks = masks
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.countryCode = try container.decode(String.self, forKey: .countryCode)
        self.countryFlag = try container.decode(String.self, forKey: .countryFlag)
        
        let englishName = try container.decode(String.self, forKey: .countryName)
        let localizedString = NSLocalizedString(englishName, tableName: "CountryNamesLocalizable", bundle: Bundle(for: Mask.self), comment: "")
        self.countryName = localizedString
        
        if let singleMask = try? container.decode(String.self, forKey: .countryMasks) {
            self.countryMasks = [singleMask]
        } else {
            var masks = try container.decode([String].self, forKey: .countryMasks)
            self.countryMasks = masks.sorted(by: { leftItem, rightItem in
                leftItem.count < rightItem.count
            })
        }
    }
}
