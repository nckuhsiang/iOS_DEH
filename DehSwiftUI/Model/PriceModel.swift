//
//  PriceModel.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/11/3.
//  Copyright © 2021 mmlab. All rights reserved.
//

import Foundation
import SwiftUI

class Price:Decodable,Identifiable {
    var priceId:Int?
    var ptpId:Int?
    var startTime:String?
    var priceName:String?
    var priceImg:String?
    
    init(priceId:Int, ptpId:Int, startTime:String, priceName:String, priceImg:String) {
        self.priceId = priceId
        self.ptpId = ptpId
        self.startTime = startTime
        self.priceName = priceName
        self.priceImg = priceImg
    }
    enum CodingKeys: String, CodingKey {
        case priceId = "player_prize_id"
        case ptpId = "PTP_id"
        case startTime = "start_time"
        case priceName = "prize_name"
        case priceImg = "prize_url"
    }
}
