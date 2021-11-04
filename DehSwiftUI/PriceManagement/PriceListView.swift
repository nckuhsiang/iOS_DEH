//
//  PriceListView.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/11/3.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI
import Alamofire
import Combine

struct PriceListView: View {
    @State var priceList:[Price] = []
    @State private var cancellable: AnyCancellable?
    @EnvironmentObject var settingStorage:SettingStorage

    var body: some View {
        VStack {
            VStack {
                Text("Price List")
                    .font(.title)
                Link(destination: URL(string: "http://deh.csie.ncku.edu.tw")!) {
                    Text("Go to the website")
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .foregroundColor(Color.black)
                        .background(Color.gray)
                }
            }
            List {
                ForEach(self.priceList) { price in
                    NavigationLink(destination: PriceDetailView(price: price)) {
                        Text(price.startTime ?? "")
                    }
                }
            }
            //.foregroundColor(Color(UIColor(rgba: darkGreen)))
            .listStyle(PlainListStyle())
        }
        .onAppear {
            getPriceList()
        }
       
        
    }
}
extension PriceListView {
    func getPriceList() {
        let url = PriceGetListUrl
        let parameters = ["user_id":settingStorage.userID]
        let publisher: DataResponsePublisher<[Price]> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        cancellable = publisher.sink(receiveValue: { (values) in
            print(values.debugDescription)
            self.priceList = values.value ?? []
        })
    }
}


struct PriceListView_Previews: PreviewProvider {
    static var previews: some View {
        PriceListView()
    }
}
