//
//  ViewController.swift
//  kaganinaSHHUM
//


//
//  ViewController.swift
//  kaganinaSHHUM
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemGray6
        let button = makeMenuButton(title: "TABS")
        button.addTarget(
            self,
            action: #selector(openTabBarController),
            for: .touchUpInside
        )
        self.view.addSubview(button)
        button.pinLeft(to: self.view, self.view.frame.size.width / 10)
        button.pinRight(to: self.view, self.view.frame.size.width / 10)
        button.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor)
        //setupMenuButtons()
    }
    
    @objc
    private func openTabBarController() {
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.backgroundColor = .white
        
        let mainController = UINavigationController(rootViewController: MainViewController())
        mainController.title = "Лента"
        let searchController = UINavigationController(rootViewController: SearchViewController())
        searchController.title = "Поиск"
        let recorderController = UINavigationController(rootViewController: RecorderViewController())
        recorderController.title = "Рекордер"
        let profileController = UINavigationController(rootViewController: ProfileViewController())
        profileController.title = "Профиль"
        
        tabBarVC.setViewControllers(
            [
                mainController,
                searchController,
                recorderController,
                profileController
            ],
            animated: false)
        
        guard let items = tabBarVC.tabBar.items else { return }
        let images = [ "house.fill", "magnifyingglass", "mic.fill", "person.circle.fill"]
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
        }
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
    
    private func makeMenuButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }
/*
    private func setupMenuButtons() {
        let mainScreenButton = makeMenuButton(title: "MAIN")
        mainScreenButton.addTarget(
            self,
            action: #selector(mainScreenButtonPressed),
            for: .touchUpInside
        )
        let searchButton = makeMenuButton(title: "SEARCH")
        searchButton.addTarget(
            self,
            action: #selector(searchButtonPressed),
            for: .touchUpInside
        )
        let recorderButton = makeMenuButton(title: "RECORD")
        recorderButton.addTarget(
            self,
            action: #selector(recorderButtonPressed),
            for: .touchUpInside
        )
        let profileButton = makeMenuButton(title: "PROFILE")
        profileButton.addTarget(
            self,
            action: #selector(profileButtonPressed),
            for: .touchUpInside
        )
        
        let buttonsStackView = UIStackView(
            arrangedSubviews: [ mainScreenButton, searchButton, recorderButton, profileButton]
        )
        buttonsStackView.spacing = 12
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        
        self.view.addSubview(buttonsStackView)
        buttonsStackView.pinLeft(to: self.view, self.view.frame.size.width / 10)
        buttonsStackView.pinRight(to: self.view, self.view.frame.size.width / 10)
        buttonsStackView.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    @objc
    private func mainScreenButtonPressed() {
        //updateMain throght infoviewctrl
        self.view.backgroundColor = UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1
        )
    }
    
    @objc
    private func searchButtonPressed() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @objc
    private func recorderButtonPressed() {
        let recorderViewController = RecorderViewController()
        navigationController?.pushViewController(recorderViewController, animated: true)
    }
    
    @objc
    private func profileButtonPressed() {
        let profileViewController = ProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
     */
}

// экраны

// главное - лента
// поиск по: названию, тегам, авторам, локациям
// диктофон1: загрузка аудио и запись аудио
// диктофон2: экран записи
// профиль: имя, подписчики&подписки, мои записи/избранное
// экран аудиофайла: ник автора, название, переключение, добавить в избранное, теги, обложка

// число тегов <= 5


/*

import Foundation
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemMint//.systemGray6
        setupButtons()
    }
    
    private func makeMenuButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }
    
    func setupButtons() {
        let searchMenuButton = makeMenuButton(title: "SEARCH")
        searchMenuButton.addTarget(
            self,
            action: #selector(openSearchController),
            for: .touchUpInside
        )
        
        let recorderMenuButton = makeMenuButton(title: "RECORDER")
        recorderMenuButton.addTarget(
            self,
            action: #selector(openRecordController),
            for: .touchUpInside
        )
        
        let profileMenuButton = makeMenuButton(title: "PROFILE")
        profileMenuButton.addTarget(
            self,
            action: #selector(openProfileController),
            for: .touchUpInside
        )
        
        let buttonsSV = UIStackView(arrangedSubviews: [
            searchMenuButton,
            recorderMenuButton,
            profileMenuButton
        ])
        buttonsSV.spacing = 12
        buttonsSV.axis = .horizontal
        buttonsSV.distribution = .fillEqually

        self.view.addSubview(buttonsSV)
        buttonsSV.pinBottom(to: self.view.bottomAnchor, self.view.frame.height / 10)
        buttonsSV.pinLeft(to: self.view, self.view.frame.width / 10)
        buttonsSV.pinRight(to: self.view, self.view.frame.width / 10)
        //buttonsSV.pinHeight(to: self.view.heightAnchor)
        buttonsSV.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    @objc
    func openSearchController() {
        let searchController = SearchViewController()
        //searchController.view.backgroundColor = view.backgroundColor ?? .systemBackground
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    @objc
    func openRecordController() {
        let recordController = RecorderViewController()
        //recordController.view.backgroundColor = view.backgroundColor ?? .systemBackground
        navigationController?.pushViewController(recordController, animated: true)
    }
    
    @objc
    func openProfileController() {
        let profileController = ProfileViewController()
        //profileController.view.backgroundColor = view.backgroundColor ?? .systemBackground
        navigationController?.pushViewController(profileController, animated: true)
    }
    
}
 
*/
