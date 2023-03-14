//
//  SignInViewController.swift
//  kaganinaSHHUM
//

import Foundation
import UIKit

final class SignInViewController: UITabBarController {
    
    private let headerView = SignInHeaderView()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.keyboardType = .emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Email Address"
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupView() {
        title = "Sign In"
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(createAccountButton)
        
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(createAccountButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(headerView)
        headerView.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor)
        headerView.pinLeft(to: self.view, self.view.frame.size.width / 10)
        headerView.pinRight(to: self.view, self.view.frame.size.width / 10)
        
        emailField.pinTop(to: headerView, self.view.frame.size.height / 10)
        emailField.pinLeft(to: self.view, self.view.frame.size.width / 10)
        emailField.pinRight(to: self.view, self.view.frame.size.width / 10)
        
        passwordField.pinTop(to: emailField, self.view.frame.size.height / 10)
        passwordField.pinLeft(to: self.view, self.view.frame.size.width / 10)
        passwordField.pinRight(to: self.view, self.view.frame.size.width / 10)
        
        signInButton.pinTop(to: passwordField, self.view.frame.size.height / 10)
        signInButton.pinLeft(to: self.view, self.view.frame.size.width / 10)
        signInButton.pinRight(to: self.view, self.view.frame.size.width / 10)
        
        createAccountButton.pinTop(to: signInButton, self.view.frame.size.height / 10)
        createAccountButton.pinLeft(to: self.view, self.view.frame.size.width / 10)
        createAccountButton.pinRight(to: self.view, self.view.frame.size.width / 10)        
    }
    
    @objc
    private func signInButtonPressed() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty
        else { return }
        
        AuthManager.shared.signIn(email: email, password: password, completion: { [weak self] success in
            guard success else { return }
            UserDefaults.standard.set(email, forKey: "email")
            DispatchQueue.main.async {
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
        })
    }
    
    @objc
    private func createAccountButtonPressed() {
        let signUpController = SignUpViewController()
        signUpController.title = "Create Account"
        signUpController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(signUpController, animated: true)
    }
}
