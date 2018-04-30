//
//  RecordViewController.swift
//  FxIT
//
//  Created by Faisal Manzer on 28/04/18.
//  Copyright © 2018 Faisal Manzer. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var assistanceLabel: UILabel!
    @IBOutlet weak var recordBtnImage: UIImageView!
    
    var isRecording = false
    let recordInProgress = "Recording... Tap on done"
    let recordInStandBy = "Tap to record"
    let recordImage = UIImage(named: "record")
    let stopImage = UIImage(named: "stop")
    let recordingImageArray = [UIImage(named: "recording1"), UIImage(named: "recording2"), UIImage(named: "recording3"), UIImage(named: "record"),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        assistanceLabel.text = recordInStandBy
        recordBtnImage.image = recordImage
    }
    
    //MARK: Methods
    @IBAction func toggleRecording(_ sender: Any) {
        
        isRecording = !isRecording
        assistanceLabel.text = isRecording ? recordInProgress : recordInStandBy
        if isRecording {
            recordBtnImage.animationImages = recordingImageArray as? [UIImage]
            recordBtnImage.animationDuration = 1
            recordBtnImage.startAnimating()
        } else {
            recordBtnImage.stopAnimating()
            recordBtnImage.image = recordImage
        }
    }
    
}

