//
//  CreateNewPostViewController.swift
//  kaganinaSHHUM
//

import Foundation
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
    private func headerTapped() {
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

final class CreateNewPostViewController: UIViewController {
    
    
 //   private let attachment = AttachmentCollectionView()
    
    
    //---------------------------
    

    // Title field
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

    // Image Header
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()

    // TextView for post
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .secondarySystemBackground
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 28)
        return textView
    }()

    private var selectedHeaderImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerImageView)
        view.addSubview(textView)
        view.addSubview(titleField)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(headerTapped))
        headerImageView.addGestureRecognizer(tap)
        
        setupButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        titleField.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        headerImageView.frame = CGRect(x: 0, y: titleField.frame.origin.y + titleField.frame.size.height+5, width: view.frame.size.width, height: 160)
        textView.frame = CGRect(x: 10, y: headerImageView.frame.origin.y + headerImageView.frame.size.height+10, width: view.frame.size.width-20, height: view.frame.size.height-210-view.safeAreaInsets.top)
    }

    private func setupButtons() {
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
        // Check data and post
        guard let title = titleField.text,
              let body = textView.text,
              let headerImage = selectedHeaderImage,
              let email = UserDefaults.standard.string(forKey: "email"),
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty
        else {

            let alert = UIAlertController(title: "Enter Post Details",
                                          message: "Please enter a title, body, and select a image to continue.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        print("Starting post...")

        let newPostId = UUID().uuidString

        // Upload header Image
        StorageManager.shared.uploadPostHeaderImage(
            email: email,
            image: headerImage,
            postId: newPostId
        ) { success in
            guard success else { return }
            
            StorageManager.shared.downloadURLForPostHeader(email: email, postId: newPostId) { url in
                guard let headerUrl = url
                else {
                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .error)
                    }
                    return
                }

                // Insert of post into DB

                let post = Post(
                    id: newPostId,
                    title: title,
                    timestamp: Date().timeIntervalSince1970,
                    headerImageURL: headerUrl,
                    text: body
                )

                DatabaseManager.shared.insert(post: post, email: email) { [weak self] posted in
                    guard posted else {
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
