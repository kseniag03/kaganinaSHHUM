//
//  ProfileViewController.swift
//  kaganinaSHHUM
//

import UIKit

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "post title will be there..."
        return cell
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc
    private func profilePhotoTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        StorageManager.shared.uploadUserProfilePicture(email: currentEmail, image: image) { success in
            
        }
    }
    
}

final class ProfileViewController: UIViewController {
    
    // also list of  posts
    
    private let currentEmail: String
    
    private var user: User?
    
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupTableViewHeader()
        setupNavBar()
    }

    private func setupView() {
        self.view.backgroundColor = .systemGreen
        title = "Profile"//currentEmail
    }
    
    private func setupTableViewHeader(profilePhotoRef: String? = nil, name: String? = nil) {
        let headerView = UIView(
            frame:
                CGRect(
                    x: 0,
                    y: 0,
                    width: view.frame.width / 2,
                    height: view.frame.width / 2
                )
        )
        headerView.backgroundColor = .systemPink
        headerView.isUserInteractionEnabled = true
        headerView.clipsToBounds = true
        
        tableView.tableHeaderView = headerView
        
        let profilePhoto = UIImageView(image: UIImage(systemName: "person"))
        profilePhoto.tintColor = .white
        profilePhoto.contentMode = .scaleAspectFit
        profilePhoto.frame = CGRect(
            x: (view.frame.width - (view.frame.width / 4)) / 2,
            y: (headerView.frame.height - (view.frame.width / 4)) / 2,
            width: view.frame.width / 4,
            height: view.frame.width / 4
        )
        profilePhoto.isUserInteractionEnabled = true
        headerView.addSubview(profilePhoto)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profilePhotoTapped))
        profilePhoto.addGestureRecognizer(tap)
        
        let emailLabel = UILabel(
            frame:
                CGRect(
                    x: 20,
                    y: profilePhoto.frame.maxY + 10,
                    width: view.frame.width - 40,
                    height: 100
                )
        )
        headerView.addSubview(emailLabel)
        emailLabel.text = currentEmail
        emailLabel.textAlignment = .center
        emailLabel.textColor = .white
        emailLabel.font = .systemFont(ofSize: 25, weight: .bold)
        
        if let name = name {
            title = name
        }
        if let ref = profilePhotoRef {
            // fetch image
            //fetchProfileData()
        }
    }
    
    private func fetchProfileData() {
        DatabaseManager.shared.getUser(for: currentEmail) { [weak self] user in
            guard let user = user else { return }
            self?.user = user
            DispatchQueue.main.async {
                self?.setupTableViewHeader(profilePhotoRef: user.profilePhotoRef, name: user.name)
            }
            
        }
    }
    
    private func setupTableView() {
        
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
                
        self.view.addSubview(tableView)
        tableView.pinTop(to: self.view.topAnchor)
        tableView.pinLeft(to: self.view, self.view.frame.width / 10)
        tableView.pinRight(to: self.view, self.view.frame.width / 10)
        tableView.pinHeight(to: self.view.safeAreaLayoutGuide.heightAnchor)
        
        tableView.reloadData()
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign Out",
            style: .done,
            target: self,
            action: #selector(didTapSignOut)
        )
    }
    
    /// Sign Out
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
