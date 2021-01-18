//
//  ImageCheckExtension.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2021/1/16.
//  Copyright © 2021 mmlab. All rights reserved.
//

import SwiftUI

//extension Image{
//    func setDefault(defaultPic:String) -> Image{
//        if ( != nil){
//            return self
//        }
//        else{
//            return Image(defaultPic)
//        }
//    }
//}
extension String{
    func checkImageExist(defaultPic:String) -> String{
        if let _ = UIImage(named: self){
            return self
        }
        else{
            return defaultPic
        }
    }
}
