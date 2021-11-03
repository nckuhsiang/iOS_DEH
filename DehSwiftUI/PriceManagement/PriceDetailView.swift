//
//  PriceDetailView.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/11/3.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI
import Alamofire
import Combine
import MapKit

struct PriceDetailView: View {
    @State var price:Price
    @State var priceName:String = ""
    @State var priceImg:String = ""
    @State var cancellable:AnyCancellable?
    init(price:Price) {
        self.price = price
    }
    var body: some View {
        VStack {
            Text("price item")
                .font(.title)
            Text(priceName)
                .font(.body)
            Image(priceImg)
            
        }
        .onAppear {
            getPriceAttribute()
        }

    }
}
extension PriceDetailView {
    func getPriceAttribute() {
        let url = GamePrizeAttributeUrl
        let parameters = ["player_prize_id": price.priceId ?? -1]
        let publisher: DataResponsePublisher<[Price]> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        cancellable = publisher.sink(receiveValue: { (values) in
            print(values.debugDescription)
            if let priceAttribute = values.value {
                priceName = priceAttribute[0].priceName ?? ""
                priceImg = priceAttribute[0].priceImg ?? ""
            }
        })
        
    }
}

struct PriceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PriceDetailView(price: Price(priceId: 0, ptpId: 0, startTime: "", priceName: "", priceImg: ""))
    }
}
