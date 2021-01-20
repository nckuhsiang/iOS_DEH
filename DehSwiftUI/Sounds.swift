//
//  Sounds.swift
//  DehSwiftUI
//
//  Created by 阮盟雄 on 2021/1/20.
//  Copyright © 2021 mmlab. All rights reserved.
//

import Foundation
import AVFoundation

class Sounds {
    
    static var audioPlayer:AVAudioPlayer?
    
    static func playSounds(soundfile: String) {
        
        if let path = Bundle.main.path(forResource: soundfile, ofType: nil){
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                
            }catch {
                print("Error")
            }
        }
    }
    static func playSounds(soundData: Data) {
        do{
            audioPlayer = try AVAudioPlayer(data: soundData)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
        catch {
            print("Error")
        }
        
        
        
    }
    
}
