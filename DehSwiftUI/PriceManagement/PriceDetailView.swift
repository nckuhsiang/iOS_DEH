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

struct PriceDetailView: View {
    @State var price:Price
    @State var priceName:String = ""
    @State var cancellable:AnyCancellable?
    @State var image:UIImage?
    init(price:Price) {
        self.price = price
        
    }
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text("Price Item".localized)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                Text(priceName)
                    .font(.body)
                Image(uiImage: image ?? UIImage())
                    .resizable()
                    .frame( maxWidth: 250, maxHeight: 250,alignment: .center)
            }
            NavigationLink(destination: QRcodeView(price:price)) {
                Text("Exchange".localized)
                    .font(.system(size: 30, weight: .medium, design: .default))
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 20)
                    .foregroundColor(.white)
                    .background(Color(UIColor(rgba: lightGreen)))
            }
        }
        .onAppear {
            getPriceAttribute()
        }

    }
}
extension PriceDetailView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getPriceAttribute() {
        let url = GamePrizeAttributeUrl
        let parameters = ["player_prize_id": price.priceId ?? -1]
        let publisher: DataResponsePublisher<[Price]> = NetworkConnector().getDataPublisherDecodable(url: url, para: parameters)
        cancellable = publisher.sink(receiveValue: { (values) in
            print(values.debugDescription)
            if let priceAttribute = values.value {
                priceName = priceAttribute[0].priceName ?? ""
                let priceImg = priceAttribute[0].priceImg ?? ""
                var tempUrl = priceImg
                if let idx = tempUrl.firstIndex(of: "/") {
                    tempUrl = String(tempUrl.suffix(from: idx))
                }
                let imgUrl = URL(string: "http://deh.csie.ncku.edu.tw" + tempUrl)
                self.getData(from: imgUrl!) { data, response, error in
                    guard let data = data, error == nil else {return}
                    print("Download Finished")
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data, scale: 1)
                        
                    }
                }
                
            }
        })
        
    }
}

struct PriceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PriceDetailView(price: Price(priceId: 0, ptpId: 0, startTime: "", priceName: "", priceImg: ""))
    }
}
