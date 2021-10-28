//
//  GroupDetailView.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/10/17.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI
import Alamofire
import Combine
import simd

struct GroupDetailView: View {
    
    @State var invitedMemberName:String = ""
    @State var textState:Bool = true
    
    @State var buttonState:Bool = true
    @State var buttonText:String = ""
    @State var isEdit:Bool = true
    
    @State var alertState:Bool = false
    @State var alertText:String = ""
    
    @State var group:Group
    @State private var textStyle = UIFont.TextStyle.body
    @State private var cancellable: AnyCancellable?
    @State var groupMembers:[GroupMember] = []
    @EnvironmentObject var settingStorage:SettingStorage
    
    init(_ group:Group) {
        self.group = group
    }
    var body: some View {
        TabView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Group name:".localized)
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .padding(.leading)
                        .padding(.top)
                                    
                    TextField("", text: $group.name)
                        .textFieldStyle(.roundedBorder)
                        .padding(.trailing)
                        .padding(.top)
                        .disabled(textState)
                }
                Text("Group information:".localized)
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .textFieldStyle(.roundedBorder)
                    .padding(.top)
                    .padding(.leading)
                TextView(text: $group.info, textStyle: $textStyle)
                    .padding(.horizontal)
                    .padding(.top, 5)
                    .disabled(textState)
                Button {
                    if(isCreater()) {
                        CreateGroup()
                    }
                    if(isLeader()) {
                        if(isEdit) {
                            self.textState = false
                            buttonText = "Save".localized
                            self.isEdit = false
                        }
                        else {
                            UpdateGroup()
                            self.alertState = true
                        }
                    }
                } label: {
                    Text(buttonText)
                        .frame(minWidth:50, minHeight: 30)
                        .font(.system(size: 20, weight: .regular, design: .default))
                        .padding(.horizontal)
                        .foregroundColor(.black)
                        .background(Color.orange)
                        .disabled(buttonState)
                        .hidden(buttonState)

                }
                    .padding()
                    .alert(isPresented: $alertState) { () -> Alert in
                        return Alert(title: Text(alertText),dismissButton:.default(Text("OK".localized), action:{}))
                    }
            }
                .tabItem {
                    Image("file")
                    Text("Group info".localized)
                }
                .onAppear {
                    if(isCreater()) {
                        self.buttonState = false
                        self.textState = false
                        buttonText = "Create".localized
                    }
                    else if(isLeader()) {
                        self.buttonState = false
                        buttonText = "Edit".localized
                    }
                }
            VStack {
                HStack {
                    if(isLeader()) {
                        Text("Invite member:".localized)
                        TextField( "", text: $invitedMemberName)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            InviteGroupMember()
                            self.alertState = true
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color.init(UIColor(rgba: darkGreen)))
                                .padding(.trailing)
                        }
                            .alert(isPresented: $alertState) { () -> Alert in
                                return Alert(title: Text(alertText),dismissButton:.default(Text("OK".localized), action:{}))
                            }
                    }
                }
                    .padding(.vertical)
                    .padding(.leading)
                Text("Group member")
                    .font(.system(size: 20, weight: .bold, design: .default))
                List(){
                    ForEach(self.groupMembers) { groupMember in
                        HStack {
                            Image(groupMember.memberRole == "leader" ? "leaderrr":"leaderlisticon")
                            Text(groupMember.memberName)
                        }
                    }
                }
                    .listStyle(PlainListStyle())
                    .onAppear {
                        if(!isCreater()) {getGroupMemberList()}
                    }
            }
                .tabItem {
                    Image("groupmember")
                    Text("Group member".localized)
                }
        }
        
    }
}
extension GroupDetailView {
    func isLeader() -> Bool{
        if(settingStorage.userID == String(group.leaderId)) {return true}
        else {return false}
    }
    func isCreater() -> Bool {
        if(group.id == -1) {return true}
        else {return false}
    }
    func getGroupMemberList() {
        let url = GroupGetMemberUrl
        let parameters =
            ["group_id":"\(group.id)",
            "coi_name":coi]
        
        let publisher:DataResponsePublisher<GroupMemberList> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                print(values.debugDescription)
                groupMembers = values.value?.result ?? []
            })
    }
    func CreateGroup() {
        let url = GroupCreatUrl
        let temp = """
        {
            "group_name":"\(group.name)",
            "group_leader_name":"\(settingStorage.account)",
            "group_info":"\(group.info)",
            "language": "\(language)",
            "verification": "0",
            "open":"1",
            "coi_name":"\(coi)"
        }
"""
        let parameters:[String:String] = ["group_information":temp]
        let publisher:DataResponsePublisher<GroupMessage> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: { (values) in
                print(values.debugDescription)
                alertText = values.value?.message ?? ""
                self.alertState = true
            })
    }
    func InviteGroupMember() {
        let url = GroupInviteUrl
        let temp = """
        {
            "sender_name":"\(settingStorage.account)",
            "receiver_name":"\(invitedMemberName)",
            "group_id":"\(group.id)",
            "message_type":"Invite",
            "coi_name":"\(coi)"
        }
        """
        let parameters = ["group_message_info":temp]
        let publisher:DataResponsePublisher<GroupMessage> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: { (values) in
                print(values.debugDescription)
                alertText = values.value?.message ?? ""
            })
    }
    func UpdateGroup() {
        let url = GroupUpdateUrl
        let temp = """
        {
        "group_name": "\(group.name)",
        "group_info": "\(group.info)",
        "group_id": "\(group.id)"
        }
        """
        let parameters = ["group_update_info":temp]
        let publisher:DataResponsePublisher<GroupMessage> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: { (values) in
                print(values.debugDescription)
                alertText = values.value?.message ?? ""
            })
    }
    
}
class GroupMemberList:Decodable {
    let result:[GroupMember]
}


struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(Group(id: -1, name: "", leaderId: -1, info: ""))
    }
}


