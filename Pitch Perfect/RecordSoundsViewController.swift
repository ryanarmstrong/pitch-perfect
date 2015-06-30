//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ryan Armstrong on 6/8/15.
//  Copyright (c) 2015 Ryan Armstrong. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!

    var audioRecorder:AVAudioRecorder!
    var recording: RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        // Hide the Stop button.
        stopButton.hidden = true

        // Make sure the record button is enabled
        recordButton.enabled = true

        // Make sure the instructions are set
        recordingLabel.text = "Tap to record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playSoundSegue" {
            var destination = segue.destinationViewController as! PlaySoundsViewController
            recording = sender as! RecordedAudio
            destination.recording = recording
        }
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            // Save the recorded audio
            recording = RecordedAudio(url: recorder.url, lastPathComponent: recorder.url.lastPathComponent!)

            // Move to the next segue
            self.performSegueWithIdentifier("playSoundSegue", sender: recording)
        }
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled = false;
        recordingLabel.text = "Recording in progress"
        stopButton.hidden = false

        // Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String

        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)

        // Set up an Audio session.
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        // Set up the AVAuditoRecorder and start recording.
        var error: NSError?
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: &error)
        audioRecorder.delegate = self
        if let e = error {
            println(e.localizedDescription)
        } else {
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingLabel.text = "Tap to record"
        stopButton.hidden = true
        recordButton.enabled = true

        // Stop the recording and mark the session as no longer active.
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }


}

