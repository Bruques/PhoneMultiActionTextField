//
//  CountryFormatter.swift
//  PhoneFieldNewComponent
//
//  Created by Bruno Marques on 10/08/23.
//

import Foundation

public class CountryFormatter {
    
    static public let shared = CountryFormatter()
    var phoneModels: [PhoneModel] = []
    
    private init() {
        guard let countriesPath = Bundle(for: Mask.self).path(forResource: "countries", ofType: "json") else {
            self.phoneModels = self.createInitialPhoneModels()
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: countriesPath))
            let data = try JSONDecoder().decode([PhoneModel].self, from: jsonData)
            self.phoneModels = data
        } catch {
            self.phoneModels = []
        }
    }
    
    private func createInitialPhoneModels() -> [PhoneModel] {
        let unitedStatesPhoneModel = PhoneModel(iso: "US", code: "+1", nameToLocalize: "United States", masks: ["(###)###-####"])
        let brazilPhoneModel = PhoneModel(iso: "BR", code: "+55", nameToLocalize: "Brazil", masks: ["(##)####-####", "(##)#####-####"])
        let mexicoPhoneModel = PhoneModel(iso: "MX", code: "52", nameToLocalize: "Mexico", masks: ["(###)###-####"])
        let canadaPhoneModel = PhoneModel(iso: "CA", code: "+1", nameToLocalize: "Canada", masks: ["(###)###-####"])
        var phoneModels: [PhoneModel] = []
        phoneModels.append(contentsOf: [unitedStatesPhoneModel, brazilPhoneModel, mexicoPhoneModel, canadaPhoneModel])
        return phoneModels
    }
    
    public func getCurrentIsoByCountry(country: String) -> String {
        var iso = ""
        
        switch country {
        case "BRASIL":
            iso = "BR"
        case "UNITED_STATES":
            iso = "US"
        case "MEXICO":
            iso = "MX"
        case "CANADA":
            iso = "CA"
        default:
            iso = "US"
        }
        
        return iso
    }
    
    public func getPhoneModelByIso(iso: String) -> PhoneModel {
        guard let firstModel = self.phoneModels.first(where: {$0.countryFlag == iso}) else {
            return PhoneModel(iso: "US", code: "+1", nameToLocalize: "United States", masks: ["(###)###-####"])
        }
        return firstModel
    }
    
    static public func numberFormatter(values: [String], phonesISO: [String?]) -> [String] {
        let formattedNumbers = values.enumerated().map { (index, currentPhone) in
            var array = currentPhone.components(separatedBy: " ")
            if let firstComponent = array.first, firstComponent.contains("+") {
                array = Array(array.dropFirst())
            }
            return array.joined(separator: " ")
        }
        return formattedNumbers
    }
    
    static public func getFlag(country: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            if let unicodeScalar = UnicodeScalar(base + v.value) {
                s.unicodeScalars.append(unicodeScalar)
            }
        }
        return s
    }
    
    public func getPhoneMask(mask: String?) -> String {
        guard let mask = mask else { return "(00) 000-0000"}
        return mask.replacingOccurrences(of: "#", with: "0")
    }
}
