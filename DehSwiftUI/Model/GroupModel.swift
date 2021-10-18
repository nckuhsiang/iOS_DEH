//
//  GroupModel.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2021/4/14.
//  Copyright © 2021 mmlab. All rights reserved.
//

import Foundation
import SwiftUI

class Group:Identifiable,Decodable,Hashable{
    
    var id:Int
    var name:String
    var leaderId:Int
    var info:String
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case leaderId = "learderId"
        case info = "group_info"
    }
    init(id:Int,name:String, leaderId:Int, info:String) {
        self.id = id
        self.name = name
        self.leaderId = leaderId
        self.info = info
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
    }
}
