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
    @State var viewNumbers = -1
    @State private var cancellable: AnyCancellable?
    @State private var mediaCancellable: [AnyCancellable] = []
//    @State private var images:[UIImage] = []
    @State private var medias:[MediaMulti] = []
    @State private var commentary:MediaMulti = MediaMulti(data: Data(), format: .Default)
    @State var index = 0
    @State private var showingAlert = false
    var body: some View{
        ScrollView {
        VStack {
            XOIMediaSelector(xoi: xoi)
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
                        }
                        else{
                            settingStorage.XOIs["favorite"]?.append(xoi)
                            showingAlert = true
                        }
                    }) {
                        Image("heart")
                        
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Add to favorite"))
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
//                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
//                    .fixedSize(horizontal: false, vertical: true)
                    
            }
            .padding()
            Spacer()
        }
        .onAppear(){
            getViewerNumber()
            getMedia()
        }
    }
        .navigationBarItems(trailing: Button {
            
        } label: {
            Image(systemName: "square.and.arrow.up.on.square.fill")
                .foregroundColor(.blue)
        })
    
}
}
extension XOIDetail{
    @ViewBuilder func XOIMediaSelector(xoi:XOI) -> some View{
        switch xoi.xoiCategory {
        case "poi":
            PagingView(index: $index.animation(), maxIndex: medias.count - 1) {
            ForEach(self.medias, id: \.data) {
                singleMedia in
                singleMedia.view()
            }
        }
        case "loi": DEHMapInner(xois:xoi.containedXOIs ?? testxoi, xoiCategory: xoi.xoiCategory)
        case "aoi": DEHMapInner(xois:xoi.containedXOIs ?? testxoi, xoiCategory: xoi.xoiCategory)
        case "soi": DEHMapInner(xois:xoi.containedXOIs ?? testxoi, xoiCategory: xoi.xoiCategory)
        default:
            Text("error")
        }
    }
    
    
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

//        let format = [
//            "Commentary": 8,
//            "Video": 4,
//            "Voice": 2,
//            "Picture": 1,
//        ]
        if let _ = xoi.media_set{
//
        for (_,media) in xoi.media_set.enumerated(){
            if media.media_format == 0 || media.media_type == ""{
                medias = [MediaMulti(data: UIImage(imageLiteralResourceName: "none").pngData() ?? Data(), format: format.Picture)]
                continue
            }
            let url = media.media_url
//            print(url)
//            print(0)
            let publisher:DataResponsePublisher = NetworkConnector().getMediaPublisher(url: url)
            
//            self.mediaCancellable[index] = publisher
                let cancelable = publisher
                .sink(receiveValue: {(values) in
                    print(values.debugDescription)
                    if let formatt = format(rawValue: media.media_format){
                        if let data = values.data{
                            switch formatt{
                            case format.Commentary:
                                self.commentary = MediaMulti(data:data,format: formatt)
                            case .Video:
                                fallthrough
                            case .Voice:
                                fallthrough
                            case .Picture:
                                medias.append(MediaMulti(data:data,format: formatt))
                            case .Default:
                                print("default")
                            }
                            
                        }
                    }
//                    print(values.data?.JsonPrint())
//                    let x = MediaMulti(data: values.data ?? Data(), format: format(rawValue: media.media_format) ?? .Default)
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
//                        images.append(UIImage(data: values.data ?? Data()) ?? UIImage())
                    default:
                        print()
                    }
//                    self.mediaCancellable?.cancel()

                    
                })
            self.mediaCancellable.append(cancelable)
//
        }
        }
        else{
            medias = [MediaMulti(data: UIImage(imageLiteralResourceName: "none").pngData() ?? Data(), format: format.Picture)]
//            images = [UIImage(imageLiteralResourceName: "none")]
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

