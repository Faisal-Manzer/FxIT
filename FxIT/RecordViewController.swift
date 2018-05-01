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
    
    var isRecording = false
    let recordInProgress = "Recording... Tap on done"
    let recordInStandBy = "Tap to record"
    let recordImage = UIImage(named: "record")
    let stopImage = UIImage(named: "stop")
    let recordingImageArray = [UIImage(named: "recording1"), UIImage(named: "recording2"), UIImage(named: "recording3"), UIImage(named: "record"),]
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        assistanceLabel.text = recordInStandBy
        if recordBtnImage.isAnimating {
            recordBtnImage.stopAnimating()
        }
        recordBtnImage.image = recordImage
    }
    
    //MARK: Methods
    @IBAction func toggleRecording(_ sender: Any) {
        isRecording = !isRecording
        if isRecording {
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
            edidSoundVC.recordedAudioUrl = recordedAudioURL
        }
    }
    
}

