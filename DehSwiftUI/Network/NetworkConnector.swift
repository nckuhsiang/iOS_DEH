//
//  NetworkConnector.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/29.
//  Copyright © 2020 mmlab. All rights reserved.
//

import SwiftUI
import Alamofire

class NetworkConnector{
    func getDataPublisherDecodable<T:Decodable>(url: String, para: Parameters) ->  DataResponsePublisher<T> {
        return AF.request(url, method: .post, parameters: para)
            .publishDecodable(type: T.self, queue: .main)
            
    }
    func getDataPublisherDecodable2(url: String, para: Parameters) ->  DataResponsePublisher<XOI> {
        return AF.request(url, method: .post, parameters: para)
            .publishDecodable(type: XOI.self, queue: .main)
    }
    func getDataPublisher(url: String, para: Parameters) -> DataResponsePublisher<Data> {
        return AF.request(url, method: .post, parameters: para)
            .publishData()
    }
    
}


