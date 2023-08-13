//
//  AccountViewModel.swift
//  PhoneFieldNewComponent
//
//  Created by Bruno Marques on 13/08/23.
//

import Foundation


class AccountViewModel: ObservableObject {
    @Published var phones: [String] = ["555 555 5555", "(333) 3333333", "(111) 111-1111"]
}
