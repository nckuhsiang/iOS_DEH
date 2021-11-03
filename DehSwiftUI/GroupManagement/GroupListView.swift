//
//  GroupList.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/10/14.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire
struct GroupListView: View {
    
    @State var messageNotify: Bool = false
    @State var selection: Int? = nil
    @State var cellSelection: Int? = nil
    @State private var groupListCancellable: AnyCancellable?
    @State private var messageCancellable2: AnyCancellable?
    @EnvironmentObject var settingStorage:SettingStorage
    @State var groups:[Group] = []

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            List {
                    ForEach (self.groups) { group in
                        NavigationLink(tag: group.id, selection: $cellSelection) {
                            GroupDetailView(group)
                        } label: {
                            Button {
                                self.cellSelection = group.id
                            } label: {
                                    HStack{
                                        Image((String(group.leaderId ?? -1) == settingStorage.userID) ? "leaderrr":"leaderlisticon")
                                        VStack (alignment: .leading, spacing: 0){
                                            Text(group.name)
                                                .font(.system(size: 20, weight: .medium, design: .default))
                                                .foregroundColor(.black)
                                            Text((String(group.leaderId ?? -1) == settingStorage.userID) ? "Leader".localized:"Member".localized)
                                                .font(.system(size: 16, weight: .light, design: .default))
                                                .foregroundColor(.black)
                                        }
                                    }
                            }
                        }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Group list".localized)
            .navigationBarItems(trailing: HStack {
                NavigationLink(tag: 1, selection: $selection) {
                    GroupMessageView()
                } label: {
                    Button {
                            self.selection = 1
                    } label: {
                        Image(systemName: "message.circle.fill")
                            .foregroundColor(messageNotify ? .red:.blue)
                      }
                }
                    
                NavigationLink(tag: 2, selection: $selection) {
                    GroupSearchView()
                } label: {
                    Button(action: {
                            self.selection = 2
                    }) {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            })
            NavigationLink(tag: 3, selection: $selection) {
                GroupDetailView(Group(id: -1, name: "", leaderId: -1, info: ""))
            } label: {
                Button {
                    self.selection = 3
                } label: {
                    Text("Create a group".localized)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundColor(.white)
                        .background(Color.init(UIColor(rgba: darkGreen)))
                        .font(.system(size: 30, weight: .bold, design: .default))
                }
            }
        }
        .onAppear {
            getGroupList()
            getGroupMessage()
            
        }

    }
}
extension GroupListView{
    func getGroupList(){
        let url = GroupGetUserGroupListUrl
        let parameters:[String:String] = [
            "user_id": "\(settingStorage.userID)",
            "coi_name": coi,
            "language": language,
        ]
        let publisher:DataResponsePublisher<GroupLists> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.groupListCancellable = publisher
            .sink(receiveValue: {(values) in
                print(values.debugDescription)
                self.groups = values.value?.results ?? []
            })
    }
    func getGroupMessage() {
        let url = GroupGetNotifiUrl
        let temp = """
        {
            "username":"\(settingStorage.account)"
        }
        """
        let parameters = ["notification":temp]
        let publisher:DataResponsePublisher<GroupMessage> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.messageCancellable2 = publisher
            .sink(receiveValue: { (values) in
                print(values.debugDescription)
                let message = values.value?.message ?? ""
                if(message == "have notification") {
                    messageNotify = true
                }
                else {
                    messageNotify = false
                }
            })
    }
}
struct GroupManagement_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView()
    }
}
