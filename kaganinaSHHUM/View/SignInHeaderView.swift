//
//  SignInHeaderView.swift
//  kaganinaSHHUM
//

import UIKit

class SignInHeaderView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "headphones.circle"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemIndigo
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "share environmental sounds with the world"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(label)
        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       // imageView.frame = CGRect(x: imageView.frame.width, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        
        imageView.pinTop(to: self.safeAreaLayoutGuide.topAnchor)
        imageView.pinLeft(to: self, self.frame.size.width / 10)
        imageView.pinRight(to: self, self.frame.size.width / 10)
        imageView.pinHeight(to: self, self.frame.size.height / 3)
        
        label.pinTop(to: self.safeAreaLayoutGuide.topAnchor)
        label.pinLeft(to: self, self.frame.size.width / 10)
        label.pinRight(to: self, self.frame.size.width / 10)
        label.pinHeight(to: imageView, 10)
        /*
        imageView.pinCenter(to: self)
        imageView.pinWidth(to: self, self.frame.width / 4)
        imageView.pinHeight(to: self, self.frame.width / 4)
        
        label.pinTop(to: self, 20)
        label.pinBottom(to: imageView, 10)
        label.pinWidth(to: self, self.frame.width - 40)
        label.pinHeight(to: imageView, 30)*/
    
    }

}
