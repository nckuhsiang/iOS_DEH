//
//  Map.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/3.
//  Copyright © 2020 mmlab. All rights reserved.
//https://swiftwithmajid.com/2020/07/29/using-mapkit-with-swiftui/

import SwiftUI
import MapKit
import Combine
import Alamofire
struct DEHMap: View {
    //use stateobject to avoid renew the variable
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject var settingStorage:SettingStorage
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 22.997, longitude: 120.221),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State var selection: Int? = nil
    @State var selectSearchXOI = false
    @State private var cancellable: AnyCancellable?
    @State var filterState = false
    @State var showFilterButton = true
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.coordinateRegion, annotationItems: settingStorage.XOIs["nearby"] ?? testxoi){xoi in
                MapAnnotation(
                    coordinate: xoi.coordinate,
                    anchorPoint: CGPoint(x: 0.5, y: 0.5)
                ) {
                    NavigationLink(destination:  destinationSelector(xoi:xoi), tag: settingStorage.XOIs["nearby"]?.firstIndex(of: xoi) ?? 0, selection: $selection){
                        Button(action: {
                            print("map tapped")
                            self.selection = settingStorage.XOIs["nearby"]?.firstIndex(of: xoi)
                        }) {
                            VStack{
                                Text(xoi.name)
                                pinSelector(creatorCategory:xoi.creatorCategory)
                            }
                        }
                    }
                }
            }
            .navigationBarItems(trailing:HStack{
                Button {
                    filterState = true
                } label: {
                    Image(systemName: "f.circle.fill")
                        .foregroundColor(.blue)
                        
                }
                .disabled(showFilterButton)
                .hidden(showFilterButton)
                
                Button(action: {
                    print("map_locate tapped")
                    selectSearchXOI = true
                }
                ) {
                    Image("location")
                        .foregroundColor(.blue)
                }
                .actionSheet(isPresented: $selectSearchXOI) {
                    if app == "dehMicro" || app == "sdcMicro"{
                        return ActionSheet(title: Text("Select Search XOIs"), message: Text(""), buttons: [
                            .default(Text("POI".localized)) {
                                searchXOIs(action: "searchNearbyPOI") },
                            .cancel()
                        ])
                    }
                    else {
                        return ActionSheet(title: Text("Select Search XOIs"), message: Text(""), buttons: [
                            .default(Text("POI".localized)) { searchXOIs(action: "searchNearbyPOI") },
                            .default(Text("LOI".localized)) { searchXOIs(action: "searchNearbyLOI") },
                            .default(Text("AOI".localized)) { searchXOIs(action: "searchNearbyAOI") },
                            .default(Text("SOI".localized)) { searchXOIs(action: "searchNearbySOI") },
                            .cancel()
                        ])
                    }
                }
            })
            .overlay(
                ZStack{
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Image("sniper_target")
                            Spacer()
                        }
                        Spacer()
                    }
                    VStack{
                        Spacer()
                        HStack{
                            Button(action: {
                                print("gps tapped")
                                locationManager.updateLocation()
                            }) {
                                Image("gps")
                            }
                            .padding(.leading, 10.0)
                            Spacer()
                            Button(action: {
                                print("alert tapped")
                            }) {
                                Image("alert")
                            }
                            .padding(.trailing, 10.0)
                        }
                        .padding(.bottom,30.0)
                    }
                }
            )
            if filterState{
                FilterView(myViewState: $filterState)
            }
        }
        
    }
}

extension DEHMap{
    func searchXOIs(action:String){
        print("User icon pressed...")
        print(locationManager.coordinateRegion.center.latitude)
        let parameters:[String:String] = [
            "username": "\(settingStorage.account)",
            "lat" :"\(locationManager.coordinateRegion.center.latitude)",
            "lng": "\(locationManager.coordinateRegion.center.longitude)",
            "dis": "\(settingStorage.searchDistance * 1000)",
            "num": "\(settingStorage.searchNumber)",
            "coi_name": coi,
            "action": action,
            "user_id": "\(settingStorage.userID)",
            "password":"\(settingStorage.password)",
            "language":"中文"
        ]
        let url = getNearbyXois[action] ?? ""
        let publisher:DataResponsePublisher<XOIList> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                self.settingStorage.XOIs["nearby"] = values.value?.results
                print(locationManager.coordinateRegion.center.latitude)
            })
        if action == "searchNearbyPOI"{
            showFilterButton = false
        }
        else{
            showFilterButton = true
        }
    }
    @ViewBuilder func destinationSelector(xoi:XOI) -> some View{
        switch xoi.xoiCategory {
        case "poi": XOIDetail(xoi:xoi)
        case "loi": DEHMapInner(xois:xoi.containedXOIs ?? testxoi, xoiCategory: xoi.xoiCategory)
        case "aoi": DEHMapInner(xois:xoi.containedXOIs ?? testxoi, xoiCategory: xoi.xoiCategory)
        case "soi": DEHMapInner(xois:xoi.containedXOIs ?? testxoi, xoiCategory: xoi.xoiCategory)
        default:
            Text("error")
        }
    }
    @ViewBuilder func pinSelector(creatorCategory:String) -> some View{
        switch creatorCategory{
        case "docent": Image("docent_pin")
        case "expert": Image("expert_pin")
        case "user": Image("player_pin")
        default: Image("player_pin")
            
        }
    }
}

struct DEHMap_Previews: PreviewProvider {
    static var previews: some View {
        DEHMap()
            .environmentObject(SettingStorage())
    }
}
