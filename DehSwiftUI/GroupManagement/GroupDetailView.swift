//
//  GroupDetailView.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/10/17.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI


struct GroupDetailView: View {
    
    @State var groupName:String = ""
    @State var groupInfo:String = ""
    @State private var message = ""
    @State private var textStyle = UIFont.TextStyle.body
    
    var body: some View {
        TabView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Group name：")
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .padding(.leading)
                        .padding(.top)
                    TextField("", text: $groupName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.trailing)
                        .padding(.top)
                }
                Text("Group information：")
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .textFieldStyle(.roundedBorder)
                    .padding(.top)
                    .padding(.leading)
                TextView(text: $message, textStyle: $textStyle)
                    .padding(.horizontal)
                    .padding(.top, 5)
                Button {
                    
                } label: {
                    Text("Edit")
                        .frame(minWidth:50, minHeight: 30)
                        .font(.system(size: 20, weight: .regular, design: .default))
                        .padding(.horizontal)
                        .foregroundColor(.black)
                        .background(Color.orange)
                }
                .padding()
            }
                .tabItem {
                    Image("file")
                    Text("Group info")
                }
            Text("test")
                .tabItem {
                    Image("groupmember")
                    Text("Group member")
                }
        
        }
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView()
    }
}


