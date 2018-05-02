//
//  EditViewController.swift
//  FxIT
//
//  Created by Faisal Manzer on 30/04/18.
//  Copyright © 2018 Faisal Manzer. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var echoLabel: UILabel!
    @IBOutlet weak var reverbLabel: UILabel!
    
    var effect = Effects()
    var recordedAudioURL: URL!
    var speedSliderValue: Float = 1
    var pitchSliderValue: Float = 0
    var isEcho: Bool = false
    var isReverb: Bool = false
    enum SliderType: Int {
        case speed = 0, pitch = 1
    }
    enum presetButton: Int {
        case snail
        case chipmunk
        case echo
        case rabbit
        case vader
        case reverb
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: Actions
    @IBAction func speedValueChange(_ sender: UISlider) {
        let sliderValue = Float(sender.value)
        speedLabel.text = "Speed = \(sliderValue)"
        speedSliderValue = sliderValue
        effect.speed = sliderValue
    }
  
    @IBAction func pitchValueChange(_ sender: UISlider) {
        let sliderValue = Float(sender.value)
        pitchLabel.text = "Pitch = \(sliderValue)"
        pitchSliderValue = sliderValue
        effect.pitch = sliderValue
    }
    
    @IBAction func echoStateChange(_ sender: UISwitch) {
        let state = sender.isOn
        echoLabel.text = "Echo = \(state)"
        isEcho = state
        effect.echo = state
    }
    
    @IBAction func reverbStateChange(_ sender: UISwitch) {
        let state = sender.isOn
        reverbLabel.text = "Reverb = \(state)"
        isReverb = state
        effect.reverb = state
    }
    
    @IBAction func presetButtonActio(_ sender: UIButton) {
        switch(presetButton(rawValue: sender.tag)!) {
        case .snail:
            print("snail")
        case .rabbit:
            print("rabbit")
        case .chipmunk:
            print("chipmunk")
        case .vader:
            print("vader")
        case .echo:
            print("echo")
        case .reverb:
            print("reverb")
        }
    }
    
}
