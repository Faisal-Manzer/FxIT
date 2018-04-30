//
//  EditClass.swift
//  FxIT
//
//  Created by Faisal Manzer on 30/04/18.
//  Copyright © 2018 Faisal Manzer. All rights reserved.
//

import Foundation

class Effects {
    
    //MARK: Properties
    var speed: Float
    var pitch: Float
    var echo: Bool
    var reverb: Bool
    
    enum defaultEffects: Int {
        case snail
        case rabbit
        case echo
        case reverb
        case chipmunk
        case vader
        func defaults() -> Effects {
            switch self {
            case .snail:
                return Effects(speed: 0.5)
            case .rabbit:
                return Effects(speed: 1.5)
            case .chipmunk:
                return Effects(pitch: 1000)
            case .vader:
                return Effects(pitch: 1000)
            case .reverb:
                return Effects(reverb: true)
            case .echo:
                return Effects(echo: true)
            }
        }
    }
    init(speed: Float = 1.0, pitch: Float = 0.0, echo: Bool = false, reverb: Bool = false) {
        self.speed = speed
        self.pitch = pitch
        self.echo = echo
        self.reverb = reverb
    }
}
