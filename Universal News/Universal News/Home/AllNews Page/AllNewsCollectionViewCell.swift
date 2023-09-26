//
//  AllNewsCollectionViewCell.swift
//  UN
//
//  Created by deniz on 14.09.2023.
//

import UIKit

class AllNewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsBookmarkButton: UIButton!
    
    var bookmarkButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 5.0
        
        newsBookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
    }
    
    @objc func bookmarkButtonTapped() {
            bookmarkButtonAction?()
    }
    
    func setBookmarkFilled(_ filled: Bool) {
        let imageName = filled ? "bookmark.fill" : "bookmark"
        newsBookmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
