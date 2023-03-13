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
        let sheet = UIAlertController(title: "Sign Out", message: "Do you want to sign out ?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "name")
                        
                        let signInController = SignInViewController()
                        signInController.navigationItem.largeTitleDisplayMode = .always
                        let navVc = UINavigationController(rootViewController: signInController)
                        navVc.navigationBar.prefersLargeTitles = true
                        navVc.modalPresentationStyle = .fullScreen
                        self?.present(navVc, animated: true, completion: nil)
                    }
                }
            }
        }))
        present(sheet, animated: true)
    }
}
