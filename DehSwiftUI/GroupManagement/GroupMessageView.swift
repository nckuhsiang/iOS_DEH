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
    
    @State var groupNotificationList: [GroupNotification] = []
    @State private var cancellable: AnyCancellable?
    @State var noMessageAlertState:Bool = false
    @State var actionSheetState:Bool = false
    @EnvironmentObject var settingStorage:SettingStorage
    var body: some View {
        List {
            ForEach(self.groupNotificationList) { groupNotification in
                Button {
                    actionSheetState = true
                } label: {
                    Text("\(groupNotification.senderName)" + " invite you to join the group".localized)
                        .font(.system(size: 16, weight: .medium, design: .default))
                }
                .padding()
                .actionSheet(isPresented: $actionSheetState) {
                    ActionSheet(title: Text("Join".localized),
                                message: Text("Would you want to join ".localized + "\(groupNotification.groupName)?"),
                                buttons: [
                                    .default(Text("Agree".localized)) {
                                        ResponseGroupMessage(senderName: groupNotification.senderName, groupId: groupNotification.groupId,returnAction: "Agree".localized)
                                    },
                                    .destructive(Text("Reject")) {
                                        ResponseGroupMessage(senderName: groupNotification.senderName, groupId: groupNotification.groupId,returnAction: "Reject".localized)
                                        
                                    },
                        .cancel()
                    ])
                }
            }
        }
            .padding(0)
            .onAppear {getGroupMessageList()}
            .listStyle(PlainListStyle())
//        .alert(isPresented: $alertState) {
//            return Alert(title: Text("No Message"), message: Text("There are currently no group messages"), dismissButton: .none)
//        }
    }
}
extension GroupMessageView {
    func getGroupMessageList() {
        let url = GroupGetNotifiUrl
        let temp = """
        {
            "username":"\(settingStorage.account)"
        }
        """
        let parameters = ["notification":temp]
        let publisher:DataResponsePublisher<GroupNotificationList> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher.sink(receiveValue: { values in
            let message = values.value?.message ?? ""
            if(message == "have notification") {
                self.groupNotificationList = values.value?.result ?? []
            }
        })
    }
    func ResponseGroupMessage(senderName:String, groupId:Int, returnAction:String) {
        let url = GroupInviteUrl
        let temp = """
        {
            "sender_name":"\(senderName)",
            "receiver_name":"\(settingStorage.account)",
            "group_id":"\(groupId)",
            "message_type":"\(returnAction)",
            "coi_name":"\(coi)"
        }
        """
        let parameters = ["group_message_info":temp]
        let publisher:DataResponsePublisher<GroupMessage> =  NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher.sink(receiveValue: { values in
        })
        
    }
}
class GroupNotificationList:Decodable {
    var result:[GroupNotification]
    var message:String
    
    init(result:[GroupNotification], message:String) {
        self.result = result
        self.message = message
    }
}

struct GroupMessageView_Previews: PreviewProvider {
    static var previews: some View {
        GroupMessageView()
    }
}
