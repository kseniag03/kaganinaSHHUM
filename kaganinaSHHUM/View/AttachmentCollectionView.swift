//
//  AttachmentCollectionView.swift
//  kaganinaSHHUM
//
/*
import Foundation
import UIKit

protocol AttachmentCollectionCellDelegate: AnyObject {
    func attachmentCellDidTapImagePicker(_ picker: UIImagePickerController)
    func attachmentCellDidTapAudioPicker(_ picker: UIDocumentPickerViewController)
   // func attachmentCellDidTapTagPicker(_ picker: TagPickerViewController)
}

final class AttachmentCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    
 //   let documentTypes = ["public.audio", "public.m4a"]
    private let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio", "public.m4a"], in: .import)
    
//    private let tagPicker = TagPickerViewController()
    
    
    weak var delegate: AttachmentCollectionCellDelegate?
    
    private let carouselView = UIView()
    private let imagePickerButton = UIButton()
    private let audioPickerButton = UIButton()
    private let tagPickerButton = UIButton()
    private let selectedTagsLabel = UILabel()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {/*
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        carouselView.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        contentView.addSubview(carouselView)/*
        NSLayoutConstraint.activate([
            carouselView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            carouselView.topAnchor.constraint(equalTo: contentView.topAnchor),
            carouselView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])*/

        carouselView.pinTop(to: self.safeAreaLayoutGuide.topAnchor)
        carouselView.pinLeft(to: self, self.frame.size.width / 10)
        carouselView.pinRight(to: self, self.frame.size.width / 10)
        
        carouselView.backgroundColor = .quaternaryLabel*/
        
        /*
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        imagePickerButton.setTitle("Select Image", for: .normal)
        imagePickerButton.addTarget(self, action: #selector(didTapImagePickerButton), for: .touchUpInside)
        carouselView.addSubview(imagePickerButton)
        NSLayoutConstraint.activate([
            imagePickerButton.leadingAnchor.constraint(equalTo: carouselView.leadingAnchor),
            imagePickerButton.topAnchor.constraint(equalTo: carouselView.topAnchor),
            imagePickerButton.bottomAnchor.constraint(equalTo: carouselView.bottomAnchor),
            imagePickerButton.widthAnchor.constraint(equalTo: carouselView.widthAnchor, multiplier: 1/3)
        ])
        
        audioPickerButton.translatesAutoresizingMaskIntoConstraints = false
        audioPickerButton.setTitle("Select Audio", for: .normal)
        audioPickerButton.addTarget(self, action: #selector(didTapAudioPickerButton), for: .touchUpInside)
        carouselView.addSubview(audioPickerButton)
        NSLayoutConstraint.activate([
            audioPickerButton.leadingAnchor.constraint(equalTo: imagePickerButton.trailingAnchor),
            audioPickerButton.topAnchor.constraint(equalTo: carouselView.topAnchor),
            audioPickerButton.bottomAnchor.constraint(equalTo: carouselView.bottomAnchor),
            audioPickerButton.widthAnchor.constraint(equalTo: carouselView.widthAnchor, multiplier: 1/3)
        ])
        
        tagPickerButton.translatesAutoresizingMaskIntoConstraints = false
        tagPickerButton.setTitle("Select Tags", for: .normal)
        tagPickerButton.addTarget(self, action: #selector(didTapTagPickerButton), for: .touchUpInside)
        carouselView.addSubview(tagPickerButton)
        NSLayoutConstraint.activate([
            tagPickerButton.leadingAnchor.constraint(equalTo: audioPickerButton.trailingAnchor),
            tagPickerButton.topAnchor.constraint(equalTo: carouselView.topAnchor),
            tagPickerButton.bottomAnchor.constraint(equalTo: carouselView.bottomAnchor),
            tagPickerButton.widthAnchor.constraint(equalTo: carouselView.widthAnchor, multiplier: 1/3)
        ])
        
        selectedTagsLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedTagsLabel.numberOfLines = 1
        selectedTagsLabel.textColor = .systemGray
        carouselView.addSubview(selectedTagsLabel)
        NSLayoutConstraint.activate([
            selectedTagsLabel.leadingAnchor.constraint(equalTo: carouselView.leadingAnchor, constant: 16),
            selectedTagsLabel.trailingAnchor.constraint(equalTo: carouselView.trailingAnchor, constant: -16),
            selectedTagsLabel.bottomAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: -16),
            selectedTagsLabel.heightAnchor.constraint(equalToConstant: 20)
        ]) */
    }
    
    // MARK: - Button Actions
    
    @objc
    private func didTapImagePickerButton() {
        // Present image picker
        // ...
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        delegate?.attachmentCellDidTapImagePicker(imagePicker)
        
    }

    
    @objc
    private func didTapAudioPickerButton() {
        // Present audio document picker
        // ...
        documentPicker.delegate = self
        delegate?.attachmentCellDidTapAudioPicker(documentPicker)
    }
    
    @objc
    private func didTapTagPickerButton() {
        // Present tag picker
        // ...
        //tagPicker.delegate = self
        //delegate?.attachmentCellDidTapTagPicker(tagPicker)
    }

    
}

extension AttachmentCollectionCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Handle the selected image
        // ...
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the image picker
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension AttachmentCollectionCell: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // Handle the selected audio file
        // ...
    }
    
}




// MARK: - TagPickerViewControllerDelegate
/*
 
 extension AttachmentCollectionCell: TagPickerViewControllerDelegate {
     
     func tagPickerViewControllerDidFinish(_ viewController: TagPickerViewController, selectedTags: [String]) {
         // Handle the selected tags
         // ...
     }
     
 }
 
 
extension AttachmentCollectionCell: TagPickerViewControllerDelegate {
    
    func tagPickerViewController(_ controller: TagPickerViewController, didSelectTags tags: [String]) {
        // Update selected tags label
        selectedTagsLabel.text = "Selected Tags: \(tags.prefix(5).joined(separator: ", "))"
    }

    
}*/
    
    


/*

extension AttachmentCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: AttachmentCollectionCell.identifier, for: indexPath)
        return cell
    }
    
}

extension AttachmentCollectionView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc
    private func headerTapped() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
     //   present(picker, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        // some settings
    }
}

extension AttachmentCollectionView: UIDocumentPickerDelegate {
    
}

final class AttachmentCollectionView: UICollectionView {
    
    let cells = [Any]()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .quaternaryLabel
        
        dataSource = self
        delegate = self
        register(AttachmentCollectionCell.self,
                 forCellWithReuseIdentifier: AttachmentCollectionCell.identifier)
        
        let picturePicker = UIImagePickerController()
        
        let documentTypes = ["public.audio", "public.m4a"]
        let documentPicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .formSheet
   //     present(documentPicker, animated: true, completion: nil)
        
        let attachmentCells: [Any] = [
            picturePicker,
            documentPicker
        ]
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class AttachmentCollectionCell: UICollectionViewCell {
    
    static let identifier = "AttachmentCollectionCell"
    
    private var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "+"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.pinTop(to: self.safeAreaLayoutGuide.topAnchor)
        label.pinLeft(to: self, self.frame.size.width / 10)
        label.pinRight(to: self, self.frame.size.width / 10)
        label.pinHeight(to: self, 10)
        
    }

    
}
*/
*/
