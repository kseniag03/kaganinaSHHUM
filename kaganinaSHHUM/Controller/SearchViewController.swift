//
//  SearchViewController.swift
//  kaganinaSHHUM
//

import UIKit

final class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
    }
    
    private func setupView() {
        self.view.backgroundColor = .yellow
    }
    
    private func setupNavBar() {
        self.title = "SEARCH"
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
    }
}
