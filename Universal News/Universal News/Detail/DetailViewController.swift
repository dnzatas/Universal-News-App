//
//  DetailViewController.swift
//  UN
//
//  Created by deniz on 14.09.2023.
//

import UIKit

class DetailViewController: UIViewController {
    var viewModel: DetailViewModel!
    
    @IBOutlet weak var detailNewsImage: UIImageView!
    @IBOutlet weak var detailAuthorLabel: UILabel!
    @IBOutlet weak var detailDateLAbel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailContentLabel: UILabel!
    @IBOutlet weak var detailBookmarkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailNewsImage.kf.setImage(with: viewModel.imageURL, options: [.transition(.fade(0.7))])
        detailAuthorLabel.text = viewModel.author
        detailDateLAbel.text = viewModel.formattedDate
        detailTitleLabel.text = viewModel.title
        detailDescriptionLabel.text = viewModel.description
        detailContentLabel.text = viewModel.formattedContent
        
        Utilities.setBookmarkFilled(detailBookmarkButton, viewModel.isBookmarked)
    }
    
    @IBAction func detailBackButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func detailBookmarkButtonClicked(_ sender: Any) {
        viewModel.toggleBookmark()
        Utilities.setBookmarkFilled(detailBookmarkButton, viewModel.isBookmarked)
    }
}
