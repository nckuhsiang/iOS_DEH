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
//    var baby = Baby()
    @State private var links = [URL]()
    @State private var cancellable: AnyCancellable?
    
    func uploadImagePublisher(uiImage: UIImage) ->  DataResponsePublisher<UploadImageResult> {
        
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID aa1111aaaa",
        ]
        return AF.upload(multipartFormData: { (data) in
            let imageData = uiImage.jpegData(compressionQuality: 0.9)
            data.append(imageData!, withName: "image")
            
        }, to: "https://api.imgur.com/3/upload", headers: headers)
            .publishDecodable(type: UploadImageResult.self, queue: .main)
        
        
    }
    
    func upload() {
        
        let publisher1 = self.uploadImagePublisher(uiImage: UIImage(named: "peter1")!)
        let publisher2 = self.uploadImagePublisher(uiImage: UIImage(named: "peter2")!)
        
        self.cancellable = publisher1.zip(publisher2)
            .sink(receiveValue: { (values) in
                if let link = values.0.value?.data.link {
                    self.links.append(link)
                }
                if let link = values.1.value?.data.link {
                    self.links.append(link)
                }
            })
    }
    
    var body: some View {
        
        
        VStack(spacing: 15) {
            ForEach(links, id: \.self) { (link) in
                Text("\(link)")
                    .onTapGesture {
                        UIApplication.shared.open(link)
                }
            }
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
