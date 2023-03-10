//
//  ViewController.swift
//  kaganinaSHHUM
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemGray6
        setupMenuButtons()
    }
    
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
    
    private func makeMenuButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        button.backgroundColor = .white
        return button
    }

    @objc
    private func mainScreenButtonPressed() {
        //updateMain
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
}

// экраны

// главное - лента
// поиск по: названию, тегам, авторам, локациям
// диктофон1: загрузка аудио и запись аудио
// диктофон2: экран записи
// профиль: имя, подписчики&подписки, мои записи/избранное
// экран аудиофайла: ник автора, название, переключение, добавить в избранное, теги, обложка

// число тегов <= 5
