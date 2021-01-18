//
//  TabViewElement.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/2.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire

struct TabViewElement: View {
    var title: String
    var image1: String
    var image2: String
    var tabItemImage: String
    var tabItemName: String
    @ObservedObject var xoiViewModel = XOIViewModel()
    @EnvironmentObject var settingStorage:SettingStorage
    @ObservedObject var locationManager = LocationManager()
    @State var selectSearchXOI = false
    @State private var cancellable: AnyCancellable?
    var body: some View {
        
        VStack{
            
            HStack{
                Text(title)
                    .foregroundColor(Color.white)
                Spacer()
                Button(action: {
                    print("User icon pressed...")
                }){
                    Image(image1).hidden(image1=="Empty")
                }
                .disabled(image1=="Empty")
                
                Button(action: {
//                    searchXOIs()
                    selectSearchXOI = true
                }){
                    Image(image2).hidden(image2=="Empty")
                }
                .disabled(image2=="Empty")
                .actionSheet(isPresented: $selectSearchXOI) {
                    ActionSheet(title: Text("Select Search XOIs"), message: Text(""), buttons: [
                        .default(Text("POI")) { searchXOIs(action: "searchMyPOI") },
                        .default(Text("LOI")) { searchXOIs(action: "searchMyLOI") },
                        .default(Text("AOI")) { searchXOIs(action: "searchMyAOI") },
                        .default(Text("SOI")) { searchXOIs(action: "searchMySOI") },
                        .cancel()
                    ])
                }
            }
            .padding([.top, .leading, .trailing])
            List{
                ForEach(self.settingStorage.XOIs[tabItemName] ?? []){xoi in
                    XOIRow(xoi:xoi)
                        .padding(.horizontal)
                }
                .listRowBackground(Color.init(UIColor(rgba: darkGreen)))
            }
        }
        .background(Color.init(UIColor(rgba: lightGreen)))
        .tabItem{
            Image(tabItemImage)
            Text(tabItemName)
                .foregroundColor(.white)
        }
    }
    
}
extension TabViewElement{
    func searchXOIs(action:String){
        print("User icon pressed...")
        let parameters:[String:String] = [
            "username": "\(settingStorage.account)",
            "lat" :"\(locationManager.coordinateRegion.center.latitude)",
            "lng": "\(locationManager.coordinateRegion.center.longitude)",
            "dis": "\(settingStorage.searchDistance * 1000)",
            "num": "3", //"\(settingStorage.searchNumber)",
            "coi_name": coi,
            "action": action,
            "user_id": "\(settingStorage.userID)",
            "password":"\(settingStorage.password)",
        ]
        let url = getTestXois[action] ?? ""
        let publisher:DataResponsePublisher<XOIList> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                print(values.debugDescription)
                //                print(values.value?.results[0])
                self.settingStorage.XOIs["mine"] = values.value?.results
            })
        
    }
}


struct TabViewElement_Previews: PreviewProvider {
    static var previews: some View {
        TabViewElement(title: "page2", image1: "member_grouplist", image2: "search",tabItemImage: "member_favorite",tabItemName: "favorite")
            .environmentObject(SettingStorage())
    }
}

