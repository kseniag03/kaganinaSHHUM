//
//  RecorderViewController.swift
//  kaganinaSHHUM
//

import Foundation
import UIKit
//import AVFAudio
import AVFoundation

final class RecorderViewController: UIViewController {/*
    var recordingSession: AVAudioSession?
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    
    var numberOfRecords: Int = 0
    
    let numberStoreKey = "numberOfRecordsKey"
    let file = "record.m4a"
    
    var recordStartButton = UIButton()
    var recordStopButton = UIButton()
    var playRecordButton = UIButton()
    
    var recordsTableView = UITableView()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        
        //setupView()
        //setupNavBar()
        
        //print("6666")
        /*
        
        recordingSession = AVAudioSession.sharedInstance()
        
        if let number: Int = UserDefaults.standard.object(forKey: numberStoreKey) as? Int {
            numberOfRecords = number
        }
        
        switch recordingSession?.recordPermission {
        case .granted:
            print("granted")
        case .denied:
            print("denied")
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in })
        default:
            print("unknown")
        }
        
        /*
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("ACCEPTED")
            }
        }*/
        
        setupRecorder()*/
    }
    /*
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
    
    private func changeButtonState(button: UIButton) {
        if !button.isEnabled {
            button.backgroundColor = .red
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .white
            button.setTitleColor(.systemGray, for: .normal)
        }
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
        
        recordStopButton.isEnabled = false
        changeButtonState(button: recordStopButton)
        playRecordButton.isEnabled = false
        changeButtonState(button: playRecordButton)
        
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
    
    @objc
    private func dismissViewController(_ sender: UIViewController) {
        self.dismiss(animated: true)
    }*/
}
/*
extension RecorderViewController {
    
    private func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    private func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return paths[0]
    }
    
    private func getFileURL(fileName: String) -> URL {
        let path = (getCacheDirectory() as NSString).appendingPathComponent(fileName)
        let filePath = URL(fileURLWithPath: path)
        return filePath
    }
    
    
    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension RecorderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a", conformingTo: .url)
        
        do {
            player = try AVAudioPlayer(contentsOf: path)
            player?.play()
        } catch {
            
        }
    }
    
    
}

extension RecorderViewController: AVAudioRecorderDelegate {
    
    private func setupRecorder() {
        
        
        if recorder == nil {
            numberOfRecords += 1
            let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a", conformingTo: .url)
            
            let recordSettings = [AVFormatIDKey: kAudioFormatAppleLossless,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey: 320000,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey: 44100.0 ] as [String : Any]
            
            do {
                recorder = try AVAudioRecorder(url: fileName/*getFileURL(fileName: file)*/, settings: recordSettings as [String : Any])
                recorder?.delegate = self
                recorder?.prepareToRecord()
            } catch {
                displayAlert(title: "ERROR", message: "Recording has failed")
                print("!!!!!! smth is wrong\n")
            }
        } else {
            // stop recording
            recorder?.stop()
            recorder = nil
            
            UserDefaults.standard.set(numberOfRecords, forKey: numberStoreKey)
            recordsTableView.reloadData()
            
            recordStartButton.setTitle("Start", for: .normal)
        }
        
        
        
    }
    
    @objc
    private func startRecording() {
        self.view.backgroundColor = .systemTeal
        
        playRecordButton.isEnabled = false
        changeButtonState(button: playRecordButton)
        
        if recordStartButton.titleLabel?.text == "START" {
            recordStopButton.isEnabled = true
            changeButtonState(button: recordStopButton)
            
            recorder?.record()
            recordStartButton.setTitle("PAUSE", for: .normal)
            
        } else {
            recordStopButton.isEnabled = true
            changeButtonState(button: recordStopButton)
            
            recorder?.pause()
            recordStartButton.setTitle("START", for: .normal)
        }
        
    }
    
    @objc
    private func stopRecording() {
        self.view.backgroundColor = .systemPink
        
        recordStopButton.isEnabled = false
        changeButtonState(button: recordStopButton)
        
        recorder?.stop()
        
        recordStartButton.setTitle("START", for: .normal)
        
        playRecordButton.isEnabled = true
        changeButtonState(button: playRecordButton)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playRecordButton.isEnabled = true
        changeButtonState(button: playRecordButton)
    }
}

extension RecorderViewController: AVAudioPlayerDelegate {
    
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
    
    @objc
    private func playRecord() {
        self.view.backgroundColor = .systemGreen
        
        if playRecordButton.titleLabel?.text == "PLAY" {
            
            recordStartButton.isEnabled = false
            changeButtonState(button: recordStartButton)
            
            recordStopButton.isEnabled = false
            changeButtonState(button: recordStopButton)
            
            playRecordButton.setTitle("STOP PLAY", for: .normal)
            
            preparePlayer()
            player?.play()
            
        } else {
            player?.stop()
            recordStartButton.isEnabled = true
            changeButtonState(button: recordStartButton)
            playRecordButton.setTitle("PLAY", for: .normal)
        }
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordStartButton.isEnabled = true
        changeButtonState(button: recordStartButton)
        playRecordButton.setTitle("PLAY", for: .normal)
    }
}
*/
// возможность сохранять аудио
// возможность записать несколько аудио
// хранить записанные аудио не в кэше
// синхронизация с облаком
