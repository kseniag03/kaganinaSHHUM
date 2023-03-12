//
//  RecorderViewController.swift
//  kaganinaSHHUM
//

import AVFoundation
import Foundation
import UIKit

struct Record: Codable, Equatable {
    var recordURL: URL
}

protocol AddRecordDelegate {
    func newRecordAdded(record: Record)
}

final class AddRecordCell: UITableViewCell {
    
    static let reuseIdentifier = "AddRecordCell"
    
    public var delegate: AddRecordDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PlayRecordDelegate {
    func playRecord(record: Record, player: inout AVAudioPlayer?)
}

final class PlayRecordCell: UITableViewCell {
    
    static let reuseIdentifier = "PlayRecordCell"
    
    public var delegate: PlayRecordDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class RecordCell: UITableViewCell {
    
    static let reuseIdentifier = "RecordCell"
    
    private var textlabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupView() {
        contentView.backgroundColor = .systemBackground
        
        textlabel.font = .systemFont(ofSize: 16, weight: .regular)
        textlabel.textColor = .label
        textlabel.numberOfLines = 0
        textlabel.backgroundColor = .clear
        
        contentView.addSubview(textlabel)
        textlabel.pinTop(to: contentView.safeAreaLayoutGuide.topAnchor)
        textlabel.pinLeft(to: contentView, 16)
        textlabel.pinRight(to: contentView, 16)
        textlabel.pinHeight(to: contentView.safeAreaLayoutGuide.heightAnchor)
    }
    
    public func configure(_ record: Record) {
        let fileName = record.recordURL.deletingPathExtension().lastPathComponent
        print("!!!&&&%%%!!!")
        print(fileName)
        textlabel.text = "Запись " + fileName
    }
}

final class RecordStoreViewController: UIViewController {
    
    var recordsTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // file for current simulation (different list of notes for different devices)
    private let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("records.json")
    
    private var dataSource: [Record] {
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                do {
                    let records = String(data: data, encoding: .utf8)
                    try records?.write(to: path, atomically: false, encoding: .utf8)
                } catch {
                    print("Could not save new data")
                }
            }
        }
        get {
            if let data = try? Data(contentsOf: path) {
                if let records = try? JSONDecoder().decode([Record].self, from: data) {
                    return records
                }
            }
            return [Record]()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        
        print(dataSource.count)
        print(recordsTableView.contentSize)
    }
     
    private func setupView() {
        setupTableView()
        setupNavBar()
    }
    
    private func setupTableView() {
        recordsTableView.register(RecordCell.self, forCellReuseIdentifier: RecordCell.reuseIdentifier)
        recordsTableView.register(AddRecordCell.self, forCellReuseIdentifier: AddRecordCell.reuseIdentifier)
        recordsTableView.register(PlayRecordCell.self, forCellReuseIdentifier: PlayRecordCell.reuseIdentifier)
        self.view.addSubview(recordsTableView)
        recordsTableView.backgroundColor = .clear
        recordsTableView.keyboardDismissMode = .onDrag
        recordsTableView.dataSource = self
        recordsTableView.delegate = self
                
        self.view.addSubview(self.recordsTableView)
        recordsTableView.pinTop(to: self.view.topAnchor)
        recordsTableView.pinLeft(to: self.view, self.view.frame.width / 10)
        recordsTableView.pinRight(to: self.view, self.view.frame.width / 10)
        recordsTableView.pinHeight(to: self.view.safeAreaLayoutGuide.heightAnchor)
        
        recordsTableView.reloadData()
    }
    
    private func setupNavBar() {
        self.title = "RECORD LIST"
    }
    
    private func handleDelete(indexPath: IndexPath) {
        dataSource.remove(at: indexPath.row)
        recordsTableView.reloadData()
    }
}
/*
extension RecordStoreViewController: UITableViewDelegate, UITableViewDataSource {
    
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
} */

extension RecordStoreViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0:
            return 1
        default:
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print()
        print(indexPath)
        print(dataSource.count)
        print(recordsTableView.contentSize)
        print()
        
        switch indexPath.section {
        case 0:
            if let addNewCell = tableView.dequeueReusableCell(withIdentifier: AddRecordCell.reuseIdentifier, for: indexPath) as? AddRecordCell {
                
                addNewCell.textLabel?.text = String(indexPath.row + 1)
                addNewCell.delegate = self
                return addNewCell
            }
        default:
            let record = dataSource[indexPath.row]
            if let recordCell = tableView.dequeueReusableCell(withIdentifier: RecordCell.reuseIdentifier, for: indexPath) as? RecordCell {
                recordCell.configure(record)
                return recordCell
            }
        }
        
        return UITableViewCell()
    }
}

extension RecordStoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: .none
        ) {
            [weak self] (action, view, completion) in
            self?.handleDelete(indexPath: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(
            systemName: "trash.fill",
            withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
        )?.withTintColor(.white)
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playController = RecordPlayViewController()
        playController.setFileName(number: indexPath.row + 1)
        navigationController?.pushViewController(playController, animated: true)
    }
}

extension RecordStoreViewController: AddRecordDelegate {
    func newRecordAdded(record: Record) {
        dataSource.insert(record, at: 0)
        recordsTableView.reloadData()
        print("successfully added")
    }
}

extension RecordStoreViewController: PlayRecordDelegate {
    func playRecord(record: Record, player: inout AVAudioPlayer?) {
        if let index = dataSource.firstIndex(where: { $0 == record }) {
            // `index` now contains the index of the object in the data source
            print("Found object at index \(index)")
            
            do {
                player = try AVAudioPlayer(contentsOf: record.recordURL)
                player?.play()
            } catch {
                
            }
            
        } else {
            // The object wasn't found in the data source
            print("Object not found")
        }
        
    }
}


//-----------------------------------------------

final class RecorderViewController: UIViewController {
    
    var recordingSession: AVAudioSession?
    var recorder: AVAudioRecorder?
//    var player: AVAudioPlayer?
    
    var numberOfRecords: Int = 0
    
    let numberStoreKey = "numberOfRecordsKey"
    let file = "record.m4a"
    
    var recordStartButton = UIButton()
    var recordStopButton = UIButton()
    var playRecordButton = UIButton()
    
    let recordStoreController = RecordStoreViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        setupView()
        setupNavBar()
        
        //print("6666")
        
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
        
        playRecordButton = makeMenuButton(title: "PLAY")
        /*playRecordButton.addTarget(
            self,
            action: #selector(playRecord),
            for: .touchUpInside
        )*/
        
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
         navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "List",
            image: UIImage(systemName: "arrow.clockwise"),
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
            
            UserDefaults.standard.set(numberOfRecords, forKey: numberStoreKey)
            //recordsTableView.reloadData()
            
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
        
        print("FINISH RECORDING!!!!!!!!")
        let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a", conformingTo: .url)
        print(fileName)
        recordStoreController.newRecordAdded(record: Record(recordURL: fileName))
    }
}
/*
extension RecorderViewController: AVAudioPlayerDelegate {
    
    private func preparePlayer() {
        do {
            let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a", conformingTo: .url)
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

protocol SetFileName {
    func setFileName(number: Int)
}

extension RecordPlayViewController: SetFileName {
    
    private func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func setFileName(number: Int) {
        fileName = getDirectory().appendingPathComponent("\(number).m4a", conformingTo: .url)
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
            button.setImage(UIImage(named: "play.fill"), for: .normal)
        } else {
            button.setImage(UIImage(named: "pause.fill"), for: .normal)
        }
    }
    
    private func setupView() {

        recordPlayButton = makeMenuButton(title: "")
        recordPlayButton.setImage(UIImage(named: "play.fill"), for: .normal)
        recordPlayButton.addTarget(
            self,
            action: #selector(playRecord),
            for: .touchUpInside
        )
        
        recordStopPlayButton = makeMenuButton(title: "")
        recordStopPlayButton.setImage(UIImage(named: "stop.fill"), for: .normal)
        recordStopPlayButton.addTarget(
            self,
            action: #selector(stopPlayRecord),
            for: .touchUpInside
        )
        /*
        self.view.addSubview(recordPlayButton)
        recordPlayButton.pinLeft(to: self.view, self.view.frame.size.width / 10)
        recordPlayButton.pinRight(to: self.view, self.view.frame.size.width / 10)
        recordPlayButton.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor)*/
        
        
        let buttonsSV = UIStackView(arrangedSubviews: [
            recordPlayButton, recordStopPlayButton
        ])
        buttonsSV.spacing = 12
        buttonsSV.axis = .horizontal
        buttonsSV.distribution = .fillEqually

        self.view.addSubview(buttonsSV)
        buttonsSV.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor)
        buttonsSV.pinLeft(to: self.view, self.view.frame.width / 10)
        buttonsSV.pinRight(to: self.view, self.view.frame.width / 10)
        buttonsSV.pinHeight(to: self.view.safeAreaLayoutGuide.heightAnchor)
    }
    
    private func setupNavBar() {
        self.title = "RECORD PLAY"
    }
}


extension RecordPlayViewController: AVAudioPlayerDelegate {
    
    private func preparePlayer() {
        do {
            guard let fileName = self.fileName else { return }
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
