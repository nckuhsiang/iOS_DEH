//
//  SwiftUIView.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2022/1/10.
//  Copyright © 2022 mmlab. All rights reserved.
//

import SwiftUI

struct FilterView: View {
    @State var idsIndex:Int = 0
    @State var typesIndex:Int = 0
    @State var formatsIndex:Int = 0
    @State var selection:Int?
    @Binding var myViewState:Bool
    var ids = ["All", "Expert", "Player", "Docent"]
    var types = ["All", "Image", "Audio", "Video"]
    var formats = ["All","古蹟","歷史建築","紀念建築","考古遺址","史蹟","文化景觀","古物","自然景觀", "傳統表演藝術","傳統工藝","口述傳統","民俗","民俗及有關文物","傳統知識與實踐","一般景觀含建築：人工地景與自然地景","植物","動物","生物","食衣住行育樂","其他"]
    @State var pickerState = false
    var body: some View {
        VStack {
            if pickerState{
                Spacer()
            }
            VStack {
                Text("Filter")
                    .fontWeight(.bold)
                    .font(.system(size:30))
                VStack(alignment: .leading, spacing:10){
                    Text("地圖類別")
                    Button {
                        pickerState = true
                        selection = 0
                    } label: {
                        Text(ids[idsIndex])
                    }
                    Text("媒體種類")
                    Button {
                        pickerState = true
                        selection = 1
                    } label: {
                        Text(types[typesIndex])
                    }
                    Text("範疇")
                    Button {
                        pickerState = true
                        selection = 2
                    } label: {
                        Text(formats[formatsIndex])
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width/1.5, alignment: .leading)
                
                Spacer()
                HStack {
                    Button {
                        pickerState = false
                        myViewState = false
                    } label: {
                        Text("Cancel".localized)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.gray)
                    }
                    Button {
                        pickerState = false
                        myViewState = false
                    } label: {
                        Text("Go filter".localized)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color(UIColor(rgba: lightGreen)))
                    }
                    
                }
                
            }
            .frame(width: UIScreen.main.bounds.width/1.5, height: 300)
            .background(Color.white)
            .cornerRadius(12)
            .clipped()
            if pickerState {
                Spacer()
                switch selection{
                case 0:
                    PickerView(dataArray: ids, myViewState: $pickerState,indexSelection: $idsIndex)
                case 1:
                    PickerView(dataArray: types, myViewState: $pickerState, indexSelection: $typesIndex)
                case 2:
                    PickerView(dataArray: formats, myViewState: $pickerState, indexSelection: $formatsIndex)
                default:
                    Text("error")
                }
            }
        }
       
        
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    @State static var test = false
    static var previews: some View {
        FilterView(myViewState: $test)
    }
}
