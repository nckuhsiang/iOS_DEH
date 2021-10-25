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
    
    @State private var cancellable: AnyCancellable?
    @EnvironmentObject var settingStorage:SettingStorage
    var body: some View {
        List {
            
        }
    }
}
extension GroupMessageView {
    func getGroupMessage() {
        let url = GroupGetNotifiUrl
        let temp = """
        {
            "username":"\(settingStorage.account)"
        }
        """
        let parameters = ["notification":temp]
        let publisher:DataResponsePublisher<GroupMessage> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: { (values) in
                print(values.debugDescription)
                
            })
    }
}

struct GroupMessageView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMessageView()
    }
}
