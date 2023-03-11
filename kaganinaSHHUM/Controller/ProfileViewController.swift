//
//  ProfileViewController.swift
//  kaganinaSHHUM
//

import UIKit

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        //setupView()
        //setupNavBar()
    }
    /*
    private func setupView() {
        self.view.backgroundColor = .red
    }
    
    private func setupNavBar() {
        self.title = "PROFILE"
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
