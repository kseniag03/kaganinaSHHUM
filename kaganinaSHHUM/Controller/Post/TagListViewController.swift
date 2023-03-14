//
//  TagListViewController.swift
//  kaganinaSHHUM
//

import Foundation
import TTGTags
import UIKit

extension TagListViewController: TTGTextTagCollectionViewDelegate {
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        print("didTap")

        if let i = selectedTagsList.firstIndex(of: tag) {
            selectedTagsList.remove(at: i)
            collectionView.getTagAt(index).style.backgroundColor = .link
        } else {
            if selectedTagsList.count < 5 {
                selectedTagsList.append(tag)
                collectionView.getTagAt(index).style.backgroundColor = .systemBlue
                tag.style.backgroundColor = .black
            } else {
                print("cannot add more than 5 tags to post")
            }
            
        }
        
        for tag in selectedTagsList {
            print("selected item: \(tag.content)")
        }
        
    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTap tag: TTGTextTag!, at index: UInt) -> Bool {
        print("canTap")
        return true
    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, updateContentSize contentSize: CGSize) {
        print("updatecontentsize")
    }
    
    func getSelectedTags() -> [String] {
        return selectedTagsList.compactMap { tag in
            if let stringContent = tag.content as? TTGTextTagStringContent {
                return stringContent.text
            }
            return nil
        }
    }
}


final class TagListViewController: UIViewController {
    
    private let collectionView = TTGTextTagCollectionView()
    
    private var selectedTagsList: [TTGTextTag] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionView.frame = CGRect(
            x: 100,
            y: 100,
            width: view.frame.size.width / 2,
            height: view.frame.size.height / 2
        )
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        collectionView.alignment = .fillByExpandingSpace
        collectionView.selectionLimit = 5
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        let config = TTGTextTagStyle()
        config.backgroundColor = .systemBlue
        config.borderColor = .link
        config.borderWidth = 2
        
        let tags = [
            "Зима", "Дождь", "Природа", "Лес",
            "Животные", "Люди", "Диалоги", "Голоса", "Шёпот",
            "Город", "Метро", "Шум", "Дорога", "Большие города", "Клуб", "Вечеринка"
        ]
        
        for tag in tags {
            let textTag = TTGTextTag(content: TTGTextTagStringContent(text: tag), style: config)
            collectionView.addTag(textTag)
        }
        
        collectionView.reload()
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(dismissViewController)
        )
    }

    @objc
    private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
