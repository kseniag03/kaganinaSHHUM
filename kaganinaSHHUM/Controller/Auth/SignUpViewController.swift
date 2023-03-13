//
//  SignUpViewController.swift
//  kaganinaSHHUM
//

import Foundation
import UIKit

final class SignUpViewController: UITabBarController {
    
    private let headerView = SignInHeaderView()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Full Name"
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
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
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
 /*   private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupView() {
        title = "Create Account"
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
      //  view.addSubview(createAccountButton)
        
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
      //  createAccountButton.addTarget(self, action: #selector(createAccountButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(headerView)
        headerView.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor)
        headerView.pinLeft(to: self.view, self.view.frame.width / 10)
        headerView.pinRight(to: self.view, self.view.frame.width / 10)
        
        nameField.pinTop(to: headerView, self.view.frame.height / 10)
        nameField.pinLeft(to: self.view, self.view.frame.width / 10)
        nameField.pinRight(to: self.view, self.view.frame.width / 10)
        
        emailField.pinTop(to: nameField, self.view.frame.height / 10)
        emailField.pinLeft(to: self.view, self.view.frame.width / 10)
        emailField.pinRight(to: self.view, self.view.frame.width / 10)
       // emailField.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor)
        
        passwordField.pinTop(to: emailField, self.view.frame.height / 10)
        passwordField.pinLeft(to: self.view, self.view.frame.width / 10)
        passwordField.pinRight(to: self.view, self.view.frame.width / 10)
       // passwordField.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor)
        
        signUpButton.pinTop(to: passwordField, self.view.frame.height / 10)
        signUpButton.pinLeft(to: self.view, self.view.frame.width / 10)
        signUpButton.pinRight(to: self.view, self.view.frame.width / 10)
     //   signInButton.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor)
        
    }
    
    @objc
    private func signUpButtonPressed() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let name = nameField.text, !name.isEmpty
        else { return }
        
        AuthManager.shared.signUp(email: email, password: password, completion: { [weak self] success in
            if success {
                // update database
                let newUser = User(name: name, email: email, profilePhotoRef: nil)
                DatabaseManager.shared.insert(user: newUser, completion: { inserted in
                    guard inserted else { return }
                    
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(name, forKey: "name")
                    
                    DispatchQueue.main.async {
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                    
                })
            } else {
                // dialog window (alert)
                print("failed to create an account")
            }
            
        })
    }
    
    
}
