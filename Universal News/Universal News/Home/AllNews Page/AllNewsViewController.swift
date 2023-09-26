//
//  AllNewsViewController.swift
//  UN
//
//  Created by deniz on 12.09.2023.
//


import UIKit
import Kingfisher

class AllNewsViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var categoryLeadingConstraint: NSLayoutConstraint!

    var viewModel: AllNewsViewModel!

    var sideBarShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.title = "News"

        setLayout()

        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.tableFooterView = UIView()

        viewModel = AllNewsViewModel()

        viewModel.filteredArticlesDidChange = { [weak self] filteredArticles in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.title = "News"
        let desiredContentOffset = CGPoint(x: 0, y: -collectionView.contentInset.top)
        collectionView.reloadData()
        collectionView.setContentOffset(desiredContentOffset, animated: true)
    }

    @IBAction func sideMenuButtonClicked(_ sender: UIButton) {
        toggleSideMenu()
    }

    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let viewWidth = self.collectionView.frame.size.width
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: (viewWidth - 30) / 2, height: (viewWidth - 140))
        collectionView.collectionViewLayout = layout
    }

    func toggleSideMenu() {
        if sideBarShowing {
            categoryLeadingConstraint.constant = -220
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            categoryLeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        sideBarShowing = !sideBarShowing
    }
}

extension AllNewsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredArticles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCells.allNewsCollectionViewCell, for: indexPath) as! AllNewsCollectionViewCell
        let articleInfos = viewModel.filteredArticles[indexPath.row]

        var isBookmarked = UserDefaults.standard.object(forKey: articleInfos.id) != nil
        cell.bookmarkButtonAction = {
            if isBookmarked {
                UserDefaults.standard.removeObject(forKey: articleInfos.id)
            } else {
                Utilities.saveArticleToUserDefaults(article: articleInfos)
            }
            isBookmarked = !isBookmarked
            cell.setBookmarkFilled(isBookmarked)
        }
        cell.setBookmarkFilled(isBookmarked)

        cell.newsImage.kf.indicatorType = .activity
        cell.newsImage.kf.setImage(with: URL(string: articleInfos.urlToImage ?? ""), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        cell.newsTitle.text = articleInfos.title
        cell.newsDate.text = articleInfos.formattedDate

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNews = viewModel.filteredArticles[indexPath.row]
        let storyboard = UIStoryboard(name: Constants.Storyboard.detail, bundle: nil)
        let detailController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.detailViewController) as! DetailViewController
        detailController.viewModel = DetailViewModel(article: selectedNews)
        detailController.modalPresentationStyle = .fullScreen
        self.present(detailController, animated: true, completion: nil)
    }
}

extension AllNewsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.filteredArticles = viewModel.articleList
        } else {
            viewModel.filteredArticles = viewModel.articleList.filter { article in
                let searchTextLowercased = searchText.lowercased()
                return article.title.lowercased().contains(searchTextLowercased) ||
                    (article.description?.lowercased().contains(searchTextLowercased) ?? false) ||
                    (article.author?.lowercased().contains(searchTextLowercased) ?? false) ||
                    (article.content?.lowercased().contains(searchTextLowercased) ?? false)
            }
        }
        collectionView.reloadData()
    }
}

extension AllNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.categories.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.sideMenuTableViewCell, for: indexPath)
        cell.textLabel?.text = viewModel.categories[indexPath.row].displayName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = viewModel.categories[indexPath.row].category
        viewModel.fetchTopHeadlines(url: Constants.Urls.categoryUrl(for: selectedCategory)!)
        toggleSideMenu()
        self.parent?.title = viewModel.categories[indexPath.row].displayName
    }
}
