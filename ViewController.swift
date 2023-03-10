//
//  ViewController.swift
//  kaganinaSHHUM
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemMint//.systemGray6
        setupButtons()
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
    
    func setupButtons() {
        let searchMenuButton = makeMenuButton(title: "SEARCH")
        searchMenuButton.addTarget(
            self,
            action: #selector(openSearchController),
            for: .touchUpInside
        )
        
        let recorderMenuButton = makeMenuButton(title: "RECORDER")
        recorderMenuButton.addTarget(
            self,
            action: #selector(openRecordController),
            for: .touchUpInside
        )
        
        let profileMenuButton = makeMenuButton(title: "PROFILE")
        profileMenuButton.addTarget(
            self,
            action: #selector(openProfileController),
            for: .touchUpInside
        )
        
        let buttonsSV = UIStackView(arrangedSubviews: [
            searchMenuButton,
            recorderMenuButton,
            profileMenuButton
        ])
        buttonsSV.spacing = 12
        buttonsSV.axis = .horizontal
        buttonsSV.distribution = .fillEqually

        self.view.addSubview(buttonsSV)
        buttonsSV.pinBottom(to: self.view.bottomAnchor, self.view.frame.height / 10)
        buttonsSV.pinLeft(to: self.view, self.view.frame.width / 10)
        buttonsSV.pinRight(to: self.view, self.view.frame.width / 10)
        //buttonsSV.pinHeight(to: self.view.heightAnchor)
        buttonsSV.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    @objc
    func openSearchController() {
        let searchController = SearchViewController()
        //searchController.view.backgroundColor = view.backgroundColor ?? .systemBackground
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    @objc
    func openRecordController() {
        let recordController = RecorderViewController()
        //recordController.view.backgroundColor = view.backgroundColor ?? .systemBackground
        navigationController?.pushViewController(recordController, animated: true)
    }
    
    @objc
    func openProfileController() {
        let profileController = ProfileViewController()
        //profileController.view.backgroundColor = view.backgroundColor ?? .systemBackground
        navigationController?.pushViewController(profileController, animated: true)
    }
    
}
