//
//  SavedNewsViewController.swift
//  UN
//
//  Created by deniz on 12.09.2023.
//

import UIKit

class SavedNewsViewController: UIViewController {
    @IBOutlet weak var savedNewsCollectionView: UICollectionView!
    @IBOutlet weak var deleteAllSavedArticlesButton: UIButton!
    
    var viewModel: SavedNewsViewModel!
    var noNewsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parent?.title = "Bookmark"
        noNewsLabel = createNoNewsLabel()
        viewModel = SavedNewsViewModel()
        setLayout()
        
        savedNewsCollectionView.delegate = self
        savedNewsCollectionView.dataSource = self
        
        viewModel.noNewsLabelHidden = { [weak self] isHidden in
            self?.noNewsLabel.isHidden = !isHidden
            self?.savedNewsCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchSavedArticles()
        self.parent?.title = "Bookmark"
    }
    
    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let viewWidth = self.savedNewsCollectionView.frame.size.width
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: (viewWidth - 12), height: (viewWidth - 80))
        savedNewsCollectionView.collectionViewLayout = layout
    }
    
    func createNoNewsLabel() -> UILabel {
        noNewsLabel = UILabel()
        noNewsLabel.text = "No saved news available."
        noNewsLabel.textAlignment = .center
        noNewsLabel.textColor = .gray
        noNewsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noNewsLabel)
        NSLayoutConstraint.activate([
            noNewsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNewsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        noNewsLabel.isHidden = true
        
        return noNewsLabel
    }
    
    @IBAction func deleteAllSavedArticlesButtonClicked(_ sender: Any) {
        viewModel.deleteAllSavedArticles()
    }
}

extension SavedNewsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.savedArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCells.savedNewsCollectionViewCell, for: indexPath) as! SavedNewsCollectionViewCell
        let article = viewModel.savedArticles[indexPath.item]
        
        var isBookmarked = UserDefaults.standard.object(forKey: article.id) != nil
        cell.saveButtonAction = { [weak self] in
            if isBookmarked {
                UserDefaults.standard.removeObject(forKey: article.id)
            } else {
                Utilities.saveArticleToUserDefaults(article: article)
            }
            isBookmarked = !isBookmarked
            cell.setBookmarkFilled(isBookmarked)
            self?.viewModel.fetchSavedArticles()
        }
        cell.setBookmarkFilled(isBookmarked)
        
        cell.savedNewsImage.kf.setImage(with: URL(string: article.urlToImage ?? ""), options: [.transition(.fade(0.7))])
        cell.savedNewsDate.text = article.formattedDate
        cell.savedNewsAuthor.text = article.author ?? "N/A"
        cell.savedNewsTitle.text = article.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNews = viewModel.savedArticles[indexPath.row]
        let storyboard = UIStoryboard(name: Constants.Storyboard.detail, bundle: nil)
        let detailController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.detailViewController) as! DetailViewController
        detailController.viewModel = DetailViewModel(article: selectedNews)
        detailController.modalPresentationStyle = .fullScreen
        self.present(detailController, animated: true, completion: nil)
    }
}
