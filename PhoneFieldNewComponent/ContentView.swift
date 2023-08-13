//
//  ContentView.swift
//  Profile Settings Screen SwifUI
//
//  Created by Bruno Nascimento Marques on 29/06/23.
//

import SwiftUI
import Combine


enum Colors {
    static let greenColor = Color(red: 0.49, green: 0.74, blue: 0.04)
    static let grayColor = Color(red: 0.97, green: 0.97, blue: 0.97)
    static let grayishColor = Color(red: 0.39, green: 0.39, blue: 0.39)
}

struct ContentView: View {
    
    @StateObject var viewModel: AccountViewModel = AccountViewModel()
    
    @State private var selectedOptions: Int = 0
    @State private var isBasicInfoOpen: Bool = true
    @State private var firstNameText: String = ""
    @State private var lastNameText: String = ""
    @State private var preferredNameText: String = ""
    @State private var documentNumber: String = ""
    @State private var billingDocument: String = ""
    @State private var firstPhoneNumber: String = ""
    @State private var phoneNumber: [String] = []
    private var options = ["Account", "Notifications"]
    
    
    let phoneModel = PhoneModel(iso: "+1", code: "US", nameToLocalize: "United States", masks: ["(###) ###-####"])
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    CustomSegmentedControl(selectedOptions: $selectedOptions, options: options)
                    ProfileSettingsTitle()
                    BasicInfoStack(isBasicInfoOpen: $isBasicInfoOpen)
                    Divider()
                    if isBasicInfoOpen {
                        VStack(alignment: .leading, spacing: 16) {
                            Spacer()
                                .frame(height: 8)
                            HStack {
                                Spacer()
                                BasicInfoImageComponent()
                                Spacer()
                            }
                            Divider()
//                            SimpleField(fieldTitle: "First name", placeholder: "Bruno", isOptional: false, text: $firstNameText)
                            
//                            SimpleField(fieldTitle: "Last name", placeholder: "Marques", isOptional: false, text: $lastNameText)
                            
//                            SimpleFieldWithDescription(fieldTitle: "Preferred name", placeholder: "Bruques", isOptional: true, text: $preferredNameText, description: "Your preferred name will be visible to your community such as in your profile, home screen, messages and requests, but it won't change your billing information.")
                            
//                            SimpleField(fieldTitle: "Document number", placeholder: "123.456.789-00", isOptional: true, text: $documentNumber)
                            
//                            SimpleField(fieldTitle: "Billing document", placeholder: "98765", isOptional: true, text: $billingDocument)
//                            MultipleFieldsView(fieldTitle: "Phone Number",
//                                               placeholder: "(00) 00000-0000",
//                                               isOptional: false,
//                                               firstField: $firstPhoneNumber,
//                                               textFields: $phoneNumber)
                            
                            PhoneMultiActionTextField(phoneModel: self.phoneModel,
                                                      firstPhone: self.viewModel.phones.first ?? "",
                                                      phones: self.viewModel.phones)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .padding()
        .ignoresSafeArea()
        .padding(.top)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomSegmentedControl: View {
    @Binding var selectedOptions: Int
    let options: [String]
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            ForEach(self.options.indices, id: \.self) { index in
                HStack(alignment: .center, spacing: 8) {
                    Text("\(self.options[index])")
                        .foregroundColor(self.selectedOptions == index ? Colors.grayishColor : Colors.greenColor)
                        .frame(maxWidth: .infinity, minHeight: 21, maxHeight: 21, alignment: .center)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(self.selectedOptions == index ? .white : Colors.grayColor)
                .cornerRadius(4)
                .onTapGesture {
                    withAnimation {
                        self.selectedOptions = index
                    }
                }
            }
        }
        .padding(4)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(red: 0.97, green: 0.97, blue: 0.97))
        .cornerRadius(6)
    }
}

struct ProfileSettingsTitle: View {
    var body: some View {
        VStack(alignment: .leading,spacing: 18) {
            Text("Profile Settings")
                .font(.system(size: 32))
                .bold()
            Rectangle()
                .foregroundColor(Colors.greenColor)
                .frame(width: 72, height: 4)
        }
        .padding(8)
    }
}

struct BasicInfoStack: View {
    @State private var rotationAngle: Double = 0
    @Binding var isBasicInfoOpen: Bool
    var body: some View {
        HStack {
            HStack {
                Image("personIcon")
                Text("Basic informations")
                    .foregroundColor(Colors.greenColor)
            }
            Spacer()
            Image("arrowIcon")
                .rotationEffect(.degrees(self.rotationAngle))
        }
        .padding(16)
        .onTapGesture {
            self.rotationAngle += 180
            self.isBasicInfoOpen.toggle()
        }
        .animation(.easeInOut, value: 0)
    }
}

struct BasicInfoImageComponent: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image("SpiderManPoster")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 100, height: 100)
            Image("cameraIcon")
                .padding(8)
                .background(Colors.greenColor)
                .clipShape(Circle())
            
                .frame(width: 50, height: 40)
        }
    }
}

struct SimpleField: View {
    let fieldTitle: String
    let placeholder: String
    let isOptional: Bool
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(fieldTitle)")
                        .font(.system(size: 14))
                    if isOptional {
                        Spacer()
                        Text("OPTIONAL")
                            .font(.system(size: 10))
                            .foregroundColor(Colors.grayishColor)
                    }
                }
                TextField("\(placeholder)", text: $text)
                    .padding(8)
                    .border(Colors.grayColor, width: 1)
                    .cornerRadius(4)
                
            }
            Divider()
        }
    }
}

struct SimpleFieldWithDescription: View {
    let fieldTitle: String
    let placeholder: String
    let isOptional: Bool
    @Binding var text: String
    let description: String
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(fieldTitle)")
                        .font(.system(size: 14))
                    if isOptional {
                        Spacer()
                        Text("OPTIONAL")
                            .font(.system(size: 10))
                            .foregroundColor(Colors.grayishColor)
                    }
                }
                TextField("\(placeholder)", text: $text)
                    .padding(8)
                    .border(Colors.grayColor, width: 1)
                    .cornerRadius(4)
                Text("\(description)")
                    .font(.system(size: 12))
                    .foregroundColor(Colors.grayishColor)
            }
            Divider()
        }
    }
}

struct MultipleFieldsView: View {
    let fieldTitle: String
    let placeholder: String
    let isOptional: Bool
    @Binding var firstField: String
    @Binding var textFields: [String]
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(fieldTitle)")
                        .font(.system(size: 14))
                    if isOptional {
                        Spacer()
                        Text("OPTIONAL")
                            .font(.system(size: 10))
                            .foregroundColor(Colors.grayishColor)
                    }
                }
                VStack(spacing: 8) {
                    TextField(placeholder, text: $firstField)
                        .onReceive(Just(firstField), perform: { text in
                            self.firstField = Mask.shared.formateValue(text)
                        })
                        .padding(8)
                        .border(Colors.grayColor, width: 1)
                        .cornerRadius(4)
                    
                    ForEach(textFields.indices, id: \.self) { index in
                        HStack {
                            TextField(placeholder, text: $textFields[index])
                                .onReceive(Just(textFields[index]), perform: { text in
                                    self.textFields[index] = Mask.shared.formateValue(text)
                                })
                                .padding(8)
                                .border(Colors.grayColor, width: 1)
                                .cornerRadius(4)
                            ZStack {
                                Image("trashIcon")
                                    .padding(7)
                            }
                            .border(Colors.grayColor, width: 1)
                            .cornerRadius(4)
                            .onTapGesture {
                                self.textFields.remove(at: index)
                            }
                        }
                    }
                }
                HStack {
                    Image("plusIcon")
                    Text("Add more")
                        .font(.system(size: 14))
                        .foregroundColor(Colors.greenColor)
                }
                .padding(8)
                .border(Colors.grayColor, width: 1)
                .cornerRadius(4)
                .onTapGesture {
                    self.textFields.append("")
                }
            }
            Divider()
        }
    }
}

struct PhoneMultiActionTextField: View {
    @State var phoneModel: PhoneModel
    @State var firstPhone: String
    @State var phones: [String]

    var body: some View {
        VStack(alignment: .leading) {
            PhoneActionTextField(phoneModel: phoneModel,
                                 hasDeleteButton: false,
                                 phone: $firstPhone,
                                 deleteAction: { return })
            
            ForEach(self.phones.indices, id: \.self) { index in
                if self.phones.count >= index {
                    PhoneActionTextField(phoneModel: phoneModel,
                                         hasDeleteButton: true,
                                         phone: $phones[index],
                                         deleteAction: { self.phones.remove(at: index) })
                }
            }
            
            HStack {
                Image("plusIcon")
                Text("Add more")
                    .font(.system(size: 14))
                    .foregroundColor(Colors.greenColor)
            }
            .padding(8)
            .border(Colors.grayishColor, width: 1)
            .cornerRadius(4)
            .onTapGesture {
                self.phones.append("")
            }
        }
    }
}

struct PhoneActionTextField: View {
    let phoneModel: PhoneModel
    let hasDeleteButton: Bool
    @Binding var phone: String
    let deleteAction: () -> Void
    
    var body: some View {
        HStack {
            HStack {
                Text(CountryFormatter.getFlag(country: "US"))
                    .padding(8)
                Text(phoneModel.countryFlag)
                    .padding(.trailing, 8)
                Divider()
                    .overlay(Colors.grayishColor)
                PhoneTextField(phoneModel: phoneModel,
                               phone: $phone)
                
            }
            .border(Colors.grayishColor, width: 1)
            if hasDeleteButton {
                ZStack {
                    Image("trashIcon")
                        .padding(7)
                }
                .border(Colors.grayishColor, width: 1)
                .cornerRadius(4)
                .onTapGesture {
                    self.deleteAction()
                }
            }
        }
    }
}

struct PhoneTextField: View {
    let phoneModel: PhoneModel
    @Binding var phone: String
    
    var maskFormat = "(###) ###-####"
    
    var body: some View {
        TextField(getMaskPlaceholder(), text: $phone)
            .onReceive(Just(phone), perform: { text in
//                self.phone = Mask.shared.formateValue(text)
            })
    }
    private func getMaskPlaceholder() -> String {
        return phoneModel.countryMasks.first?.replacingOccurrences(of: "#", with: "0") ?? "(000) 000-0000"
    }
    
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
