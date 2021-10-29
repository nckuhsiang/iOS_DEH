//
//  GroupMessageView.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/10/17.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire

struct GroupMessageView: View {
    
    @State var groupMessage:String = ""
    @State private var cancellable: AnyCancellable?
    @EnvironmentObject var settingStorage:SettingStorage
    var body: some View {
        List {
            
        }
    }
}
extension GroupMessageView {
   
}

struct GroupMessageView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMessageView()
    }
}
