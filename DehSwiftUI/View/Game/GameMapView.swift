//
//  GameMap.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2021/4/30.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI
import MapKit
import Combine
import Alamofire
struct GameMap: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var locationManager = LocationManager()
    @EnvironmentObject var settingStorage:SettingStorage
    @State private var cancellable: AnyCancellable?
    @State var group:Group
    @State var session:SessionModel
    @State var chestList:[ChestModel] = []
    @State var selection: Int? = nil
    @State var alertState = false
    var body: some View {
        Map(coordinateRegion: $locationManager.coordinateRegion, annotationItems: chestList){
            chest in
            MapAnnotation(
                coordinate: chest.coordinate,
                anchorPoint: CGPoint(x: 0.5, y: 0.5)
            ){
                NavigationLink(
                    destination: ChestDetailView(chest: chest,session:session),
                    tag:chestList.firstIndex(of: chest) ?? -1,
                    selection:$selection
                ){
                    Button(action:{
                        print("chest tap")
                        print("")
                        selection = chestList.firstIndex(of: chest)
                    }){
                        Image("chest")
                    }
                    .hidden(locationManager.getDistanceFromCurrentPlace(coordinate: chest.coordinate) > Double(chest.discoverDistance ?? 50))
                }

            }
        }
            .onAppear(){
                locationManager.startUpdate()
                if(session.gameID == 0){
                    print("no game avaliable")
                    alertState = true
                }
                getChests()
            }
        .onDisappear(){
            locationManager.stopUpdate()
        }
        .alert(isPresented: $alertState) { () -> Alert in
            return Alert(title: Text("game does not start".localized),
                 dismissButton:.default(Text("OK".localized), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
        
    }
}
extension GameMap{
    func getChests(){
        let url = getChestList
        let parameters:[String:String] = [
            "user_id": "\(settingStorage.userID)",
            "game_id":"\(session.gameID)",
        ]
        let publisher:DataResponsePublisher<[ChestModel]> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
//                print(values.data?.JsonPrint())
                print(values.debugDescription)
                if let value = values.value{
                    self.chestList = value
                }
                
            })
    }
}

struct GameMap_Previews: PreviewProvider {
    static var previews: some View {
        GameMap(group: testGroup, session: testSession)
            .environmentObject(SettingStorage())
    }
}
