//
//  CreateNewPostViewController.swift
//  kaganinaSHHUM
//

import Foundation
//import TTGTagCollectionView
import TTGTags
import UIKit



class HapticsManager {
    static let shared = HapticsManager()

    private init() {}

    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}

extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc
    private func imagePickerButtonPressed() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        selectedHeaderImage = image
        headerImageView.image = image
    }
}

extension CreateNewPostViewController: UIDocumentPickerDelegate {
    
    @objc
    private func recordPickerButtonPressed() {
        let documentTypes = ["public.mp3", "public.m4a"]
        let picker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        picker.allowsMultipleSelection = false
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func documentPickerWasCancelled(_ picker: UIDocumentPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ picker: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        picker.dismiss(animated: true, completion: nil)
        selectedRecordFile = url
    }

    /*
    func documentPicker(_ picker: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // Handle the selected audio file
        // no multiple picking...
    }
    */
    
}

extension CreateNewPostViewController: TTGTextTagCollectionViewDelegate {
    
    @objc
    private func tagPickerButtonPressed() {
        
        titleField.backgroundColor = .brown
        
        print("Tag Tapped!!!!")
        let picker = TagListViewController()
        picker.navigationItem.largeTitleDisplayMode = .always
        let navVc = UINavigationController(rootViewController: picker)
        navVc.navigationBar.prefersLargeTitles = true
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true, completion: nil)
        
    }
 /*
    func tagPickerViewControllerDidFinish(_ viewController: TagListViewController, selectedTags: [TTGTextTag]) {
        // Handle the selected tags
        // ...
    }
    */
}

extension TagListViewController: TTGTextTagCollectionViewDelegate {
    
    
}


final class TagListViewController: UIViewController {
    
    let collectionView = TTGTextTagCollectionView()
    
    var tagsList: [TTGTextTag] = []
    
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
            width: view.frame.size.width - 20,
            height: view.frame.size.height / 2
        )
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        collectionView.alignment = .fillByExpandingSpace
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Select",
            style: .done,
            target: self,
            action: #selector(dismissViewController) // !!! change
        )
    }

    @objc
    private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}

final class CreateNewPostViewController: UIViewController {
    
    private let titleField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Enter Title..."
        field.autocapitalizationType = .words
        field.autocorrectionType = .yes
        field.backgroundColor = .secondarySystemBackground
        field.layer.masksToBounds = true
        return field
    }()

    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemGray6
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 28)
        return textView
    }()
    
    var attachment = UIStackView()

    private var selectedHeaderImage: UIImage?
    
    private var selectedRecordFile: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        attachment.frame = CGRect(
            x: (view.frame.size.width - (view.frame.size.width / 4)) / 3,
            y: view.frame.size.height - 160 - view.safeAreaInsets.bottom,
            width: view.frame.size.width,
            height: view.frame.size.width / 4
        )

        titleField.frame = CGRect(
            x: 10,
            y: view.safeAreaInsets.top,
            width: view.frame.size.width - 20,
            height: 50)
        
        headerImageView.frame = CGRect(
            x: 0,
            y: titleField.frame.origin.y + titleField.frame.size.height + 5,
            width: view.frame.size.width,
            height: 160)
        
        textView.frame = CGRect(
            x: 10,
            y: headerImageView.frame.origin.y + headerImageView.frame.size.height + 10,
            width: view.frame.size.width - 20,
            height: view.frame.size.height / 3)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        let imagePicButton = Style.shared.makeMenuButton(title: "Фото", .systemGray6, .darkGray)
        imagePicButton.addTarget(
            self,
            action: #selector(imagePickerButtonPressed),
            for: .touchUpInside
        )
        
        let recordPicButton = Style.shared.makeMenuButton(title: "Запись", .systemGray6, .darkGray)
        recordPicButton.addTarget(
            self,
            action: #selector(recordPickerButtonPressed),
            for: .touchUpInside
        )
        
        let tagPicButton = Style.shared.makeMenuButton(title: "Теги", .systemGray6, .darkGray)
        tagPicButton.addTarget(
            self,
            action: #selector(tagPickerButtonPressed),
            for: .touchUpInside
        )
        
        attachment = UIStackView(
            arrangedSubviews: [ imagePicButton, recordPicButton, tagPicButton ]
        )
        attachment.spacing = 5
        attachment.axis = .horizontal
        attachment.distribution = .fillEqually
        attachment.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(attachment)
        view.addSubview(headerImageView)
        view.addSubview(textView)
        view.addSubview(titleField)

    }

    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(dismissViewController)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(postTapped)
        )
    }

    @objc
    private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func postTapped() {
        
        let discription = textView.text ?? ""
        let headerImage = selectedHeaderImage
        let recordFile = selectedRecordFile
        
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let title = titleField.text,
              !title.trimmingCharacters(in: .whitespaces).isEmpty
        else {

            let alert = UIAlertController(title: "Enter Post Name",
                                          message: "Please, enter a title to continue.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK.", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        print("Starting post...")

        let newPostId = UUID().uuidString

        StorageManager.shared.uploadPostHeaderImage(
            email: email,
            image: headerImage,
            postId: newPostId
        ) { success in
            guard success else { return }
            
            StorageManager.shared.downloadURLForPostHeader(email: email, postId: newPostId) { url in
                guard let headerURL = url
                else {
                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .error)
                    }
                    return
                }

                let post = Post(
                    id: newPostId,
                    timestamp: Date().timeIntervalSince1970,
                    title: title,
                    text: discription,
                    headerImageURL: headerURL,
                    recordFileURL: recordFile
                )

                DatabaseManager.shared.insert(post: post, email: email) { [weak self] posted in
                    guard posted
                    else {
                        DispatchQueue.main.async {
                            HapticsManager.shared.vibrate(for: .error)
                        }
                        return
                    }

                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .success)
                        self?.dismissViewController()
                    }
                }
            }
        }
    }
}
