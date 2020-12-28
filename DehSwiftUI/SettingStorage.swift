//
//  SettingStorage.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/10.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI
//import Combine

final class SettingStorage:ObservableObject{
//    let objectWillChange = PassthroughSubject<Void, Never>()
    init(){
        UserDefaults.standard.register(defaults: [
            "advancedSetting" : false,
            "searchDistance" : 10.0,
            "searchNumber" : 50.0,
            "account" : "Guest",
            "password" : "",
            "loginState" : false,
//            "favorite" : [testxoi[0]],
        ])
        if let data = UserDefaults.standard.data(forKey: "favorite") {
            if let decoded = try? JSONDecoder().decode([String:[XOI]].self, from: data) {
//                    self.XOIs["favorite"] = decoded
                    
                    XOIs = decoded
                    return
                }
                else{
                    XOIs = [
                        "favorite" : [],
                        "nearby" : [testxoi[1]],
                        "group" : [testxoi[2]],
                        "mine" : [],
                    ]
                }
            }
        else{
            XOIs = [
                "favorite" : [],
                "nearby" : [testxoi[1]],
                "group" : [testxoi[2]],
                "mine" : [],
            ]
        }
//        XOIs["favorite"] = []
    }
    // 讀取跟讀取設定 當變更時所有用到的人都會自動變更
    @Published var advancedSetting:Bool = UserDefaults.standard.bool(forKey: "advancedSetting"){
        didSet{
            UserDefaults.standard.set(advancedSetting,forKey: "advancedSetting")
        }
    }
    @Published var searchDistance:Double = UserDefaults.standard.double(forKey: "searchDistance"){
        didSet{
            UserDefaults.standard.set(searchDistance,forKey: "searchDistance")
        }
    }
    @Published var searchNumber:Double = UserDefaults.standard.double(forKey: "searchNumber"){
        didSet{
            UserDefaults.standard.set(searchNumber,forKey: "searchNumber")
        }
    }
    @Published var account:String = UserDefaults.standard.string(forKey: "account") ?? ""{
        didSet{
            UserDefaults.standard.set(account,forKey: "account")
        }
    }
    @Published var password:String = UserDefaults.standard.string(forKey: "password") ?? ""{
        didSet{
            UserDefaults.standard.set(password,forKey: "password")
        }
    }
    @Published var loginState:Bool = UserDefaults.standard.bool(forKey: "loginState"){
        didSet{
            UserDefaults.standard.set(loginState,forKey: "loginState")
        }
    }
    //正常來說不應該擺在這邊
    @Published var XOIs:[String:[XOI]]!{
        didSet{
            save()
        }
    }
    
    let emptyXOIs = ["favorite" : [],
    "nearby" : [],
    "group" : [],
    "mine" : [],
    ]
    func save() {
        if let encoded = try? JSONEncoder().encode(XOIs) {
            UserDefaults.standard.set(encoded, forKey: "favorite")
        }
    }
}
