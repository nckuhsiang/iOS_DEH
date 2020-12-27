/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The model for an individual landmark.
 */

import SwiftUI
import CoreLocation

// get set : 讀／寫
//protocol XOIProtocol:Identifiable {
//    var id: Int{get set}
//    var name: String{get set}
//    var latitude: Double{get set}
//    var longitude: Double{get set}
//    var creatorCategory: String{get set}
//    var xoiCategory: String{get set}
//    var detail: String{get set}
//    var viewNumbers: Int{get set}
//    var mediaCategory: String{get set}
//    func getLocationCoordinate()-> CLLocationCoordinate2D
//}

import MapKit

class XOI:Identifiable,Decodable,Encodable {
    var ContainedXOIs:[XOI]!
    var id: Int = 0
    var name: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var creatorCategory: String = ""
    var xoiCategory: String = ""
    var detail: String = ""
    var viewNumbers: Int = 0
    var mediaCategory: String = ""
    var coordinate:CLLocationCoordinate2D!{
        get{
            return CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude)
        }
    }
//    func getLocationCoordinate() -> CLLocationCoordinate2D {
//        return CLLocationCoordinate2D(
//            latitude: latitude,
//            longitude: longitude)
//    }
    func region() -> MKCoordinateRegion{
        return MKCoordinateRegion(center: coordinate, latitudinalMeters:20000,longitudinalMeters:20000)
    }
    init(id: Int,name: String,latitude: Double,longitude: Double,creatorCategory: String,xoiCategory: String,detail: String,viewNumbers: Int,mediaCategory: String){
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.creatorCategory = creatorCategory
        self.xoiCategory = xoiCategory
        self.detail = detail
        self.viewNumbers = viewNumbers
        self.mediaCategory = mediaCategory
    }
    func setContainedXOI(XOIs:[XOI]){
        self.ContainedXOIs = XOIs
    }
}
class POI: XOI{
//    super.init()
}






