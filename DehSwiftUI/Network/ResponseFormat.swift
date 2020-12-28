//
//  WoofResponse.swift
//  DehSwiftUI
//
//  Created by mmlab on 2020/12/23.
//  Copyright © 2020 mmlab. All rights reserved.
//
import SwiftUI
import Alamofire

struct Data: Decodable{
    let POI_id: Int
    let POI_title: String
    let latitude: Double
    let longitude: Double
    var subject: String
    var identifier: String = ""
    var POI_description: String = ""
//        var viewNumbers: Int = 0
//        var mediaCategory: String = ""
    
    
        enum ResultKeys: CodingKey{
            case POI_id
            case POI_title
            case latitude
            case longitude
            case identifier
            case subject
            case POI_description
//            case viewNumbers
//            case mediaCategory
        }
    
}

final class ResponseFormat:ObservableObject, Decodable{
    @EnvironmentObject var XOIs:SettingStorage
//    @Published var XOIs:[String:[XOI]] = [
//        "favorite" : [testxoi[0]],
//        "nearby" : [testxoi[1]],
//        "group" : [testxoi[2]],
//        "mine" : [testxoi[3]],
//    ]
    
    
    
    enum CodingKeys: String, CodingKey {
        case XOIs = "results"
    }
    init(){}
    
    required init(from decoder: Decoder) throws {
        print("start decode...")
        do{
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.XOIs.XOIs["group"] = try container.decode([XOI].self, forKey: .XOIs)
            print(self.XOIs.XOIs["group"]?.first?.id ?? 8787)
        }catch{
            print("出現錯誤 ： \(error)")
        }
        
//        let ResultContainer = try container
//          .nestedContainer(keyedBy: ResultKeys.self, forKey: .result)
//
//        id = try ResultContainer.decode(Int.self, forKey: .id)
//        name = try ResultContainer.decode(String.self, forKey: .name)
//        latitude = try ResultContainer.decode(Double.self, forKey: .latitude)
//        longitude = try ResultContainer.decode(Double.self, forKey: .longitude)
//        creatorCategory = try ResultContainer.decode(String.self, forKey: .creatorCategory)
//        xoiCategory = try ResultContainer.decode(String.self, forKey: .xoiCategory)
//        detail = try ResultContainer.decode(String.self, forKey: .detail)
//        viewNumbers = try ResultContainer.decode(Int.self, forKey: .viewNumbers)
//        mediaCategory = try ResultContainer.decode(String.self, forKey: .mediaCategory)

    }
    
    var statusCode = Int.zero
    
    func handleResponse<T: Decodable>(_ response: DataResponse<T, AFError>) -> Any? {
        switch response.result {
        case .success:
            return response.value
        case .failure:
            return nil
        }
    }
    
//    func getData(url: String, para: Dictionary<String, String>) {
//        print("getData..."+url)
//    // isLoading = true
//
//        
//        AF.request(url, method: .post, parameters: para).responseDecodable { [weak self] (response: DataResponse<ResponseFormat, AFError>) in
//            guard let weakSelf = self else { return }
//            
//            guard let response = weakSelf.handleResponse(response) as? ResponseFormat else {
//                //weakSelf.isLoading = false
//                print("response error...")
//                return
//            }
//            
//            //weakSelf.isLoading = false
//            weakSelf.XOIs = response.XOIs
////            print(self?.ResponseFormat?.results.first?.POI_id ?? 8787)
//        }
//    }
}

