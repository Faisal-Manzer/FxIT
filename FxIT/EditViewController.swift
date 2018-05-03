//
//  EditViewController.swift
//  FxIT
//
//  Created by Faisal Manzer on 30/04/18.
//  Copyright © 2018 Faisal Manzer. All rights reserved.
//

import UIKit
import AVFoundation

class EditViewController: UIViewController, AVAudioRecorderDelegate {
    //MARK: Properties
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var echoLabel: UILabel!
    @IBOutlet weak var reverbLabel: UILabel!
    
    
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var echoSwitch: UISwitch!
    @IBOutlet weak var reverbSwitch: UISwitch!
    
    
    @IBOutlet weak var playButton: UIButton!
    
    var effect = Effects()
    
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    var isPlaying = false
    enum PlayingState { case playing, notPlaying }
    
    enum sliderType: Int {
        case speed
        case pitch
    }
    
    enum switchType: Int {
        case echo
        case reverb
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
        setupAudio()
    }

    //MARK: Actions
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let sliderValue = Float(sender.value)
        switch(sliderType(rawValue: sender.tag)!){
        case .speed:
//            speedSliderValue = sliderValue
            effect.speed = sliderValue
//            speedLabel.text = "Speed:\(sliderValue)"
        case .pitch:
//            pitchSliderValue = sliderValue
            effect.pitch = sliderValue
//            pitchLabel.text = "Pitch:\(sliderValue)"
        }
    }
    
    @IBAction func switchStateChanged(_ sender: UISwitch) {
        let state = sender.isOn
        switch (switchType(rawValue: sender.tag)!) {
        case .echo:
//            isEcho = state
            effect.echo = state
//            echoLabel.text = "Echo:\(state)"
        case .reverb:
//            isReverb = state
            effect.reverb = state
//            reverbLabel.text = "Reverb:\(state)"
        }
    }
   
    @IBAction func presetButtionAction(_ sender: UIButton) {
        switch(presetButton(rawValue: sender.tag)!) {
        case .snail:
            effect = Effects(speed: 0.5)
        case .rabbit:
            effect = Effects(speed: 1.5)
        case .chipmunk:
            effect = Effects(pitch: 1000)
        case .vader:
            effect = Effects(pitch: -1000)
        case .echo:
            effect = Effects(echo: true)
        case .reverb:
            effect = Effects(reverb: true)
        }
        
        resetUI()
    }
    
    
    @IBAction func resetAll(_ sender: UIButton) {
        effect = Effects()
        resetUI()
    }
    
    func resetUI() {
        echoSwitch.setOn(effect.echo, animated: true)
        reverbSwitch.setOn(effect.reverb, animated: true)
        speedSlider.setValue(effect.speed, animated: true)
        pitchSlider.setValue(effect.pitch, animated: true)
    }
    
    
    @IBAction func playButton(_ sender: UIButton) {
        isPlaying = !isPlaying
        if isPlaying {
            playSound()
            configureUI(.playing)
        } else {
            stopAudio()
            configureUI(.notPlaying)
        }
    }
    
    @IBAction func saveFile(_ sender: Any) {
        performSegue(withIdentifier: "saveSegue", sender: "saveFile")

    }
    
}
