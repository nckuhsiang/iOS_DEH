//
//  Setting.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/3.
//  Copyright © 2020 mmlab. All rights reserved.
// warning nw_protocol_get_quic_image_block_invoke dlopen libquic failed 只會發生在模擬器上，請忽略
// [AXRuntimeCommon] Unknown client: DehSwiftUI 似乎這個也是

import SwiftUI
import Alamofire
import Combine

struct Setting: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var advancedSetting = true
    @State var searchDistance = 10.0
    @State var searchNumber = 50.0
    @State var account = ""
    @State var password = ""
    @State var loginButtonText = "login"
    @State var loginState = false
    @State var loginTriggerAlert = false
    @EnvironmentObject var settingStorage:SettingStorage
    @State private var cancellable: AnyCancellable?
    var body: some View {
        Form{
            // toggle trigger warning 
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
            
            Section(header: Text(self.loginButtonText).foregroundColor(.blue)){
                TextField("Account", text: $account)
                    .keyboardType(.asciiCapable)
                    .disableAutocorrection(true)
                    .disabled(loginState)
                
                SecureField("Password", text: $password)
                    .keyboardType(.asciiCapable)
                    .disableAutocorrection(true)
                    .disabled(loginState)
            }
            Button(action: {
                //MARK:-
                if(loginState == false){
                    login()
//                    UITableView.appearance().backgroundColor = UIColor(rgba:darkGreen)
//
//                    self.presentationMode.wrappedValue.dismiss()
                }
                else{
                    logout()
                }
            }, label: {
                Text(self.loginButtonText)
            })
            .alert(isPresented: $loginTriggerAlert) {() -> Alert in
                        let greetingMessage = "Login Success"
                return Alert(title: Text(greetingMessage),
                             dismissButton:.default(Text("Ok"), action: {
                                UITableView.appearance().backgroundColor = UIColor(rgba:darkGreen)

                                self.presentationMode.wrappedValue.dismiss()
                             })
                             )
            }


                
            

        }
        //讀取存在手機內的設定
        .onAppear(){
            UITableView.appearance().backgroundColor = .systemGroupedBackground
            self.advancedSetting = self.settingStorage.advancedSetting
            self.searchDistance = self.settingStorage.searchDistance
            self.searchNumber = self.settingStorage.searchNumber
            self.account = self.settingStorage.account
            
            self.loginState = self.settingStorage.loginState
            if(self.settingStorage.loginState == true){
                loginButtonText = "Logout"
                self.password = "00000000"
            }
            else{
                loginButtonText = "Login"
            }
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
//        .onTapGesture {
//            self.hideKeyboard()
//        }
        
    }
    func login(){
        let parameters:Parameters = [
            "username" : self.account,
            "password" : self.password.md5(),
            "coi_name" : coi,
        ]
        let url = UserLoginUrl
        let publisher:DataResponsePublisher<LoginModel> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                if let _ = values.value?.message{
                    print("User" + "\(values.value?.message ?? "Not Found")")
                }
                else{
                    self.settingStorage.account = self.account
                    self.settingStorage.password = self.password.md5()
                    self.settingStorage.userID = "\(values.value?.user_id ?? 0)"
                    self.settingStorage.loginState = true
                    self.loginState = true
                    self.loginButtonText = "logout"
                    self.loginTriggerAlert = true
                    

                }
            })
    }
    func logout(){
        self.settingStorage.account = ""
        self.settingStorage.password = ""
        self.account = ""
        self.password = ""
        self.settingStorage.userID = "-1"
        self.settingStorage.loginState = false
        self.loginState = false
        self.loginButtonText = "login"
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
            .environmentObject(SettingStorage())
    }
}
