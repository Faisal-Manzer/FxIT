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
    let recordInProgress = "Recording..."
    let recordInStandBy = "Tap to record"
    let recordImage = UIImage(named: "record")
    let stopImage = UIImage(named: "stop")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Methods
    @IBAction func toggleRecording(_ sender: Any) {
        assistanceLabel.text = isRecording ? recordInProgress : recordInStandBy
        recordBtnImage.image = isRecording ? stopImage : recordImage
        isRecording = !isRecording
    }
    
}

