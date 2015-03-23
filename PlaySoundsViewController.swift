//
//  PlaySoundsViewController.swift
//  Voice Transformer
//
//  Created by Olivia Wang on 3/16/15.
//  Copyright (c) 2015 Halfspace. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    //MARK: Set up variables to play sounds
    var receivedSound:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    var audioPlayer:AVAudioPlayer!
    var audioPlayerEcho:AVAudioPlayer! //Define a second audio player to generate echo effect
    

    //MARK: Functions to play sounds
    @IBAction func playSoundSlow(sender: UIButton) {
        audioPlayer.stop()
        audioPlayerEcho.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 0.5
        audioPlayer.play()
        
    }
    @IBAction func playSoundFast(sender: UIButton) {
        audioPlayer.stop()
        audioPlayerEcho.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 2
        audioPlayer.play()
    }
    
    
    @IBAction func playSoundHighPitch(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch:Float){
        audioPlayer.stop()
        audioPlayerEcho.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //Define nodes for audioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
    
    @IBAction func playSoundLowPitch(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playSoundReverb(sender: UIButton) {
        audioPlayer.stop()
        audioPlayerEcho.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 50
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    @IBAction func playSoundEcho(sender: UIButton) {
        // First audioPlayer play sounds normally
        audioPlayer.stop()
        audioPlayerEcho.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
        var playTimeForEcho = audioPlayerEcho.deviceCurrentTime + 0.2
        audioPlayerEcho.volume = 0.7
        audioPlayerEcho.stop()
        audioPlayerEcho.currentTime = 0.0
        audioPlayerEcho.playAtTime(playTimeForEcho)
        
    }
    @IBAction func playSoundStop(sender: UIButton) {
        audioEngine.stop()
        audioPlayerEcho.stop()
        audioPlayer.stop()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedSound.filePathURL, error: nil)
        audioPlayerEcho = AVAudioPlayer(contentsOfURL: receivedSound.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedSound.filePathURL, error: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
