//
//  NetworkConnector.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2020/12/2.
//  Copyright © 2020 mmlab. All rights reserved.
//

import Foundation
import Alamofire
import SwiftUI
import Combine


final class NetworkConnector:APIHandler, Identifiable{
    var isLoading = false
    let objectWillChange = PassthroughSubject<Void, Never>()
            
    func getData(url: String, para: Dictionary<String, String>) {
        print("getData..."+url)
        isLoading = true

        
        AF.request(url, method: .post, parameters: para).responseDecodable { [weak self] (response: DataResponse<ResponseFormat, AFError>) in
            guard let weakSelf = self else { return }
            
            guard let response = weakSelf.handleResponse(response)  else {
                weakSelf.isLoading = false
                print("response error...")
                return
            }
            
            //weakSelf.isLoading = false
            //weakSelf.responseFormat = response
//            print(self?.ResponseFormat?.results.first?.POI_id ?? 8787)
        }
    }
    
    
//    struct SimpleMessage: Codable{
//        var result: String;
//    };
//    let requestModel = RequestModel()
//    let reponseModel = ResponseModel()
//
//    func Connect(_ APIUrl:String,_ parameters: Dictionary<String, AnyObject>,_ responseFunction:@escaping (AnyObject)->Void){
//        AF.request(APIUrl, method: .post, parameters: parameters)
//            .responseJSON{ response in
////                do {
////                    let decoder = JSONDecoder();
////                    try decoder.decode(SimpleMessage.self, from: response.value as! Data);
////                } catch {
////                    fatalError("Couldn't parse")
////                }
//                let result = response.value as AnyObject
//                responseFunction(result)
////                if let result = response.value {
////                    let JSON = result as! NSDictionary
////                    print(JSON)
////                }
//            }
//    }

    func login() -> Bool{
        return true
    }
}
