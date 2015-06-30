//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ryan Armstrong on 6/10/15.
//  Copyright (c) 2015 Ryan Armstrong. All rights reserved.
//

import UIKit
import AVFoundation

class  PlaySoundsViewController: UIViewController {

    @IBOutlet weak var stopButton: UIButton!

    var audioEngine : AVAudioEngine = AVAudioEngine()
    var audioPlayer : AVAudioPlayerNode = AVAudioPlayerNode()
    var audioFile : AVAudioFile!
    var recording : RecordedAudio!

    var error: NSError?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the recorded audio into the player.
        audioEngine.attachNode(audioPlayer)

        // Load the audio file
        audioFile = AVAudioFile(forReading: recording.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func playSound(rate: Float = 1.0, pitch: Float = 1.0) {
        // Make sure the engine and player are ready for playback.
        prepareForPlayback()

        // Enable the stop button.
        stopButton.enabled = true

        var effects = AVAudioUnitTimePitch()
        effects.pitch = pitch
        effects.rate = rate
        audioEngine.attachNode(effects)

        // Hook up the player node to the effects node.
        audioEngine.connect(audioPlayer, to: effects, format: audioFile.processingFormat)
        audioEngine.connect(effects, to: audioEngine.outputNode, format: audioFile.processingFormat)

        // Schedule and play the sound
        audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: soundFinishedPlaying)
        audioEngine.startAndReturnError(&error)

        if let e = error {
            println("There was an error processing the audio file.")
        } else {
            audioPlayer.play()
        }
    }

    func prepareForPlayback() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

    func soundFinishedPlaying() {
        stopButton.enabled = false
    }
    
    @IBAction func playSoundSlow(sender: UIButton) {
        playSound(rate: 0.25)
    }

    @IBAction func playSoundFast(sender: UIButton) {
        playSound(rate: 2.0)
    }

    @IBAction func stopSound(sender: UIButton) {
        prepareForPlayback()
        stopButton.enabled = false
    }

    @IBAction func playSoundChipmunk(sender: UIButton) {
        playSound(pitch: 2500)
    }

    @IBAction func playSoundDarthVader(sender: UIButton) {
        playSound(pitch: -1000)
    }
}
