//
//  MainViewController.swift
//  kaganinaSHHUM
//


import Foundation
import UIKit

/*

final class NewsListViewController: UIViewController {
    private var fetchButton = UIButton()
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var isLoading = false
    private var newsViewModels = [NewsViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupFetchButton()
        configureTableView()
    }
    
    private func configureTableView() {
        setTableViewUI()
        setTableViewDelegate()
        setTableViewCell()
    }
    
    private func setupFetchButton() {
         navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(fetchButtonPressed)
         )
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        fetchButton.configuration = createFetchButtonConfig()
        fetchButton.alpha = 0.75
        
        view.addSubview(fetchButton)
        fetchButton.pinLeft(to: view, 16)
        fetchButton.pinRight(to: view, 16)
        fetchButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        
        fetchButton.addTarget(self, action: #selector(fetchButtonPressed(_:)), for: .touchUpInside)
    }
    
    func createFetchButtonConfig() -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        config.background.backgroundColor = .label
        config.baseBackgroundColor = .label
        config.baseForegroundColor = .systemBackground
        config.title = "Fetch new articles"
        config.attributedTitle?.font = .systemFont(ofSize: 16, weight: .medium)
        config.buttonSize = .medium
        config.background.cornerRadius = 12
        return config
    }

    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setTableViewUI() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
        view.addSubview(tableView)
        tableView.rowHeight = view.frame.size.height / 10
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinLeft(to: view)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view, view.frame.size.height / 10)
    }
    
    private func setTableViewCell() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    }

    private func fetchNews() {
        ApiService.shared.getTopStories {
            [weak self] result in switch result {
            case .success(let articles):
                for i in articles.articles {
                    self?.newsViewModels.append(NewsViewModel(
                        title: i.title,
                        description: i.description,
                        imageURL: URL(string: i.urlToImage ?? "")
                    ))
                }
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc
    private func fetchButtonPressed(_ sender: UIButton) {
        fetchNews()
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading { }
        else {
            return newsViewModels.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {}
        else {
            let viewModel = newsViewModels[indexPath.row]
            if let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier,
                                                            for: indexPath) as? NewsCell {
                newsCell.configure(with: viewModel)
                return newsCell
            }
        }
        return UITableViewCell()
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = NewsViewController()
            newsVC.configure(with: newsViewModels[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}


*/

/// _________________________________



import Foundation
import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // if isLoading {}
      //  else {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
        let viewModel = PostPreviewTableViewCellViewModel(title: post.title, imageURL: post.headerImageURL)
        cell.configure(with: viewModel)
        return cell
       // }
      //  return UITableViewCell()
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






/*
import Foundation
import UIKit

import AVFoundation

final class MainViewController: UIViewController {
    
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        setupNavbar()
        setImageView()
        setTitleLabel()
        setDescriptionLabel()
    }
    
    private func setupNavbar() {
        navigationItem.title = "News"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
            )
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    private func setImageView() {
        imageView.image = UIImage(named: "landscape")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        view.addSubview(imageView)
        imageView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        imageView.pinLeft(to: view, 0)
        imageView.pinRight(to: view, 0)
        imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
        imageView.pinHeight(to: view.widthAnchor)
    }
    
    private func setTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: imageView.bottomAnchor, 12)
        titleLabel.pinLeft(to: view, 16)
        titleLabel.pinRight(to: view, 16)
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
    }
            
    private func setDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel
        
        view.addSubview(descriptionLabel)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 8)
        descriptionLabel.pinLeft(to: view, 16)
        descriptionLabel.pinRight(to: view, 16)
    }
    
    public func configure(with viewModel: NewsViewModel) {
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.description
        if let data = viewModel.imageData {
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

//
//  NewsListViewController.swift
//  kaganinaPW5
//

import Foundation
import UIKit

final class NewsListViewController: UIViewController {
    private var fetchButton = UIButton()
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var isLoading = false
    private var newsViewModels = [NewsViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupFetchButton()
        configureTableView()
    }
    
    private func configureTableView() {
        setTableViewUI()
        setTableViewDelegate()
        setTableViewCell()
    }
    
    private func setupFetchButton() {
         navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(fetchButtonPressed)
         )
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        fetchButton.configuration = createFetchButtonConfig()
        fetchButton.alpha = 0.75
        
        view.addSubview(fetchButton)
        fetchButton.pinLeft(to: view, 16)
        fetchButton.pinRight(to: view, 16)
        fetchButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        
        fetchButton.addTarget(self, action: #selector(fetchButtonPressed(_:)), for: .touchUpInside)
    }
    
    func createFetchButtonConfig() -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        config.background.backgroundColor = .label
        config.baseBackgroundColor = .label
        config.baseForegroundColor = .systemBackground
        config.title = "Fetch new articles"
        config.attributedTitle?.font = .systemFont(ofSize: 16, weight: .medium)
        config.buttonSize = .medium
        config.background.cornerRadius = 12
        return config
    }

    private func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setTableViewUI() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
        view.addSubview(tableView)
        tableView.rowHeight = view.frame.height / 10
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tableView.pinLeft(to: view)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view, view.frame.height / 10)
    }
    
    private func setTableViewCell() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
    }

    
    // MARK ! API SERVICE
    
    
    private func fetchNews() {
        ApiService.shared.getTopStories {
            [weak self] result in switch result {
            case .success(let articles):
                for i in articles.articles {
                    self?.newsViewModels.append(NewsViewModel(
                        title: i.title,
                        description: i.description,
                        imageURL: URL(string: i.urlToImage ?? "")
                    ))
                }
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc
    private func fetchButtonPressed(_ sender: UIButton) {
        fetchNews()
    }
    
    @objc
    private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading { }
        else {
            return newsViewModels.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {}
        else {
            let viewModel = newsViewModels[indexPath.row]
            if let newsCell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier,
                                                            for: indexPath) as? NewsCell {
                newsCell.configure(with: viewModel)
                return newsCell
            }
        }
        return UITableViewCell()
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoading {
            let newsVC = MainViewController()
            newsVC.configure(with: newsViewModels[indexPath.row])
            navigationController?.pushViewController(newsVC, animated: true)
        }
    }
}

//
//  NewsViewModel.swift
//  kaganinaPW5
//

import Foundation

final class NewsViewModel {
    let title: String
    let description: String?
    let imageURL: URL?
    var imageData: Data? = nil

    init(title: String, description: String?, imageURL: URL?) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
    }
}

//
//  News.swift
//  kaganinaPW5
//

import Foundation

struct News: Codable {
    struct Article: Codable {
        let title: String
        let description: String?
        let urlToImage: String?
    }
    let articles: [Article]
}

/*
class UserSh: Codable {
    let name: String
}

struct Post: Codable {
    struct Article: Codable {
        let title: String
        let author: UserSh
        let description: String?
        let urlToImage: String?
      //  let audioFile: AVAudioFile?
        let audioFilePath: String?
    }
    let articles: [Article]
}
*/

//
//  NewsCell.swift
//  kaganinaPW5
//

import Foundation
import UIKit

final class NewsCell: UITableViewCell {
    static let reuseIdentifier = "NewsCell"
    
    private var newsImageView = UIImageView()
    private var newsTitleLabel = UILabel()
    private var newsDescriptionLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
        
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupView() {
        setupImageView()
        setupTitleLabel()
        setupDescriptionLabel()
    }
    
    private func setupImageView() {
        newsImageView.image = UIImage(named: "landscape")
        newsImageView.layer.cornerRadius = 8
        newsImageView.layer.cornerCurve = .continuous
        newsImageView.clipsToBounds = true
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(newsImageView)
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        newsImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        newsImageView.pinWidth(to: newsImageView.heightAnchor)
    }
    
    private func setupTitleLabel() {
        newsTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        newsTitleLabel.textColor = .label
        newsTitleLabel.numberOfLines = 1
        
        contentView.addSubview(newsTitleLabel)
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.heightAnchor.constraint(equalToConstant: newsTitleLabel.font.lineHeight).isActive = true
        newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12).isActive = true
        newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        newsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
    }
    
    private func setupDescriptionLabel() {
        newsDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        newsDescriptionLabel.textColor = .secondaryLabel
        newsDescriptionLabel.numberOfLines = 5
        
        contentView.addSubview(newsDescriptionLabel)
        newsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        newsDescriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12).isActive = true
        newsDescriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 12).isActive = true
        newsDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        newsDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12).isActive = true
    }
    
    public func configure(with viewModel: NewsViewModel) {
        self.newsTitleLabel.text = viewModel.title
        self.newsDescriptionLabel.text = viewModel.description
        if let data = viewModel.imageData {
            self.newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}

//
//  ApiService.swift
//  kaganinaPW5
//

import Foundation

class ApiService {
    static let shared = ApiService()
    
    enum ApiError: Error {
        case error(_ errorString: String)
    }
    
    let source = "https://newsapi.org/v2/top-headlines?country=ru&apiKey=514f26a474024d3d93cd9e4f2b72cf94"
    //let source = "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=514f26a474024d3d93cd9e4f2b72cf94"
    
    func getTopStories(completion: @escaping (Result<News,ApiError>) -> Void) {
        guard let url = URL(string: source) else {
            completion(.failure(ApiError.error("cannot get url")))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(ApiError.error(error.localizedDescription)))
                return
            }
            guard let data = data else {
                completion(.failure(ApiError.error("bad data")))
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(News.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(ApiError.error("Error: \(decodingError.localizedDescription)")))
            }
        }.resume()
    }
}
*/
