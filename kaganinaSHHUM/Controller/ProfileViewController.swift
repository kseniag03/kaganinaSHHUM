//
//  ProfileViewController.swift
//  kaganinaSHHUM
//

import UIKit

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title, imageURL: post.headerImageURL))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        HapticsManager.shared.vibrateForSelection()

        var isOwnedByCurrentUser = false
        if let email = UserDefaults.standard.string(forKey: "email") {
            isOwnedByCurrentUser = email == currentEmail
        }

        if !isOwnedByCurrentUser {
            let vc = PostViewController(
                post: posts[indexPath.row],
                isOwnedByCurrentUser: isOwnedByCurrentUser
            )
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = "Post"
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            // Our post
            let vc = PostViewController(
                post: posts[indexPath.row],
                isOwnedByCurrentUser: isOwnedByCurrentUser
            )
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = "Post"
            navigationController?.pushViewController(vc, animated: true)

        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc
    private func profilePhotoTapped() {
        
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
              myEmail == currentEmail
        else { return }
        
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
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        StorageManager.shared.uploadUserProfilePhoto(email: currentEmail, image: image) {
            [weak self] success in
            guard let strong = self else { return }
            if success {
                // database update
                DatabaseManager.shared.updateUserProfilePhoto(email: strong.currentEmail) { success in
                    guard success else { return }
                    DispatchQueue.main.async {
                        strong.fetchProfileData()
                    }
                }
            }
        }
    }
    
}

final class ProfileViewController: UIViewController {
    
    // also list of  posts
    
    private let currentEmail: String
    
    private var user: User?
    
    private var posts: [Post] = []
    
    private func fetchPosts() {
        print("Fetching posts...")
        DatabaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in
            self?.posts = posts
            print("Found \(posts.count) posts")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        setupTableView()
        setupTableViewHeader()
        fetchProfileData()
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
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
                    width: view.frame.size.width / 2,
                    height: view.frame.size.width / 1.5
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
            x: (view.frame.size.width - (view.frame.size.width / 4)) / 2,
            y: (headerView.frame.size.height - (view.frame.size.width / 4)) / 2.5,
            width: view.frame.size.width / 4,
            height: view.frame.size.width / 4
        )
        
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.frame.width / 2
        profilePhoto.isUserInteractionEnabled = true
        
        headerView.addSubview(profilePhoto)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profilePhotoTapped))
        profilePhoto.addGestureRecognizer(tap)
        
        let emailLabel = UILabel(
            frame:
                CGRect(
                    x: 20,
                    y: profilePhoto.frame.origin.y + profilePhoto.frame.size.height + 20,
                    width: view.frame.size.width - 40,
                    height: 100
                )
        )
        
        emailLabel.text = currentEmail
        emailLabel.textAlignment = .center
        emailLabel.textColor = .white
        emailLabel.font = .systemFont(ofSize: 25, weight: .bold)
        headerView.addSubview(emailLabel)
        
        if let name = name {
            title = name
        }
        if let ref = profilePhotoRef {
            // fetch image
            print("found photo ref: \(ref)")
            StorageManager.shared.dowloadURLForProfilePhoto(path: ref) { url in
                guard let url = url else { return }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else { return }
                    
                    DispatchQueue.main.async {
                        profilePhoto.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
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
                
        self.view.addSubview(tableView)/*
        tableView.pinTop(to: self.view.topAnchor)
        tableView.pinLeft(to: self.view, self.view.frame.width / 10)
        tableView.pinRight(to: self.view, self.view.frame.width / 10)
        tableView.pinHeight(to: self.view.safeAreaLayoutGuide.heightAnchor)
        
        tableView.reloadData()*/
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign Out",
            style: .done,
            target: self,
            action: #selector(signOutPressed)
        )
    }
    
    /// Sign Out
    @objc
    private func signOutPressed() {
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
