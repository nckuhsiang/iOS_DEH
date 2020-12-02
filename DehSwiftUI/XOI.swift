/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for an individual landmark.
*/

import SwiftUI
import CoreLocation

struct XOI: Identifiable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var creatorCategory: String
    var xoiCategory: String
    var detail: String
    var viewNumbers: Int
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }

}





struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    fileprivate var imageName: String
    fileprivate var coordinates: Coordinates
    var state: String
    var park: String
    var category: Category

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

    enum Category: String, CaseIterable, Codable, Hashable {
        case featured = "Featured"
        case lakes = "Lakes"
        case rivers = "Rivers"
    }
}

extension Landmark {
//    var image: Image {
////        ImageStore.shared.image(name: imageName)
//    }
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}
