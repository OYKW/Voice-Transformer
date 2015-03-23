//
//  RecordSoundsViewController.swift
//  Voice Transformer
//
//  Created by Olivia Wang on 3/15/15.
//  Copyright (c) 2015 Halfspace. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: Set up variables
    var audioRecorder:AVAudioRecorder!
    var recordedSound:RecordedAudio!
    
    // MARK: Create outlets

    @IBOutlet weak var recorderLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var pauseLabel: UILabel!

    
    @IBOutlet weak var stopLabel: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    // MARK: Record audio and transition to the next screen
    
    @IBAction func recordAudio(sender: UIButton) {
        
        recorderLabel.text = "Recording..."
        pauseLabel.hidden = false
        pauseButton.hidden = false
        stopLabel.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        
        
        
        audioRecorder.record()
        
        
        
        
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if flag {
            // Save the recorded sound to a file
            recordedSound = RecordedAudio(filePathURL: audioRecorder.url, title: audioRecorder.url.lastPathComponent)
            
            // Move to the next scene
            self.performSegueWithIdentifier("toScene2", sender: recordedSound)
            
        } else {
      
            recordButton.enabled = true
            stopButton.hidden = true
            stopLabel.hidden = true
            pauseButton.hidden = true
            pauseButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toScene2"){
            var playSoundController: PlaySoundsViewController! = segue.destinationViewController as! PlaySoundsViewController
            var data = sender as! RecordedAudio
            playSoundController.receivedSound = data
        }
    }
    

    
    
    
    @IBAction func stopAudio(sender: UIButton) {
        recorderLabel.text = "Tap to Record"
        recordButton.enabled = true
        
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        recorderLabel.text = "Tap to Continue"
        recordButton.enabled = true
        
        audioRecorder.pause()
        
    }
    override func viewWillAppear(animated: Bool) {
        stopLabel.hidden = true
        stopButton.hidden = true
        pauseLabel.hidden = true
        pauseButton.hidden = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMddyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let fileURL = NSURL.fileURLWithPathComponents(pathArray)
        
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: fileURL, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

