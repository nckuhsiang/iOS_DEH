//
//  PriceModel.swift
//  DehSwiftUI
//
//  Created by 陳家庠 on 2021/11/3.
//  Copyright © 2021 mmlab. All rights reserved.
//

import Foundation
import SwiftUI

class Prize:Decodable,Identifiable {
    var prizeId:Int?
    var ptpId:Int?
    var startTime:String?
    var prizeName:String?
    var prizeImg:String?
    
    init(prizeId:Int, ptpId:Int, startTime:String, prizeName:String, prizeImg:String) {
        self.prizeId = prizeId
        self.ptpId = ptpId
        self.startTime = startTime
        self.prizeName = prizeName
        self.prizeImg = prizeImg
    }
    enum CodingKeys: String, CodingKey {
        case prizeId = "player_prize_id"
        case ptpId = "PTP_id"
        case startTime = "start_time"
        case prizeName = "prize_name"
        case prizeImg = "prize_url"
    }
}
