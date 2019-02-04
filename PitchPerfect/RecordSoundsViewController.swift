//
// RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by ابرار on ٣ ربيع١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ Udacity. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController ,AVAudioRecorderDelegate {
    var audioRecorder :AVAudioRecorder!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var isrecoding :Bool = false
    @IBOutlet weak var stopRecordingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(isRecording: isrecoding)
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }

    @IBAction func recordAudio(_ sender: Any) {
        isrecoding = true
        setup(isRecording: isrecoding)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord,mode: .moviePlayback, options:AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
    isrecoding = false
        setup(isRecording: isrecoding)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    func setup(isRecording: Bool) {
        if isRecording {
            recordingLabel.text = "Recording in Progress..."
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        }
        else {
            recordingLabel.text = "Tap to Record"
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print ("finished Recording")
        if flag{
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print ("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let PlaySoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            PlaySoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }
    
}

