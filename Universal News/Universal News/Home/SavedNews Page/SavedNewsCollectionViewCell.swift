//
//  SavedNewsCollectionViewCell.swift
//  UN
//
//  Created by deniz on 15.09.2023.
//

import UIKit

class SavedNewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var savedNewsImage: UIImageView!
    @IBOutlet weak var savedNewsDate: UILabel!
    @IBOutlet weak var savedNewsAuthor: UILabel!
    @IBOutlet weak var savedNewsTitle: UILabel!
    @IBOutlet weak var savedNewsSaveButton: UIButton!
    
    var saveButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 7.0
        
        savedNewsSaveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        saveButtonAction?()
    }
    
    func setBookmarkFilled(_ filled: Bool) {
        let imageName = filled ? "bookmark.fill" : "bookmark"
        savedNewsSaveButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
