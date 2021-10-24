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

struct GroupDetailView: View {
    
    @State var invitedMember:String = ""
    @State var state:Bool = true
    @State var group:Group
    @State var showAlert:Bool = false
    @State var createSucessed:Bool? = false
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
                        .disabled(state)
                        .onAppear {setting()}
                        
                }
                Text("Group information:".localized)
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .textFieldStyle(.roundedBorder)
                    .padding(.top)
                    .padding(.leading)
                TextView(text: $group.info, textStyle: $textStyle)
                    .padding(.horizontal)
                    .padding(.top, 5)
                    .disabled(state)
                    .onAppear {setting()}
                    Button {
                        if(isCreater()) {
                            createGroup()
                            self.showAlert = true
                            
                        }
                    } label: {
                        Text(isCreater() ? "Create".localized:"Edit".localized)
                            .frame(minWidth:50, minHeight: 30)
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .padding(.horizontal)
                            .foregroundColor(.black)
                            .background(Color.orange)
                            .disabled(state)
                            .hidden(state)
                            .onAppear {setting()}
                    }
                    .padding()
                    .alert(isPresented: $showAlert) { () -> Alert in
                        return Alert(title: Text(createSucessed! ? "Creat Group successed":"Creat Group failed"),
                                         dismissButton:.default(Text("OK".localized), action:{
//                            NavigationLink("", tag: true, selection: $createSucessed, destination: {GroupListView()})
                        }))
                    }
            }
                .tabItem {
                    Image("file")
                    Text("Group info".localized)
                }
            VStack {
                HStack {
                    if(isLeader()) {
                        Text("Invite member:".localized)
                        TextField( "", text: $invitedMember)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color.init(UIColor(rgba: darkGreen)))
                                .padding(.trailing)
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
            }
                .tabItem {
                    Image("groupmember")
                    Text("Group member".localized)
                }
        
        }
        .onAppear {
            if(!isCreater()) {getGroupMemberList()}
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
    func setting() {
        if(isLeader() || isCreater()){
            self.state = false
        }
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
    
    func createGroup() {
        let url = GroupCreatUrl
        let temp = """
        {"group_name":"\(group.name)",
            "group_leader_name":"\(settingStorage.account)",
            "group_info":"\(group.info)",
            "language": "\(language)",
            "verification": "0",
            "open":"1",
            "coi_name":"\(coi)"}
"""
        let parameters:[String:String] = ["group_information":temp]
        let publisher:DataResponsePublisher<NewGroupMessage> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: { (values) in
                print(values.debugDescription)
                let message = values.value?.message ?? ""
                if(message == "create group successed!") { createSucessed = true }
                else { createSucessed = false }
            })
    }
    func inviteGroupMember() {
        let url = GroupInviteUrl
        let temp = """
        { "sender_name" = "\(settingStorage.account)",

"""
    }
    
}

class GroupMemberList:Decodable {
    let result:[GroupMember]
}

class NewGroupMessage:Decodable {
    var message:String
    
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(Group(id: -1, name: "", leaderId: -1, info: ""))
    }
}


