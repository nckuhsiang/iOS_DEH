/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for an individual landmark.
*/

import SwiftUI
import CoreLocation

protocol xois {
    var id:Int{get}
}


struct XOI: Identifiable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var creatorCategory: String
    var xoiCategory: String
    var detail: String
    var viewNumbers: Int
    var mediaCategory: String
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }

}











