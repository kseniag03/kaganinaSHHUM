//
//  RecorderViewController.swift
//  kaganinaSHHUM
//

import AVFoundation
import Foundation
import UIKit

final class RecorderViewController: UIViewController {
    
    private let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("records.json")
    
    private var dataSource: [Record] {
        get {
            if let data = try? Data(contentsOf: path) {
                if let records = try? JSONDecoder().decode([Record].self, from: data) {
                    return records
                }
            }
            return [Record]()
        }
    }
    
    var recordingSession: AVAudioSession?
    var recorder: AVAudioRecorder?
    
    var numberOfRecords: Int = 0
    
    let numberStoreKey = "numberOfRecordsKey"
    let file = "record.m4a"
    
    var recordStartButton = UIButton()
    var recordStopButton = UIButton()
    
    let recordStoreController = RecordStoreViewController()
    
    private func clearRecordsNumber() {
        UserDefaults.standard.removeObject(forKey: numberStoreKey)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        
        setupView()
        setupNavBar()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        if dataSource.isEmpty {
            clearRecordsNumber()
        }
        if let number: Int = UserDefaults.standard.object(forKey: numberStoreKey) as? Int {
            numberOfRecords = number
        }
        if (numberOfRecords == 0) {
            numberOfRecords += 1
        }
        
        print("!!!!!!!!! number of records got : " + String(numberOfRecords))
        
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
    }*/
    
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

        recordStartButton.makeMenuButton(to: recordStartButton, title: "START")
        recordStartButton.addTarget(
            self,
            action: #selector(startRecording),
            for: .touchUpInside
        )
        
        recordStopButton.makeMenuButton(to: recordStopButton, title: "STOP")
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
    
    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension RecorderViewController: AVAudioRecorderDelegate {
    
    private func setupRecorder() {
        
        if recorder == nil {
            //numberOfRecords += 1
            //UserDefaults.standard.set(numberOfRecords, forKey: numberStoreKey)
            
            let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a", conformingTo: .url)
            
            let recordSettings = [AVFormatIDKey: kAudioFormatAppleLossless,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey: 320000,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey: 44100.0 ] as [String : Any]
            
            do {
                recorder = try AVAudioRecorder(url: fileName, settings: recordSettings as [String : Any])
                recorder?.delegate = self
                recorder?.prepareToRecord()
            } catch {
                displayAlert(title: "ERROR", message: "Recording has failed")
                print("!!!!!! smth is wrong\n")
            }
        } else {
            recorder?.stop()
            recorder = nil
        }
        
    }
    
    @objc
    private func startRecording() {
        self.view.backgroundColor = .systemTeal
        
        if recorder == nil {
            setupRecorder()
        }
        
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
        
        let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a", conformingTo: .url)
        
        numberOfRecords += 1
        UserDefaults.standard.set(numberOfRecords, forKey: numberStoreKey)
        
        print(fileName)
        recordStoreController.newRecordAdded(record: Record(recordURL: fileName))
    }
}

// возможность сохранять аудио
// загрузка аудио с устройства
// хранить записанные аудио не в кэше
// синхронизация с облаком
// публикация поста с аудио

