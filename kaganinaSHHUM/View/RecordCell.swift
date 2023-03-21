//
//  RecordCell.swift
//  kaganinaSHHUM
//

import Foundation
import UIKit

final class RecordCell: UITableViewCell {
    
    static let identifier = "RecordCell"
    
    private var textlabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupView() {
        contentView.backgroundColor = .systemBackground
        
        textlabel.font = .systemFont(ofSize: 16, weight: .regular)
        textlabel.textColor = .label
        textlabel.numberOfLines = 0
        textlabel.backgroundColor = .clear
        
        contentView.addSubview(textlabel)
        textlabel.pinTop(to: contentView.safeAreaLayoutGuide.topAnchor)
        textlabel.pinLeft(to: contentView, 16)
        textlabel.pinRight(to: contentView, 16)
        textlabel.pinHeight(to: contentView.safeAreaLayoutGuide.heightAnchor)
    }
    
    public func configure(_ record: Record) {
        let fileName = record.recordURL.deletingPathExtension().lastPathComponent
        print("!!! record cell configure filename" + String(fileName))
        textlabel.text = "Запись_\(fileName)"
        print("label text = " + (textlabel.text ?? "##NIL") )
    }
}

