//
//  TabBarController.swift
//  kaganinaSHHUM
//

import Foundation
import UIKit


final class TabBarController: UITabBarController {
    /*
    private enum TabBarItem: Int {
        case main
        case search
        case recorder
        case profile
        
        var title: String {
            switch self {
            case .main:
                return "Лента"
            case .search:
                return "Поиск"
            case .recorder:
                return "Рекордер"
            case .profile:
                return "Профиль"
            }
        }

        var iconName: String {
            switch self {
            case .main:
                return "house.fill"
            case .search:
                return "magnifyingglass"
            case .recorder:
                return "mic.fill"
            case .profile:
                return "person.circle.fill"
            }
        }
    }
*/

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let firstViewController = ViewController()
        let secondViewController = SearchViewController()
        let thirdViewController = RecorderViewController()
        let fourthViewController = ProfileViewController()

        firstViewController.tabBarItem = UITabBarItem(title: "First", image: UIImage(named: "house.fill"), selectedImage: nil)
        secondViewController.tabBarItem = UITabBarItem(title: "Second", image: UIImage(named: "magnifyingglass"), selectedImage: nil)
        //thirdViewController.tabBarItem = UITabBarItem(title: "Third", image: UIImage(named: "mic.fill"), selectedImage: nil)
        //fourthViewController.tabBarItem = UITabBarItem(title: "Fourth", image: UIImage(named: "person.circle.fill"), selectedImage: nil)

        //self.viewControllers = [firstViewController, secondViewController, thirdViewController, fourthViewController]
        
        self.viewControllers?.append(firstViewController)
        
        
        //self.setupTabBar()
    }
    
    
    
    
    /*
    //В методе мы создадим создадим контроллеры FeedViewController и ProfileViewControlle для TabBarController. Не забудьте как и в первом способе создать сами swift файлы!
    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.main, .search, .recorder, .profile]
        self.viewControllers = dataSource.map {
            switch $0 {
            case .main:
                let mainViewController = ViewController()
                return self.wrappedInNavigationController(with: mainViewController, title: $0.title)
            case .search:
                let searchViewController = SearchViewController()
                return self.wrappedInNavigationController(with: searchViewController, title: $0.title)
            case .recorder:
                let recorderViewController = RecorderViewController()
                return self.wrappedInNavigationController(with: recorderViewController, title: $0.title)
            case .profile:
                let profileViewController = ProfileViewController()
                return self.wrappedInNavigationController(with: profileViewController, title: $0.title)
            }
        }
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
    }
    
    //Ну и в самом конце методом wrappedInNavigationController(with: profileViewController, title: $0.title) мы обернем переданный контроллер FeedViewController или ProfileViewControlleв NavigationController
    private func wrappedInNavigationController(with: UIViewController, title: Any?) -> UINavigationController {
        return UINavigationController(rootViewController: with)
    }
*/
}

