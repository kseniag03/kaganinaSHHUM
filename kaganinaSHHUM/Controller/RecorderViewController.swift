//
//  RecorderViewController.swift
//  kaganinaSHHUM
//

import Foundation
import UIKit
import AVFAudio
import AVFoundation

final class RecorderViewController: UIViewController {
    
    var recorder : AVAudioRecorder?
    
    var player : AVAudioPlayer?
    
    let file = "record.m4a"
    
    var recordStartButton = UIButton()
    
    var recordStopButton = UIButton()
    
    var playRecordButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        
        setupRecorder()
    }
    
    private func setupRecorder() {
        
        let recordSettings = [AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0 ] as [String : Any]
        
        do {
            recorder = try AVAudioRecorder(url: getFileURL(fileName: file), settings: recordSettings as [String : Any])
            recorder?.delegate = self
            recorder?.prepareToRecord()
        } catch {
            print("!!!!!! smth is wrong\n")
        }
    }
    
    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return paths[0]
    }
    
    func getFileURL(fileName: String) -> URL {
        let path = (getCacheDirectory() as NSString).appendingPathComponent(fileName)
        let filePath = URL(fileURLWithPath: path)
        return filePath
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
        
        recordStartButton = makeMenuButton(title: "START")
        recordStartButton.addTarget(
            self,
            action: #selector(startRecording),
            for: .touchUpInside
        )
        
        recordStopButton = makeMenuButton(title: "STOP")
        recordStopButton.addTarget(
            self,
            action: #selector(stopRecording),
            for: .touchUpInside
        )
        
        playRecordButton = makeMenuButton(title: "PLAY")
        playRecordButton.addTarget(
            self,
            action: #selector(playRecord),
            for: .touchUpInside
        )
        
        let buttonsSV = UIStackView(arrangedSubviews: [
            recordStartButton, recordStopButton, playRecordButton
        ])
        buttonsSV.spacing = 12
        buttonsSV.axis = .vertical
        buttonsSV.distribution = .fillEqually

        self.view.addSubview(buttonsSV)
        buttonsSV.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor)
        buttonsSV.pinLeft(to: self.view, self.view.frame.width / 10)
        buttonsSV.pinRight(to: self.view, self.view.frame.width / 10)
        buttonsSV.pinHeight(to: self.view.safeAreaLayoutGuide.heightAnchor)
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
    
    private func changeButtonState(button: UIButton) {
        if button.isEnabled {
            button.backgroundColor = .red
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .white
            button.setTitleColor(.systemGray, for: .normal)
        }
    }
    
    @objc
    private func startRecording() {
        self.view.backgroundColor = .systemTeal
        
        if recordStartButton.titleLabel?.text == "START" {
            recorder?.record()
            recordStartButton.setTitle("PAUSE", for: .normal)
        } else {
            recorder?.pause()
            recordStartButton.setTitle("START", for: .normal)
        }
        recordStopButton.isEnabled = true
        playRecordButton.isEnabled = false
        changeButtonState(button: recordStartButton)
        changeButtonState(button: playRecordButton)
        
    }
    
    @objc
    private func stopRecording() {
        self.view.backgroundColor = .systemPink
        recorder?.stop()
        
        playRecordButton.isEnabled = true
        recordStopButton.isEnabled = false
        changeButtonState(button: recordStopButton)
        changeButtonState(button: playRecordButton)
        
        recordStartButton.setTitle("START", for: .normal)
    }
    
    @objc
    private func playRecord() {
        self.view.backgroundColor = .systemGreen
        
        if playRecordButton.titleLabel?.text == "PLAY" {
            
            recordStartButton.isEnabled = false
            recordStopButton.isEnabled = false
            changeButtonState(button: recordStartButton)
            changeButtonState(button: recordStopButton)
            
            playRecordButton.setTitle("STOP PLAY", for: .normal)
            
            preparePlayer()
            player?.play()
            
        } else {
            player?.stop()
            playRecordButton.setTitle("PLAY", for: .normal)
        }
        
        
        
    }
    
    @objc
    private func dismissViewController(_ sender: UIViewController) {
        self.dismiss(animated: true)
    }
    
    private func preparePlayer() {
        
        
        do {
            player = try AVAudioPlayer(contentsOf: getFileURL(fileName: file))
            player?.delegate = self
            player?.prepareToPlay()
            player?.volume = 1.0
        } catch {
            print("^^^^^^^ smth is wrong\n")
        }
    }

}

extension RecorderViewController: AVAudioPlayerDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playRecordButton.isEnabled = true
        changeButtonState(button: playRecordButton)
    }
}

extension RecorderViewController: AVAudioRecorderDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordStartButton.isEnabled = true
        changeButtonState(button: recordStartButton)
        playRecordButton.setTitle("PLAY", for: .normal)
    }
}
