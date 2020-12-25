//
//  LocationManager.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/22.
//  Copyright © 2020 mmlab. All rights reserved.
//
//https://stackoverflow.com/questions/57681885/how-to-get-current-location-using-swiftui-without-viewcontrollers
//subjects
//https://stackoverflow.com/questions/60482737/what-is-passthroughsubject-currentvaluesubject

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    var listeningOnce:Int = 0
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
    }

    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }

    }

    let objectWillChange = PassthroughSubject<Void, Never>()

    private let locationManager = CLLocationManager()
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        if(location.horizontalAccuracy > 0 && listeningOnce > 0){
            listeningOnce -= 1
            if(listeningOnce == 0){
                self.locationManager.stopUpdatingLocation()
            }
            
        }
        print(#function, location)
    }
    func startUpdate(){
        self.locationManager.startUpdatingLocation()
    }
    func stopUpdate(){
        self.locationManager.stopUpdatingLocation()
    }
    func updateLocation(){
        //避免浪費電，如果只開一次會無法更新
        self.locationManager.startUpdatingLocation()
        listeningOnce = 3
    }

}