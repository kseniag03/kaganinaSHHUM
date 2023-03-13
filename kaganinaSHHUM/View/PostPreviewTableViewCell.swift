//
//  PostPreviewTableViewCell.swift
//  kaganinaSHHUM
//

import Foundation
import UIKit

final class PostPreviewTableViewCellViewModel {
    let title: String
    let imageURL: URL?
    var imageData: Data?

    init(title: String, imageURL: URL?) {
        self.title = title
        self.imageURL = imageURL
    }
}

final class PostPreviewTableViewCell: UITableViewCell {
    static let identifier = "PostPreviewTableViewCell"

    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let postTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
        contentView.addSubview(postTitleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        /*
        postImageView.frame = CGRect(
            x: separatorInset.left,
            y: 5,
            width: contentView.frame.size.height-10,
            height: contentView.frame.size.height-10
        )*/
        
        postImageView.frame = CGRect(
            x: contentView.frame.size.width - 60,
            y: 10,
            width: 50,
            height: 50
        )
        
        
        postTitleLabel.frame = CGRect(
            x: postImageView.frame.origin.x + postImageView.frame.size.width+5,
            y: 5,
            width: contentView.frame.size.width-5-separatorInset.left-postImageView.frame.size.width,
            height: contentView.frame.size.height-10
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postTitleLabel.text = nil
        postImageView.image = nil
    }

    func configure(with viewModel: PostPreviewTableViewCellViewModel) {
        
        print("configure entered ££")
        
        print("viewModel.imageData.description = \(String(describing: viewModel.imageData?.description))")
        print("viewModel.imageURL = \(String(describing: viewModel.imageURL?.absoluteString))")
        
        postTitleLabel.text = viewModel.title

        if let data = viewModel.imageData {
            
            print("111111111 IMAGE FOUND!!!!")
            postImageView.backgroundColor = .magenta
            
            postImageView.image = UIImage(data: data)
        }
        
        /*
         
         if let ref = profilePhotoRef {
             // fetch image
             print("found photo ref: \(ref)")
             StorageManager.shared.dowloadURLForProfilePhoto(path: ref) { url in
                 guard let url = url else { return }
                 let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                     guard let data = data else { return }
                     
                     DispatchQueue.main.async {
                         profilePhoto.image = UIImage(data: data)
                     }
                 }
                 task.resume()
             }
         }
         
         
         */
        
        
        else if let url = viewModel.imageURL {
            
            print("ELSE IF COME HERE")
            // Fetch image & cache
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in

                print("goted data: \(String(describing: data))")
                
                guard let data = data else {
                    return
                }

                viewModel.imageData = data
                DispatchQueue.main.async {
                    
                    print("222222222 IMAGE FOUND!!!!")
                    self?.postImageView.backgroundColor = .systemTeal
                    
                    
                    self?.postImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
