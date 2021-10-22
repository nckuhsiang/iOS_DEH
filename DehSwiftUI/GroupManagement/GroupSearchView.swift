//
//  GroupSearchView.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/10/14.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire

struct GroupSearchView: View {
    
    @EnvironmentObject var settingStorage:SettingStorage
    @State var searchText:String = ""
    @State var groupNameList:[String] = []
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            List {
                ForEach(self.groupNameList,id: \.self) { groupName in
                    Button {
                        
                    } label: {
                        Text(groupName)
                    }
                }
            }
        }
        .onAppear {getGroupNameList()}
    }
}
extension GroupSearchView {
    func getGroupNameList() {
        let url = GroupGetGroupUrl
        print(settingStorage.account)
        let parameters = ["username":settingStorage.account,
                          "coi_name":coi]
        let publisher:DataResponsePublisher<GroupNameList> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                print(values.debugDescription)
            })
    }
}



struct GroupNameList:Decodable{
    let result:[Group]
}


struct GroupSearchView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSearchView()
    }
}
struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    var body: some View {
        HStack {
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
