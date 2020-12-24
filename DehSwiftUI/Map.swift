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
    @ObservedObject var locationManager = LocationManager()
    
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 23.58_323
    }
    
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 120.58_260
    }
    
    var body: some View {
        
        
        MapView(coordinate: CLLocationCoordinate2D(
                    latitude: userLatitude, longitude: userLongitude))
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
