//
//  ChestDetailView.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2021/4/30.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI
import Combine
import Alamofire
struct ChestDetailView: View {
    @ObservedObject var locationManager = LocationManager()
    @EnvironmentObject var settingStorage:SettingStorage
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var cancellable: AnyCancellable?
    @State private var cancellable2: AnyCancellable?
    @State private var mediaCancellable: [AnyCancellable] = []
    @State var chest:ChestModel
    @State var session:SessionModel
    @State var chestMedia:[ChestMedia]=[]
    @State var medias:[MediaMulti] = []
    @State var index = 0
    @State var answer = ""
    @State var showMessage = false
    @State var responseMessage:String = ""
    @State var textInEditor = "Answer"
    @State var selection: Int? = nil
    @State var mediaData:Data? = nil
    @State var recoder:Sounds? = nil
    var body: some View {
        ZStack{
            Color.init(UIColor(rgba:lightGreen))
            GeometryReader { geometry in
                VStack{
                    PagingView(index: $index.animation(), maxIndex: medias.count - 1) {
                        ForEach(self.medias, id: \.data) {
                            singleMedia in
                            singleMedia.view()
                        }
                    }
                    .frame(height: geometry.size.height * 0.4)
                    ScrollView{
                    //            Spacer()
                    HStack{
                        Spacer()
                        Text("Question:")
                            .multilineTextAlignment(.center)
                            .frame(height: geometry.size.height * 0.03)
                            .font(.system(size: 20))
                        Spacer()
                        Text("Done")
                    }
                    Divider()
                    Text(chest.question)
                        .frame(height: geometry.size.height * 0.15)
                    
                    answerBoxSelector(chest.questionType,geometry)
                        .alert(isPresented: $showMessage) {() -> Alert in
                            //                            let greetingMessage = "Login Success"
                            return Alert(title: Text(responseMessage),
                                         dismissButton:.default(Text("Ok"), action: {
                                            //                                    UITableView.appearance().backgroundColor = UIColor(rgba:darkGreen)
                                            
                                            self.presentationMode.wrappedValue.dismiss()
                                         })
                            )
                        }
                    
                    Spacer()
                    }
                }
                .onAppear(){
                    print(chest.srcID)
                    getChestMedia()
                    showMessage = false
                }
            }
            EmptyView()
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

extension ChestDetailView{
    @ViewBuilder func answerBoxSelector(_ questionType:Int,_ geometry:GeometryProxy? = nil) -> some View {
        switch questionType {
        case 1: //是非題的介面
            HStack{
                Button(action: {checkAnswer("T")}, label: {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                })
                Button(action: { checkAnswer("F")}, label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                })
            }
        case 2: //選擇題的介面
            VStack{
                HStack{
                    buttonViewer(answer: "A",option: chest.option1 ?? "")
                    buttonViewer(answer: "B",option: chest.option2 ?? "")
                }
                HStack{
                    buttonViewer(answer: "C",option: chest.option3 ?? "")
                    buttonViewer(answer: "D",option: chest.option4 ?? "")
                }
            }
            .background(Color.white)
        case 3:
            
                VStack{
                    HStack{
                        Spacer()
                        TextEditor(text: $textInEditor)
                        //                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        Spacer()
                    }
                    .frame(height: (geometry?.size.height ?? 0) * 0.2)
                    //                TextEditor(text: .constant("Placeholder"))
                    //                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Spacer()
                    Text("Append a Media")
                    HStack{
                        Spacer()
                        imageButton(imageName: "camera", mediaType: "picture")
                            .disabled(mediaData != nil)
                        Spacer()
                        imageButton(imageName: "mic", mediaType: "voice")
                            .disabled(mediaData != nil)
                        Spacer()
                        imageButton(imageName: "video", mediaType: "video")
                            .disabled(mediaData != nil)
                        Spacer()
                    }
                    .frame(height: (geometry?.size.height ?? 0) * 0.07)
                    Spacer()
                }
                .background(Color.init(UIColor(rgba:lightGreen)))
            
        default:
            EmptyView()
        }
    }
    @ViewBuilder func buttonViewer(answer:String,option:String) -> some View{
        Button(action: {checkAnswer(answer)}, label: {
            Text(option)
                .fontWeight(.bold)
                .font(.title)
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.init(UIColor(rgba:lightGreen)), lineWidth: 5)
                )
        })
    }
    @ViewBuilder func imageButton(imageName:String,mediaType:String)-> some View{
        let typeToInt = [
            "picture":1,
            "voice":2,
            "video":3,
        ]
        NavigationLink(
            destination: ImageSelectView(mediaData: $mediaData),
            tag: typeToInt[mediaType] ?? 0,
            selection: $selection,
            label: {
                Button(action: {
                    selection = typeToInt[mediaType]
                }, label: {
                    Image(systemName: imageName)
                        .foregroundColor(mediaData == nil ? .blue : .black)
                        .font(.system(size: 30))
                })
                .contextMenu(ContextMenu(menuItems: {
                    Text("make a \(mediaType) answer")
                        .bold()
                }))
            })
        
    }
}

extension ChestDetailView{
    struct ChestMedia:Decodable {
        var id:Int
        var url:URL
        var format:String
        enum CodingKeys: String, CodingKey{
            case id = "ATT_id"
            case url = "ATT_url"
            case format = "ATT_format"
        }
    }
    func getChestMedia(){
        let url = getChestMediaUrl
        let parameters:[String:String] = [
            "chest_id": "\(chest.id)",
        ]
        let publisher:DataResponsePublisher<[ChestMedia]> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                //                print(values.data?.JsonPrint())
                print(values.debugDescription)
                if let value = values.value{
                    self.chestMedia = value
                }
                for chestMedia in self.chestMedia{
                    let publisher:DataResponsePublisher = NetworkConnector().getMediaPublisher(url: chestMedia.url)
                    let cancelable = publisher
                        .sink(receiveValue: {(values) in
                            print(values.debugDescription)
                            if let data = values.data{
                                medias.append(MediaMulti(data:data,format:format.Picture ))
                                //                            chestMedia.format))
                            }
                        })
                    self.mediaCancellable.append(cancelable)
                }
                
            })
    }
    func checkAnswer(_ answer:String){
        switch answer{
        case "T" :
            fallthrough
        case "F" :
            fallthrough
        case "A":
            fallthrough
        case "B":
            fallthrough
        case "C":
            fallthrough
        case "D":
            
            insertAnswer(answer: answer, correctness: "\(self.chest.answer == answer ? "1" : "0")")
            if(answer == self.chest.answer) {
                chestMinus(answer: answer, correctness: "\(self.chest.answer == answer ? "1" : "0")")
            }
        default: break
        }
    }
    func insertAnswer(answer:String,correctness:String){
        let url = insertAnswerUrl
        let parameters:[String:String] = [
            "user_id": "\(settingStorage.userID)",
            "game_id":"\(session.gameID)",
            "chest_id":"\(chest.id)",
            "answer":answer,
            "point":"\(String(describing: chest.point))",
            "correctness":correctness,
            "lat":String(describing: locationManager.coordinateRegion.center.latitude),
            "lng":String(describing: locationManager.coordinateRegion.center.longitude),
        ]
        let publisher:DataResponsePublisher<String> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable = publisher
            .sink(receiveValue: {(values) in
                //                print(values.data?.JsonPrint())
                print(values.debugDescription)
                if let value = values.value{
                    showMessage = true
                    self.responseMessage = value
                }
                
            })
    }
    func chestMinus(answer:String,correctness:String){
        let url = chestMinusUrl
        let parameters:[String:String] = [
            "user_id": "\(settingStorage.userID)",
            "game_id":"\(session.gameID)",
            "chest_id":"\(chest.id)",
            "user_answer":answer,
            //            "correctness":correctness,
            "lat":String(describing: locationManager.coordinateRegion.center.latitude),
            "lng":String(describing: locationManager.coordinateRegion.center.longitude),
        ]
        let publisher:DataResponsePublisher<String> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        self.cancellable2 = publisher
            .sink(receiveValue: {(values) in
                //                print(values.data?.JsonPrint())
                print(values.debugDescription)
                if let value = values.value{
                    print(value)
                }
                
            })
    }
    
}
struct ChestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChestDetailView(chest: testChest, session:testSession, chestMedia: []).answerBoxSelector(3)
            .environmentObject(SettingStorage())
            .environmentObject(LocationManager())
    }
}
