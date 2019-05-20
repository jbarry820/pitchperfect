//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by James Barry on 5/6/19.
//  Copyright © 2019 Jim Barry. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: For purpose of making buttons so they are nor distorted
        stopRecordingButton.isEnabled = false
        stopRecordingButton.contentMode = .center
        stopRecordingButton.imageView?.contentMode = .scaleAspectFit
        recordButton.contentMode = .center
        recordButton.imageView?.contentMode = .scaleAspectFit
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }

    @IBAction func recordAudio(_ sender: Any) {
        appIsRecording(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        appIsRecording(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            //print("recording was not successful")
            let alert = UIAlertController(title: "Audio Failed", message: "Recording Failed.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    // This function is in response to "Cleaning up RecordSoundsViewController instructions
    func appIsRecording(isRecording: Bool) {
        stopRecordingButton.isEnabled = isRecording // to enable the button
        recordButton.isEnabled = !isRecording // to disable the button
        recordingLabel.text = isRecording ? "Recording in Progress" : "Tap to Record"
//        if isRecording == true {
//            recordingLabel.text = "Recording in Progress"
//            stopRecordingButton.isEnabled = true
//            recordButton.isEnabled = false
//        } else {
//            recordButton.isEnabled = true
//            stopRecordingButton.isEnabled = false
//            recordingLabel.text = "Tap to Record"
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

