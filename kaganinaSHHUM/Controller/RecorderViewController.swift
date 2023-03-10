//
//  RecorderViewController.swift
//  kaganinaSHHUM
//

import Foundation
import UIKit
import AVFAudio
import AVFoundation

final class RecorderViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
    }
    
    private func makeMenuButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }
    
    private func setupView() {
        self.view.backgroundColor = .blue
        
        let recordStartButton = makeMenuButton(title: "START")
        recordStartButton.addTarget(
            self,
            action: #selector(startRecording),
            for: .touchUpInside
        )
        let recordStopButton = makeMenuButton(title: "STOP")
        recordStopButton.addTarget(
            self,
            action: #selector(stopRecording),
            for: .touchUpInside
        )
        
        let buttonsSV = UIStackView(arrangedSubviews: [
            recordStartButton, recordStopButton
        ])
        buttonsSV.spacing = 12
        buttonsSV.axis = .vertical
        buttonsSV.distribution = .fillEqually

        self.view.addSubview(buttonsSV)
        buttonsSV.pinTop(to: self.view)
        buttonsSV.pinLeft(to: self.view, self.view.frame.width / 10)
        buttonsSV.pinRight(to: self.view, self.view.frame.width / 10)
        buttonsSV.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    private func setupNavBar() {
        self.title = "RECORDER"
        let closeButton = UIButton(type: .close)
        closeButton.layer.cornerRadius = 12
        closeButton.addTarget(
            self,
            action: #selector(dismissViewController(_:)),
            for: .touchUpInside
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    @objc
    private func startRecording() {
        self.view.backgroundColor = .systemTeal
    }
    
    @objc
    private func stopRecording() {
        self.view.backgroundColor = .systemPink
    }
    
    @objc
    private func dismissViewController(_ sender: UIViewController) {
        self.dismiss(animated: true)
    }
    
    

}

extension RecorderViewController: AVAudioPlayerDelegate {
    
}

extension RecorderViewController: AVAudioRecorderDelegate {
    
}

/*
 
 extension RecorderViewController: AVAudioRecorderDelegate {
     func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
         if !flag {
             finishRecording(success: false)
         }
     }
 }

 extension RecorderViewController: AVAudioPlayerDelegate {
     func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
         finishPlayback()
     }
 }
 
 */


/////////////


//
//  ViewController.swift
//  VoiceRecorder
//
//  Created by  William on 2/6/19.
//  Copyright © 2019 Vasiliy Lada. All rights reserved.
//

import UIKit
import AVFoundation

/*

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

final class RecorderViewController: UIViewController {

    var recordButton = UIButton()
    var playButton = UIButton()
    
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        /*
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record!
        }*/
    }
    
    func loadRecordingUI() {
        recordButton.isHidden = false
        recordButton.setTitle("Tap to Record", for: .normal)
    }
    
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if audioPlayer == nil {
            startPlayback()
        } else {
            finishPlayback()
        }
    }
    
    
    // MARK: - Recording

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
            playButton.setTitle("Play Your Recording", for: .normal)
            playButton.isHidden = false
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            playButton.isHidden = true
            // recording failed :(
        }
    }
    
    
    // MARK: - Playback
    
    func startPlayback() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.delegate = self
            audioPlayer.play()
            playButton.setTitle("Stop Playback", for: .normal)
        } catch {
            playButton.isHidden = true
            // unable to play recording!
        }
    }
    
    func finishPlayback() {
        audioPlayer = nil
        playButton.setTitle("Play Your Recording", for: .normal)
    }

}

extension RecorderViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
}

extension RecorderViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        finishPlayback()
    }
    
}
 

*/
//////////////////

/*

import Foundation
import UIKit
import AVFoundation
//import FirebaseStorage // ?

final class RecorderViewController: UIViewController {
    
    var audioRecorder = AVAudioRecorder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Microphone access granted")
            } else {
                print("Microphone access denied")
            }
        }
        
        setupAudioRecorder()
    }
    
    private func setupView() {
        self.view.backgroundColor = .blue
        
        let recordStartButton = makeMenuButton(title: "START")
        recordStartButton.addTarget(
            self,
            action: #selector(startRecording),
            for: .touchUpInside
        )
        let recordStopButton = makeMenuButton(title: "STOP")
        recordStopButton.addTarget(
            self,
            action: #selector(stopRecording),
            for: .touchUpInside
        )
    }
    
    private func setupNavBar() {
        self.title = "RECORDER"
        let closeButton = UIButton(type: .close)
        closeButton.layer.cornerRadius = 12
        closeButton.addTarget(
            self,
            action: #selector(dismissViewController(_:)),
            for: .touchUpInside
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    @objc
    private func dismissViewController(_ sender: UIViewController) {
        self.dismiss(animated: true)
    }
    
    private func makeMenuButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        button.backgroundColor = .white
        return button
    }

    func setupAudioRecorder() {
        
        let cont = DirectoryViewController()
        
        let audioFilename = cont.getDocumentsDirectory().appendingPathComponent("recording.wav")

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.prepareToRecord()

        } catch {
            print("Error setting up audio recorder: \(error.localizedDescription)")
        }
    }
    
    @objc
    func startRecording() {
        if !audioRecorder.isRecording {
            audioRecorder.record()
        }
    }

    @objc
    func stopRecording() {
        if audioRecorder.isRecording {
            audioRecorder.stop()
        }
    }
}
*/
