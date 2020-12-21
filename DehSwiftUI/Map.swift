//
//  Map.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/3.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI
import MapKit
struct Map: View {
//    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        
        
        MapView(coordinate: CLLocationCoordinate2D(
                    latitude: 23.58_323, longitude: 120.58_260))
            .navigationBarItems(trailing: Button(action: {
                print("map_locate tapped")
            }) {
                Image("map_locate")
            })
            .overlay(
                VStack{
                    Spacer()
                    HStack{
                        Button(action: {
                            print("gps tapped")
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

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        Map()
    }
}
