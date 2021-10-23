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
    @State var groupNameList:[GroupName] = []
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            List {
                ForEach(self.groupNameList,id: \.self.name) { groupName in
                    if(groupName.name.hasPrefix(searchText)) {
                        Button {
                            
                        } label: {
                            Text(groupName.name)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {getGroupNameList()}
    }
}
extension GroupSearchView {
    func getGroupNameList() {
        let url = GroupGetListUrl
        print(settingStorage.account)
        let parameters = ["username":settingStorage.account,
                          "coi_name":coi]
        let publisher:DataResponsePublisher<GroupNameList> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                print(values.debugDescription)
                self.groupNameList = values.value?.result ?? []
            })
    }
}



struct GroupNameList:Decodable{
    let result:[GroupName]
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
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            TextField("Search ...".localized, text: $text)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.vertical)
                .padding(.trailing)
                .onTapGesture {
                    self.isEditing = true
                }
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel".localized)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
