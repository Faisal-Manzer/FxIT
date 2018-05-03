//
//  RecordViewController.swift
//  FxIT
//
//  Created by Faisal Manzer on 28/04/18.
//  Copyright © 2018 Faisal Manzer. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    //MARK: Properties
    @IBOutlet weak var assistanceLabel: UILabel!
    @IBOutlet weak var recordBtnImage: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    
    var isRecording = false
    var isPermission = false
    let recordInProgress = "Recording... Tap on done"
    let recordInStandBy = "Tap to record"
    let recordImage = UIImage(named: "record")
    let askPermissionImage = UIImage(named: "ask")
    let deniedPermissionImage = UIImage(named: "denied")
    let permissionDeniedText = "Please Give Recording Permission..."
    let settingSteps = "Settings> FxIT> Microphone"
    let askPermissionText = "Tap to Enable Microphone"
    let stopImage = UIImage(named: "stop")
    let recordingImageArray = [UIImage(named: "recording1"), UIImage(named: "recording2"), UIImage(named: "recording3"), UIImage(named: "record"),]
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if recordBtnImage.isAnimating {
            recordBtnImage.stopAnimating()
        }
        assistanceLabel.text = recordInStandBy
        settingLabel.text = ""
        recordBtnImage.isUserInteractionEnabled = true
        permissionSetting()
    }
    
    //MARK: Methods
    @IBAction func toggleRecording(_ sender: Any) {
        isRecording = !isRecording
        if isRecording && isPermission{
            recordAuido()
        } else {
            stopRecording()
        }
    }
    
    func recordAuido() {
        assistanceLabel.text = recordInProgress
        recordBtnImage.animationImages = recordingImageArray as? [UIImage]
        recordBtnImage.animationDuration = 1
        recordBtnImage.startAnimating()
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecording() {
        assistanceLabel.text = recordInStandBy
        recordBtnImage.stopAnimating()
        recordBtnImage.image = recordImage
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //MARK: AVDelgates
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // recoding saved
            performSegue(withIdentifier: "editAudioSegue", sender: audioRecorder.url)
        } else {
            // not saved
        }
    }
    
    //MARK: Segue Preprations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAudioSegue" {
            let edidSoundVC = segue.destination as! EditViewController
            let recordedAudioURL = sender as! URL
            edidSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    //MARK: Permession
    func permissionSetting() {
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            assistanceLabel.text = recordInStandBy
            recordBtnImage.image = recordImage
            isPermission = true
        case AVAudioSessionRecordPermission.denied:
            assistanceLabel.text = permissionDeniedText
            settingLabel.text = settingSteps
            recordBtnImage.isUserInteractionEnabled = false
            recordBtnImage.image = deniedPermissionImage
        case AVAudioSessionRecordPermission.undetermined:
            assistanceLabel.text = askPermissionText
            recordBtnImage.image = askPermissionImage
        }
    }
}

