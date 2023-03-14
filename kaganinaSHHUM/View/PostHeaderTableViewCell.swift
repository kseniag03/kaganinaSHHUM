//
//  PostHeaderTableViewCell.swift
//  kaganinaSHHUM
//

import Foundation
import UIKit

final class PostHeaderTableViewCellViewModel {
    let imageURL: URL?
    var imageData: Data?

    init(imageURL: URL?) {
        self.imageURL = imageURL
    }
}

final class PostHeaderTableViewCell: UITableViewCell {
    static let identifier = "PostHeaderTableViewCell"

    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .magenta
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = UIImage(named: "landscape")
    }

    func configure(with viewModel: PostHeaderTableViewCellViewModel) {
        if let data = viewModel.imageData {
            DispatchQueue.main.async { [weak self] in
                self?.postImageView.image = UIImage(data: data)
            }
        }
        else if let url = viewModel.imageURL {
            // Fetch image & cache
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
                guard let data = data else { return }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.postImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
