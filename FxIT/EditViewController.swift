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
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingDisabledTitle = "Recording Disabled"
        static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    }
    
    enum PlayingState { case playing, notPlaying }

    
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
    
    //MARK: AudioFunctions
    func setupAudio() {
        // initialize (recording) audio file
        do {
            audioFile = try AVAudioFile(forReading: recordedAudioURL as URL)
        } catch {
            showAlert(Alerts.AudioFileError, message: String(describing: error))
        }
    }
    
    func playSound() {
        let rate: Float? = effect.speed
        let pitch: Float? = effect.pitch
        let echo: Bool? = effect.echo
        let reverb: Bool? = effect.reverb
        
        // initialize audio engine components
        audioEngine = AVAudioEngine()
        
        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        // node for adjusting rate/pitch
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        audioEngine.attach(changeRatePitchNode)
        
        // node for echo
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        audioEngine.attach(echoNode)
        
        // node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        audioEngine.attach(reverbNode)
        
        // connect nodes
        if echo == true && reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, audioEngine.outputNode)
        } else if echo == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, audioEngine.outputNode)
        } else if reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, audioEngine.outputNode)
        } else {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, audioEngine.outputNode)
        }
        
        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            // schedule a stop timer for when audio finishes playing
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(self.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoopMode.defaultRunLoopMode)
        }
        
        do {
            try audioEngine.start()
        } catch {
            showAlert(Alerts.AudioEngineError, message: String(describing: error))
            return
        }
        
        // play the recording!
        audioPlayerNode.play()
    }
    
    @objc func stopAudio() {
        
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        configureUI(.notPlaying)
        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
        
        isPlaying = false
    }
    
    func configureUI(_ playState: PlayingState) {
        switch playState {
        case .playing:
            playButton.setImage(UIImage(named: "stop"), for: .normal)
        case .notPlaying:
            playButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
