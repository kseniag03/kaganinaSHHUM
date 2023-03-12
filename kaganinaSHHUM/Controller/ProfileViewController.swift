//
//  ProfileViewController.swift
//  kaganinaSHHUM
//

import UIKit

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
    }

    private func setupView() {
        self.view.backgroundColor = .systemGreen
    }
    
    private func setupNavBar() {
        self.title = "PROFILE"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign Out",
            style: .done,
            target: self,
            action: #selector(didTapSignOut)
        )
    }
    
    @objc
    private func didTapSignOut() {
        
    }
}
