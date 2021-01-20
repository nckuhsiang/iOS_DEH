//
//  XOIDetail.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/2.
//  Copyright © 2020 mmlab. All rights reserved.


import SwiftUI
import Alamofire
import Combine
struct XOIDetail: View {
    var xoi: XOI
    //only for favorite used
    @EnvironmentObject var settingStorage:SettingStorage
    @State var isFavorite = false
    @State var viewNumbers = -1
    @State private var cancellable: AnyCancellable?
    @State private var mediaCancellable: AnyCancellable?
    @State private var images:[UIImage] = [UIImage()]
    @State var index = 0
    var body: some View{
        
        VStack {
//            ZStack{
//                Image("audio_picture")
//            }
            PagingView(index: $index.animation(), maxIndex: images.count - 1) {
                ForEach(self.images, id: \.self) {
                    imageName in
                    Image(uiImage: imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 400)
                    
                }
            }
            .frame(height: 400.0)
            
            VStack(alignment: .leading) {
                HStack(){
                    Text(xoi.name)
                        .font(.title)
                    
                    Spacer()
                    
                    Image(xoi.creatorCategory)
                    
                    Button(action: {
                        print("favorite pressed")
                        // if exist then remove or not exist then add
                        if let index = settingStorage.XOIs["favorite"]?.firstIndex(of: xoi){
                            settingStorage.XOIs["favorite"]?.remove(at: index)
                            isFavorite = false
                        }
                        else{
                            settingStorage.XOIs["favorite"]?.append(xoi)
                        }
                        
                    }) {
                        Image("heart")
                        
                    }
                    
                    Button(action: {
                        print("more pressed")
                    }) {
                        Image("more")
                    }
                }
                HStack {
                    Text("Voice Commentary")
                        .foregroundColor(Color.white)
                    Spacer()
                    Image("speaker")
                }
                .frame(height: 30.0)
                .background(Color.init(UIColor(rgba:"#24c08c")))
                Text("View Numbers: " + String(viewNumbers).hidden(viewNumbers == -1))
                Text(xoi.detail)
            }
            .padding()
            Spacer()
        }
        .onAppear(){
            getViewerNumber()
            getMedia()
        }
    }
    
}
extension XOIDetail{
    
    func getViewerNumber(){
        let parameters:Parameters = [
            "poi_id": xoi.id
        ]
        let url = POIClickCountUrl
        let publisher:DataResponsePublisher<ClickCount> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                if let _ = values.value?.count{
                    viewNumbers = values.value?.count ?? -1
                }
            })
    }
//set media data in place
    func getMedia(){
        enum format:Int{
            case Commentary = 8
            case Video = 4
            case Voice = 2
            case Picture = 1
        }
//        let format = [
//            "Commentary": 8,
//            "Video": 4,
//            "Voice": 2,
//            "Picture": 1,
//        ]
        if let _ = xoi.media_set{
        for media in xoi.media_set{
            let url = media.media_url
//            print(url)
//            print(0)
            let publisher:DataResponsePublisher = NetworkConnector().getMediaPublisher(url: url)
            self.mediaCancellable = publisher
                .sink(receiveValue: {(values) in
//                    print(values.debugDescription)
//                    print(values.data?.JsonPrint())
                    switch media.media_format{
                    case format.Commentary.rawValue:
                        print("Commentary")
                    case format.Video.rawValue:
                        print("Video")
                    case format.Voice.rawValue:
                        print("Voice")
                    case format.Picture.rawValue:
                        print("Picture")
//                        print(values.debugDescription)
                        images.append(UIImage(data: values.data ?? Data()) ?? UIImage())
                    default:
                        print()
                    }
                    

                    
                })
//            self.mediaCancellable?.cancel()
        }
        }
        else{
            images = [UIImage(imageLiteralResourceName: "none")]
        }
    }
}
struct XOIDetail_Previews:
    PreviewProvider {
    static var previews: some View {
        XOIDetail(xoi:testxoi[0])
            .environmentObject(SettingStorage())
    }
}

