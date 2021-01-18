//
//  TestAlamofire.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/22.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI
import Alamofire
import Combine
struct UploadImageResult: Decodable {
    struct Data: Decodable {
        let link: URL
    }
    let data: Data
}
struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
        }
    }

struct ContentView2: View {
    @State private var cancellable: AnyCancellable?
    
    func upload2(){
        let parameters:Parameters = [
            "user_name" : "GuestFromIosLite/Micro",
            "coi_name" : "deh",
        ]
        let url = GroupGetListUrl
        let publisher = NetworkConnector().getDataPublisher(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
//                print(values.data?.JsonPrint())
                print("")
            })
    }
    func upload(){
        let parameters:Parameters = [
            "username" : "et0",
            "password" : "et00".md5(),
            "coi_name" : "deh",
            "ula" : "22.997",
            "ulo" : "120.221",
        ]
        let url = UserLoginUrl
        let publisher:DataResponsePublisher<LoginModel> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                if let _ = values.value?.message{
                    print("\(String(describing: values.value?.message))")
                }
                else{
                    print(values.value?.username)
                }
            })
    }
    
    var body: some View {
        
        
        VStack(spacing: 15) {
            Button(action: {
                self.upload()
            }) {
                Text("upload")
            }
        }
        .onDisappear {
            self.cancellable = nil
        }
        
    }
}

