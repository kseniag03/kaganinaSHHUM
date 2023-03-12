//
//  RecorderViewController.swift
//  kaganinaSHHUM
//

import AVFoundation
import Foundation
import UIKit

final class RecorderViewController: UIViewController {
    
    var recordingSession: AVAudioSession?
    var recorder: AVAudioRecorder?
    
    var numberOfRecords: Int = 0
    
    let numberStoreKey = "numberOfRecordsKey"
    let file = "record.m4a"
    
    var recordStartButton = UIButton()
    var recordStopButton = UIButton()
    
    let recordStoreController = RecordStoreViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        
        UserDefaults.standard.set(numberOfRecords, forKey: numberStoreKey)
        
        setupView()
        setupNavBar()
        
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
        
        setupRecorder()
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
        
        recordStopButton.isEnabled = false
        changeButtonState(button: recordStopButton)
        
        let buttonsSV = UIStackView(arrangedSubviews: [
            recordStartButton, recordStopButton
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
         navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "List",
            image: UIImage(systemName: "music.note.list"),
            target: self,
            action: #selector(navBarButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    @objc
    private func navBarButtonPressed(_ sender: UIButton) {
        recordStoreController.view.backgroundColor = .systemPurple
        navigationController?.pushViewController(recordStoreController, animated: true)
    }
    
    @objc
    private func dismissViewController(_ sender: UIViewController) {
        self.dismiss(animated: true)
    }
}

extension RecorderViewController {
    
    private func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
/*
    private func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return paths[0]
    }
    
    private func getFileURL(fileName: String) -> URL {
        let path = (getCacheDirectory() as NSString).appendingPathComponent(fileName)
        let filePath = URL(fileURLWithPath: path)
        return filePath
    }
  */
    
    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
        }
        
    }
    
    @objc
    private func startRecording() {
        self.view.backgroundColor = .systemTeal
        
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
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        print("FINISH RECORDING!!!!!!!!")
        
        numberOfRecords += 1
        
        let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a", conformingTo: .url)
        print(fileName)
        recordStoreController.newRecordAdded(record: Record(recordURL: fileName))
    }
}

// возможность сохранять аудио
// хранить записанные аудио не в кэше
// синхронизация с облаком

