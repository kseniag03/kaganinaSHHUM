//
//  RecordStoreViewController.swift
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
    
    
    //let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a", conformingTo: .url)
    
    
    public func configure(_ record: Record) {
        let fileName = record.recordURL.deletingPathExtension().lastPathComponent
        print("!!!&&&%%%!!! record cell configure filename" + String(fileName))
        textlabel.text = "Запись_\(fileName)"//"Запись " + String(fileName)
        print("£££ label text = " + (textlabel.text ?? "##NIL") )
    }
}

final class RecordStoreViewController: UIViewController {
    
    var recordsTableView = UITableView(frame: .zero, style: .insetGrouped)
    
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
        recordsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        recordsTableView.register(RecordCell.self, forCellReuseIdentifier: RecordCell.reuseIdentifier)
        recordsTableView.register(AddRecordCell.self, forCellReuseIdentifier: AddRecordCell.reuseIdentifier)
        
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

extension RecordStoreViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 0//1
        default:
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let addNewCell = tableView.dequeueReusableCell(withIdentifier: AddRecordCell.reuseIdentifier, for: indexPath) as? AddRecordCell {
                addNewCell.textLabel?.text = "new " + String(indexPath.row + 1)
                addNewCell.delegate = self
                return addNewCell
            }
        default: // !!!! different cells
            let record = dataSource[indexPath.row]//[dataSource.count - indexPath.row - 1]
            
            print("current indexpath.row = " + String(indexPath.row))
            print("current record.url = " + String(record.recordURL.absoluteString))
            
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
        let record = dataSource[indexPath.row]
        playController.setFileName(record: &record)
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
