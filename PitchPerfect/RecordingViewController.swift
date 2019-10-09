//
//  RecordingViewController.swift
//  PitchPerfect
//
//  Created by Abdullah Bandan on 05/01/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController,AVAudioRecorderDelegate {

    @IBOutlet var startAndStopLabel: UILabel!
    @IBOutlet var startRecordingButtonOutlet: UIButton!
    @IBOutlet var stopRecordingButtonOutlet: UIButton!
    var audioRecorder: AVAudioRecorder!
    
    @IBAction func startRecordingButton(_ sender: Any) {
        configureUI(isRecording:true)
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
    
    @IBAction func stopRecordingButton(_ sender: Any) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecordingSeque", sender: audioRecorder.url)
            configureUI(isRecording:false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingSeque"{
            let listeningVC = segue.destination as! ListeningViewController
            let recordedAudioURL = sender as! URL
            listeningVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUI(isRecording: Bool) {
        stopRecordingButtonOutlet.isEnabled = isRecording // to disable the button
        startRecordingButtonOutlet.isEnabled = !isRecording // to enable the button
        startAndStopLabel.text = !isRecording ? "Tap to Record" : "Recording in Progress"
        
    }

}

