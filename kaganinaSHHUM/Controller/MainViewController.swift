//
//  MainViewController.swift
//  kaganinaSHHUM
//


import Foundation
import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
        let viewModel = PostPreviewTableViewCellViewModel(title: post.title, imageURL: post.headerImageURL)
        cell.configure(with: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = PostViewController(
            post: posts[indexPath.row]
        )
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

final class MainViewController: UIViewController {
    
    private var posts: [Post] = []
    
    private func fetchAllPosts() {
        print("Fetching feed...")
        DatabaseManager.shared.getAllPosts { [weak self] posts in
            self?.posts = posts
            print("Found \(posts.count) posts")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        return tableView
    }()
    
    
    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        
        button.setImage(UIImage(
            systemName: "square.and.pencil.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 32,
                weight: .medium
            )
        ), for: .normal)
        
        button.layer.cornerRadius = 40
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("!!!!!!!!!!   home did load   !!!!!!!!!")
        
        setupView()
        setupNavBar()
    }
    
    override func viewDidAppear(_ animeted: Bool) {
        super.viewDidAppear(animeted)
        fetchAllPosts()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(composeButton)
        
        composeButton.addTarget(self, action: #selector(composeButtonPressed), for: .touchUpInside)
        
        composeButton.frame = CGRect(
            x: view.frame.size.width - 80,
            y: view.frame.size.height - 160 - view.safeAreaInsets.bottom,
            width: 50,
            height: 50)

        tableView.frame = view.bounds
    }
    
    private func setupNavBar() {
        navigationItem.title = "Home"
    }
    
    @objc
    private func composeButtonPressed() {
        let vc = CreateNewPostViewController()
        vc.title = "Публикация"
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
        
    }
}
