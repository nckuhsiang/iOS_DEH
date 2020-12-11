//
//  Setting.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/3.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI

struct Setting: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var advancedSetting = true
    @State var searchDistance = 10.0
    @State var searchNumber = 50.0
    @State var account = ""
    @State var password = ""
    @State var loginState = false
    @EnvironmentObject var settingStorage:SettingStorage
    var body: some View {
        Form{
            
            Toggle("Advanced Setting", isOn: $advancedSetting)
                .foregroundColor(.blue)
            
            Section(header: Text("Search Distance")
                        .foregroundColor(.blue)){
                HStack{
                    Slider(value: $searchDistance,in: 0.0...20.0)
                    Spacer()
                    Text("\(searchDistance, specifier: "%.2f") km")
                }
            }
            
            Section(header: Text("Search Number").foregroundColor(.blue)){
                HStack{
                    Slider(value: $searchNumber,in: 10.0...100.0,step:1)
                    Spacer()
                    Text("\(searchNumber, specifier: "%.0f")")
                }
            }
            
            Section(header: Text("Login").foregroundColor(.blue)){
                TextField("Account", text: $account)
                    .keyboardType(.asciiCapable)
                
                SecureField("Password", text: $password)
                    .keyboardType(.asciiCapable)
            }
            Button(action: {
                self.settingStorage.account = self.account
                self.settingStorage.password = self.password.md5()
            }, label: {
                Text("Login")
            })
            
        }
        
        .onAppear(){
            UITableView.appearance().backgroundColor = .systemGroupedBackground
            self.advancedSetting = self.settingStorage.advancedSetting
            self.searchDistance = self.settingStorage.searchDistance
            self.searchNumber = self.settingStorage.searchNumber
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Settings",displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            UITableView.appearance().backgroundColor = UIColor(rgba:darkGreen)
            
        }, label: {
            Text("Cancel")
                .foregroundColor(.black)
        })
        ,trailing:
            Button(action: {
                self.settingStorage.advancedSetting = self.advancedSetting
                self.settingStorage.searchDistance = self.searchDistance
                self.settingStorage.searchNumber = self.searchNumber
                UITableView.appearance().backgroundColor = UIColor(rgba:darkGreen)
                
                self.presentationMode.wrappedValue.dismiss()
                
                
            }, label: {
                Text("Save")
                    .foregroundColor(.black)
                
            })
        )
        
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
            .environmentObject(SettingStorage())
    }
}
