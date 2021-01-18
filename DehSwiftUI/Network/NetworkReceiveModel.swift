//
//  NetworkReceiveModel.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2021/1/14.
//  Copyright © 2021 mmlab. All rights reserved.
//

import Foundation

class LoginModel:Decodable{
    var username:String!
    var user_id:Int!
    var nickname:String!
    var email:String!
    var role:String!
    var birthday:String!
    var message:String!
}
