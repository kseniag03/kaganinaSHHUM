//
//  RecordStoreViewController.swift
//  kaganinaSHHUM
//

import AVFoundation
import Foundation
import UIKit

protocol AddRecordDelegate {
    func newRecordAdded(record: Record)
}

final class RecordStoreViewController: UIViewController {
    
    var recordsTableView = UITableView(frame: .zero, style: .insetGrouped)
       
    private var dataSource: [Record] = []
    
    private func fetchRecords() {
        print("Fetching records...")
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        DatabaseManager.shared.getRecords(for: email) { [weak self] records in
            self?.dataSource = records
            print("Found \(records.count) records")
            DispatchQueue.main.async {
                self?.recordsTableView.reloadData()
            }
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
    
    override func viewDidAppear(_ animeted: Bool) {
        super.viewDidAppear(animeted)
        fetchRecords()
    }
     
    private func setupView() {
        setupTableView()
        setupNavBar()
    }
    
    private func setupTableView() {
        recordsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        recordsTableView.register(RecordCell.self, forCellReuseIdentifier: RecordCell.identifier)

        recordsTableView.backgroundColor = .clear
        recordsTableView.keyboardDismissMode = .onDrag
        recordsTableView.dataSource = self
        recordsTableView.delegate = self
                
        self.view.addSubview(recordsTableView)
        recordsTableView.pinTop(to: self.view.topAnchor)
        recordsTableView.pinLeft(to: self.view, self.view.frame.size.width / 10)
        recordsTableView.pinRight(to: self.view, self.view.frame.size.width / 10)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = dataSource[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordCell.identifier, for: indexPath) as? RecordCell
        else {
            fatalError()
        }
        cell.configure(record)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playController = RecordPlayViewController()
        let record = dataSource[indexPath.row]
        playController.setFileName(record: record)
        navigationController?.pushViewController(playController, animated: true)
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
}

extension RecordStoreViewController: AddRecordDelegate {
    func newRecordAdded(record: Record) {
        dataSource.insert(record, at: 0)
        recordsTableView.reloadData()
        print("successfully added")
    }
}
