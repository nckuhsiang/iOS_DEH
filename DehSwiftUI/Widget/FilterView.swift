//
//  SwiftUIView.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2022/1/10.
//  Copyright © 2022 mmlab. All rights reserved.
//

import SwiftUI
import Alamofire
import Combine
struct FilterView: View {
    @State var idsIndex:Int = 0
    @State var typesIndex:Int = 0
    @State var formatsIndex:Int = 0
    @State var selection:Int?
    @Binding var myViewState:Bool
    var ids = ["All".localized, "Expert's map".localized, "User's map".localized, "Docent's map".localized]
    var types = ["All".localized, "Image".localized, "Audio".localized, "Video".localized]
    var formats = ["All".localized,"Historical Site, Buildings".localized,"Ruins".localized,"Cultural Landscape".localized,"Natural Landscape".localized,"Traditional Art".localized,"Cultural Artifacts".localized,"Antique".localized,"Necessities of Life".localized,"Others".localized]
    var Transfer = [
      "All".localized: "all",
      "Expert's map".localized: "expert",
      "User's map".localized: "user",
      "Docent's map".localized: "docent",
      "Image".localized: "image",
      "Audio".localized: "audio",
      "Video".localized: "video",
      "Historical Site, Buildings".localized: "古蹟、歷史建築、聚落",
      "Ruins".localized: "遺址",
      "Antique".localized: "古物",
      "Cultural Landscape".localized: "文化景觀",
      "Natural Landscape".localized: "自然景觀",
      "Traditional Art".localized: "傳統藝術",
      "Cultural Artifacts".localized: "民俗及有關文物",
      "Necessities of Life".localized: "食衣住行育樂",
      "Others".localized: "其他"
    ]
    @State var pickerState = false
    @EnvironmentObject var settingStorage:SettingStorage
    @StateObject var locationManager = LocationManager()
    @State private var cancellable: AnyCancellable?
    var body: some View {
        VStack {
            if pickerState{
                Spacer()
            }
            VStack {
                Text("Filter")
                    .fontWeight(.bold)
                    .font(.system(size:30))
                VStack(alignment: .leading, spacing:10){
                    Text("地圖類別")
                    Button {
                        pickerState = true
                        selection = 0
                    } label: {
                        Text(ids[idsIndex])
                    }
                    Text("媒體種類")
                    Button {
                        pickerState = true
                        selection = 1
                    } label: {
                        Text(types[typesIndex])
                    }
                    Text("範疇")
                    Button {
                        pickerState = true
                        selection = 2
                    } label: {
                        Text(formats[formatsIndex])
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width/1.5, alignment: .leading)
                
                Spacer()
                HStack {
                    Button {
                        pickerState = false
                        myViewState = false
                    } label: {
                        Text("Cancel".localized)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.gray)
                    }
                    Button {
                        filterPOI()
                        pickerState = false
                        myViewState = false
                    } label: {
                        Text("Go filter".localized)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color(UIColor(rgba: lightGreen)))
                    }
                    
                }
                
            }
            .frame(width: UIScreen.main.bounds.width/1.5, height: 300)
            .background(Color.white)
            .cornerRadius(12)
            .clipped()
            if pickerState {
                Spacer()
                switch selection{
                case 0:
                    PickerView(dataArray: ids, myViewState: $pickerState,indexSelection: $idsIndex)
                case 1:
                    PickerView(dataArray: types, myViewState: $pickerState, indexSelection: $typesIndex)
                case 2:
                    PickerView(dataArray: formats, myViewState: $pickerState, indexSelection: $formatsIndex)
                default:
                    Text("error")
                }
            }
        }
    }
}
extension FilterView {
    func filterPOI(){
        print(locationManager.coordinateRegion.center.latitude)
        let parameters:[String:String] = [
            "username": "\(settingStorage.account)",
            "lat" :"\(locationManager.coordinateRegion.center.latitude)",
            "lng": "\(locationManager.coordinateRegion.center.longitude)",
            "dis": "\(settingStorage.searchDistance * 1000)",
            "num": "\(settingStorage.searchNumber)",
            "coi_name": coi,
            "action": "searchNearbyPOI",
            "user_id": "\(settingStorage.userID)",
            "password":"\(settingStorage.password)",
            "language":"中文",
            "format":"\(formatsIndex)"
        ]
        print(formatsIndex)
        let url = getNearbyXois["searchNearbyPOI"] ?? ""
        let publisher:DataResponsePublisher<XOIList> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                self.settingStorage.XOIs["nearby"] = values.value?.results
                if idsIndex != 0{
                    self.settingStorage.XOIs["nearby"] = (self.settingStorage.XOIs["nearby"] ?? []).filter({$0.creatorCategory==Transfer[ids[idsIndex]]})
                }
                if typesIndex != 0{
                    self.settingStorage.XOIs["nearby"] = (self.settingStorage.XOIs["nearby"] ?? []).filter({$0.mediaCategory==Transfer[types[typesIndex]]})
                }
            })
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    @State static var test = false
    static var previews: some View {
        FilterView(myViewState: $test)
    }
}
