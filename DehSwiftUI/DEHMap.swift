//
//  Map.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/3.
//  Copyright © 2020 mmlab. All rights reserved.
//https://swiftwithmajid.com/2020/07/29/using-mapkit-with-swiftui/

import SwiftUI
import MapKit
struct DEHMap: View {
    @ObservedObject var locationManager = LocationManager()
    @EnvironmentObject var settingStorage:SettingStorage
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 22.997, longitude: 120.221),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State var selection: Int? = nil
    
    var body: some View {
        
        
        //        MapView(coordinate: CLLocationCoordinate2D(
        //                    latitude: userLatitude, longitude: userLongitude))
        Map(coordinateRegion: $locationManager.coordinateRegion, annotationItems: settingStorage.XOIs["favorite"] ?? testxoi){xoi in
            MapAnnotation(
                coordinate: xoi.coordinate,
                anchorPoint: CGPoint(x: 0.5, y: 0.5)
            ) {
                NavigationLink(destination:  XOIDetail(xoi:xoi), tag: 1, selection: $selection){
                    Button(action: {
                        print("map tapped")
                        self.selection = 1
                        
                        //                    XOIDetail(xoi:xoi)
                    }) {
                        VStack{
                            Text(xoi.name)
                            Image("player_pin")
                        }
                    }
                    
                }
                
                //                Image("player_pin")
                //                    .stroke(Color.green)
                //                    .frame(width: 44, height: 44)
            }
        }
        
        
        .navigationBarItems(trailing:HStack{
                                Text("filter")
                                Button(action: {
                                    print("map_locate tapped")
                                }) {
                                    Image("map_locate")
                                }})
        
        .overlay(
            VStack{
                Spacer()
                HStack{
                    Button(action: {
                        print("gps tapped")
                        locationManager.updateLocation()
//                        setCoordinateRegion()
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
        )
        
        
        //                .padding(.bottom,60)
        
        
        
    }
    
}

struct DEHMap_Previews: PreviewProvider {
    static var previews: some View {
        DEHMap()
            .environmentObject(SettingStorage())
    }
}
