//
//  RecorderViewController.swift
//  kaganinaSHHUM
//

import AVFoundation
import Foundation
import UIKit

final class RecorderViewController: UIViewController {
    
    private var dataSource: [Record] = []
    
    private var currentRecordId: String?
    private var currentRecordURL: String?
    
    private var recordingSession: AVAudioSession?
    private var recorder: AVAudioRecorder?
    
    private var recordStartButton = UIButton()
    private var recordStopButton = UIButton()
    
    private let recordStoreController = RecordStoreViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        
        setupView()
        setupNavBar()
        
        recordingSession = AVAudioSession.sharedInstance()
        
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

        recordStartButton = Style.shared.makeMenuButton(title: "START")
        recordStartButton.addTarget(
            self,
            action: #selector(startRecording),
            for: .touchUpInside
        )
        
        recordStopButton = Style.shared.makeMenuButton(title: "STOP")
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
        buttonsSV.pinLeft(to: self.view, self.view.frame.size.width / 10)
        buttonsSV.pinRight(to: self.view, self.view.frame.size.width / 10)
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
    
    private func setupRecordURL() {
        
        print("setup record url")
        
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        
        let newRecordId = UUID().uuidString
        
        StorageManager.shared.downloadURLForRecord(email: email, recordId: newRecordId) { url in
            guard let recordURL = url else { return }

            let record = Record(
                id: newRecordId,
                timestamp: Date().timeIntervalSince1970,
                recordURL: recordURL
            )

            DatabaseManager.shared.insert(record: record, email: email) { [weak self] recorded in
                guard recorded else { return }
                DispatchQueue.main.async {
                    self?.currentRecordId = newRecordId
                    self?.currentRecordURL = recordURL.absoluteString
                }
            }
        }
    }
    
    private func setupRecorder() {
        
        print("setup recorder 1")
        
        if recorder == nil {
            
            print("setup record url 1.1")
            
            DispatchQueue.main.async {
                let recordSettings = [
                    AVFormatIDKey: kAudioFormatAppleLossless,
                    AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                    AVEncoderBitRateKey: 320000,
                    AVNumberOfChannelsKey: 2,
                    AVSampleRateKey: 44100.0
                ] as [String : Any]
                
                
                do {
                    guard let url = URL(string: self.currentRecordURL ?? "") else { return }
                    self.recorder = try AVAudioRecorder(url: url, settings: recordSettings as [String : Any])
                    self.recorder?.delegate = self
                    self.recorder?.prepareToRecord()
                } catch {
                    self.displayAlert(title: "ERROR", message: "Recording has failed")
                    print("!!!!!! smth is wrong\n")
                }
            }
        } else {
            print("setup record url 1.2")
            
            self.recorder?.stop()
            self.recorder = nil
        }
            
            
            
          
    }
    
    @objc
    private func startRecording() {
        self.view.backgroundColor = .systemTeal
        
        if recorder == nil {
            setupRecordURL()
            setupRecorder()
        }
        
        if recordStartButton.titleLabel?.text == "START" {
            
            
            
            DispatchQueue.main.async {
                
                print("start recording")
                
                self.recordStopButton.isEnabled = true
                self.changeButtonState(button: self.recordStopButton)
                
                self.recorder?.record()
                self.recordStartButton.setTitle("PAUSE", for: .normal)
            }
            
            
            
        } else {
            
            
            
            DispatchQueue.main.async {
                
                print("pause recording")
                
                self.recordStopButton.isEnabled = true
                self.changeButtonState(button: self.recordStopButton)
                
                self.recorder?.pause()
                self.recordStartButton.setTitle("START", for: .normal)
            }
            
        }
        
    }
    
    @objc
    private func stopRecording() {
        self.view.backgroundColor = .systemPink
        
        DispatchQueue.main.async {
            
            print("stop recording")
            
            self.recordStopButton.isEnabled = false
            self.changeButtonState(button: self.recordStopButton)
            
            self.recorder?.stop()
            
            print("FINISH RECORDING!!!!!!!!")
            
            guard let id = self.currentRecordId,
                  let url = URL(string: self.currentRecordURL ?? "")
            else { print("nil"); return }
            
            print("current id: \(id)")
            print("current url: \(url)")
            
            self.recordStoreController.newRecordAdded(record: Record(id: id, timestamp: Date().timeIntervalSince1970, recordURL: url))
            
            
            self.recordStartButton.setTitle("START", for: .normal)
        }
        
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        stopRecording()
        
    }
    
    func audioRecorder(_ recorder: AVAudioRecorder, didFinishRecording successfully: Bool) {
        if successfully {
            do {
                //let audioData = try Data(contentsOf: recorder.url)
                // Use the audioData as needed.
                
                guard let email = UserDefaults.standard.string(forKey: "email") else { return }
                
                
                StorageManager.shared.uploadUserRecord(email: email, record: recorder.url) { success in
                    guard success else { return }
                    
                    guard let id = self.currentRecordId else { return }
                    
                    StorageManager.shared.downloadURLForRecord(email: email, recordId: id) { url in
                        
                        guard let recordURL = url else { return }

                        let record = Record(
                            id: id,
                            timestamp: Date().timeIntervalSince1970,
                            recordURL: recordURL
                        )

                        DatabaseManager.shared.insert(record: record, email: email) { [weak self] saved in
                            guard saved else { return }
                            DispatchQueue.main.async {
                                self?.dataSource.append(record)
                            }
                        }
                    }
                }
            } catch {
                print("Error loading audio data: \(error)")
            }
        } else {
            print("Recording was not successful.")
        }
    }

}

// возможность сохранять аудио
// загрузка аудио с устройства
// хранить записанные аудио не в кэше
// синхронизация с облаком
// публикация поста с аудио

