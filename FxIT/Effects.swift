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

    init(speed: Float = 1.0, pitch: Float = 0.0, echo: Bool = false, reverb: Bool = false) {
        self.speed = speed
        self.pitch = pitch
        self.echo = echo
        self.reverb = reverb
    }
}
