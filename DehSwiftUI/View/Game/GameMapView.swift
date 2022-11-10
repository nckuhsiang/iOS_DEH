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
    @StateObject var gameVM:GameViewModel
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var cancellable: AnyCancellable?
    @State var group:Group
    @State var session:SessionModel

//    @State var selection: Int? = nil
    @State var alertState = false
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.coordinateRegion, annotationItems: gameVM.chestList){
                chest in
                MapAnnotation(
                    coordinate: chest.coordinate,
                    anchorPoint: CGPoint(x: 0.5, y: 0.5)
                ){
                    NavigationLink(destination: {ChestDetailView(gameVM:gameVM, chest: chest,session:session)}) {
                        Image("chest")
//                        Button(action:{
//                            print("chest tap")
////                            gameVM.selection = gameVM.chestList.firstIndex(of: chest)
//                        }) {
//                            Image("chest")
//                        }
//                        .hidden(locationManager.getDistanceFromCurrentPlace(coordinate: chest.coordinate) > Double(chest.discoverDistance ?? 50))
                    }
//                    NavigationLink(
//                        destination: ChestDetailView(gameVM:gameVM, chest: chest,session:session),
//                        tag:gameVM.chestList.firstIndex(of: chest) ?? -1,
//                        selection:$gameVM.selection
//                    ){
//                        Button(action:{
//                            print("chest tap")
//                            gameVM.selection = gameVM.chestList.firstIndex(of: chest)
//                        }){
//                            Image("chest")
//                        }
////                        .hidden(locationManager.getDistanceFromCurrentPlace(coordinate: chest.coordinate) > Double(chest.discoverDistance ?? 50))
//                    }
                    
                }
            }
            .onAppear(){
                if session.gameID != 0 {
                    gameVM.getGameData(gameID: session.gameID)
                    locationManager.startUpdate()
                    if gameVM.chestList.isEmpty {
                        gameVM.getChests(session: session)
                    }
                }
                
                else {
                    print("no game avaliable")
                    alertState = true
                }
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
            VStack {
                Text("\(gameVM.min):\(gameVM.sec)")
                    .font(.largeTitle)
                    .background(Color.gray)
                    .onReceive(timer){ _ in
                        if gameVM.sec > 0 {
                            gameVM.sec -= 1
                        }
                        else {
                            gameVM.sec = 60
                            gameVM.min -= 1
                        }
                    }
                Spacer()
                Text("Score:\(gameVM.score)")
                    .frame(width: UIScreen.main.bounds.width, height: 50, alignment: .center)
                    .font(.largeTitle)
                    .background(Color.green)
            }
            
        }
        
    }
}
//class ChestList:ObservableObject {
//    @Published  var list:[ChestModel] = []
//}
extension GameMap{
//    func getChests(){
//        let url = getChestList
//        let parameters:[String:String] = [
//            "user_id": "\(session.id)",
//            "game_id":"\(session.gameID)",
//        ]
//        let publisher:DataResponsePublisher<[ChestModel]> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
//        self.cancellable = publisher
//            .sink(receiveValue: {(values) in
//                //                print(values.data?.JsonPrint())
//                print(values.debugDescription)
//                if let value = values.value{
//                    self.chestList.list = value
//                    print(chestList.list.count)
//                }
//
//            })
//    }
}

struct GameMap_Previews: PreviewProvider {
    static var previews: some View {
        GameMap(gameVM:GameViewModel(), group: testGroup, session: testSession)
            .environmentObject(SettingStorage())
    }
}
