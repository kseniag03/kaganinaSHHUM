//
//  TabBarViewController.swift
//  kaganinaSHHUM
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .white
        setUpController()
    }
    
    private func setUpController() {
        
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "email") else { return }
        
        let mainController = MainViewController()
        mainController.title = "Лента"
        mainController.navigationItem.largeTitleDisplayMode = .always
        let navMain = UINavigationController(rootViewController: mainController)
        navMain.navigationBar.prefersLargeTitles = true
        
        let searchController = SearchViewController()
        searchController.title = "Поиск"
        searchController.navigationItem.largeTitleDisplayMode = .always
        let navSearch = UINavigationController(rootViewController: searchController)
        navSearch.navigationBar.prefersLargeTitles = true
        
        let recorderController = RecorderViewController()
        recorderController.title = "Рекордер"
        recorderController.navigationItem.largeTitleDisplayMode = .always
        let navRecorder = UINavigationController(rootViewController: recorderController)
        navRecorder.navigationBar.prefersLargeTitles = true
        
        let profileController = ProfileViewController(currentEmail: currentUserEmail)
        profileController.title = "Профиль"
        profileController.navigationItem.largeTitleDisplayMode = .always
        let navProfile = UINavigationController(rootViewController: profileController)
        navProfile.navigationBar.prefersLargeTitles = true
        
        setViewControllers(
            [
                navMain,
                navSearch,
                navRecorder,
                navProfile
            ],
            animated: true)
        
        guard let items = tabBar.items else { return }
        let images = [ "house.fill", "magnifyingglass", "mic.fill", "person.circle.fill"]
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
        }
        
        modalPresentationStyle = .fullScreen
    }
}
