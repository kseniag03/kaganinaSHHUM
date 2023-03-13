//
//  RecordPlayViewController.swift
//  kaganinaSHHUM
//

import AVFoundation
import Foundation
import UIKit

protocol SetFileName {
    func setFileName(record: Record)
}

extension RecordPlayViewController: SetFileName {
    
    private func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func setFileName(record: Record) {
        fileName = record.recordURL
    }
}

final class RecordPlayViewController: UIViewController {
    
    private var player: AVAudioPlayer?
    
    private var recordPlayButton = UIButton()
    private var recordStopPlayButton = UIButton()
    
    private var fileName: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .link
        setupView()
        setupNavBar()
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
   */
    private func changeButtonState(button: UIButton) {
        if !button.isEnabled {
            button.setImage(UIImage(named: "play.fill"), for: .normal)
        } else {
            button.setImage(UIImage(named: "pause.fill"), for: .normal)
        }
    }
    
    private func setupView() {

        recordPlayButton.makeMenuButton(to: recordPlayButton, title: "PLAY")
        recordPlayButton.setImage(UIImage(named: "play.fill"), for: .normal)
        recordPlayButton.addTarget(
            self,
            action: #selector(playRecord),
            for: .touchUpInside
        )
        
        recordStopPlayButton.makeMenuButton(to: recordStopPlayButton, title: "STOP PLAY")
        recordStopPlayButton.setImage(UIImage(named: "stop.fill"), for: .normal)
        recordStopPlayButton.addTarget(
            self,
            action: #selector(stopPlayRecord),
            for: .touchUpInside
        )
        
        let buttonsSV = UIStackView(arrangedSubviews: [
            recordPlayButton, recordStopPlayButton
        ])
        buttonsSV.spacing = 12
        buttonsSV.axis = .horizontal
        buttonsSV.distribution = .fillEqually

        self.view.addSubview(buttonsSV)
        buttonsSV.pinLeft(to: self.view, self.view.frame.width / 10)
        buttonsSV.pinRight(to: self.view, self.view.frame.width / 10)
        buttonsSV.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor)
        //buttonsSV.pinHeight(to: self.view.safeAreaLayoutGuide.heightAnchor)
    }
    
    private func setupNavBar() {
        self.title = "RECORD PLAY"
    }
}


extension RecordPlayViewController: AVAudioPlayerDelegate {
    
    private func preparePlayer() {
        do {
            print("!!!")
            guard let fileName = self.fileName else { return }
            print(fileName)
            print("!!!")
            player = try AVAudioPlayer(contentsOf: fileName)
            player?.delegate = self
            player?.prepareToPlay()
            player?.volume = 1.0
        } catch {
            print("^^^^^^^ smth is wrong\n")
        }
    }
    
    @objc
    private func playRecord() {
        recordStopPlayButton.isEnabled = true
        if let player = self.player {
            if player.isPlaying {
                player.pause()
                recordPlayButton.setImage(UIImage(named: "play.fill"), for: .normal)
            } else {
                player.play()
                recordPlayButton.setImage(UIImage(named: "pause.fill"), for: .normal)
            }
        } else {
            preparePlayer()
            player?.play()
            recordPlayButton.setImage(UIImage(named: "pause.fill"), for: .normal)
        }
    }
    
    @objc
    private func stopPlayRecord() {
        player?.stop()
        recordPlayButton.setImage(UIImage(named: "play.fill"), for: .normal)
        recordStopPlayButton.isEnabled = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordPlayButton.setImage(UIImage(named: "play.fill"), for: .normal)
        recordStopPlayButton.isEnabled = false
    }
}
