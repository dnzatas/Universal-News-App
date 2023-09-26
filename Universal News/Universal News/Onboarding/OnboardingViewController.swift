//
//  OnboardingViewController.swift
//  UN
//
//  Created by deniz on 10.09.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!

    var viewModel: OnboardingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        viewModel = OnboardingViewModel()

        viewModel.currentPageDidChange = { [weak self] currentPage in
            self?.pageControl.currentPage = currentPage
            if let currentPage = self?.viewModel.currentPage,
               let numberOfSlides = self?.viewModel.numberOfSlides() {
                self?.nextButton.setTitle(currentPage == numberOfSlides - 1 ? "Get Started" : "Next", for: .normal)
            }
        }
        
        viewModel.navigateToLogin = { [weak self] in
            let storyboard = UIStoryboard(name: Constants.Storyboard.login, bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: Constants.ViewControllers.loginViewController) as! LoginViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            self?.present(controller, animated: true, completion: nil)
        }
        viewModel.viewDidLoad()
    }

    @IBAction func nextButtonClicked(_ sender: UIButton) {
        viewModel.nextButtonClicked()
        let indexPath = IndexPath(item: viewModel.currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfSlides()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(viewModel.slide(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidEndDecelerating(contentOffsetX: scrollView.contentOffset.x, frameWidth: scrollView.frame.width)
        let indexPath = IndexPath(item: viewModel.currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
