//
//  DEHMapInner.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2021/3/5.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI
import MapKit
struct DEHMapInner: View {
    var xois:[XOI]
    @ObservedObject var locationManager = LocationManager()
    @State var selection: Int? = nil
    
    var body: some View {
        Map(coordinateRegion: $locationManager.coordinateRegion, annotationItems: xois){xoi in
            MapAnnotation(
                coordinate: xoi.coordinate,
                anchorPoint: CGPoint(x: 0.5, y: 0.5)
            ) {
                NavigationLink(destination:  destinationSelector(xoi:xoi), tag: xois.firstIndex(of: xoi) ?? 0, selection: $selection){
                    Button(action: {
                        print("map tapped")
                        self.selection = xois.firstIndex(of: xoi)
                    }) {
                        VStack{
                            Text(xoi.name)
                            
                            Image("player_pin")
                        }
                    }
                }
            }
        }
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
    }
}
extension DEHMapInner{
    @ViewBuilder func destinationSelector(xoi:XOI) -> some View{
        switch xoi.xoiCategory {
        case "poi": XOIDetail(xoi:xoi)
        case "loi": DEHMapInner(xois:xoi.containedXOIs ?? testxoi)
        case "aoi": DEHMapInner(xois:xoi.containedXOIs ?? testxoi)
        case "soi": DEHMapInner(xois:xoi.containedXOIs ?? testxoi)
        default:
            Text("error")
        }
    }
}

struct DEHMapInner_Previews: PreviewProvider {
    static var previews: some View {
        DEHMapInner(xois: testxoi)
    }
}
