import Foundation

class OnboardingViewModel {
    var currentPage: Int = 0
    var slides: [OnboardingSlide] = OnboardingSlide.slides
    
    var currentPageDidChange: ((Int) -> Void)?
    var navigateToLogin: (() -> Void)?
    
    var currentIndex: Int {
        didSet {
            currentPageDidChange?(currentIndex)
        }
    }
    
    init() {
        self.currentIndex = currentPage
    }
    
    func numberOfSlides() -> Int {
        return slides.count
    }
    
    func slide(at index: Int) -> OnboardingSlide {
        return slides[index]
    }

    func viewDidLoad() {
        currentPageDidChange?(currentPage)
    }
    
    func nextButtonClicked() {
        if currentPage == slides.count - 1 {
            navigateToLogin?()
        } else {
            currentPage += 1
            currentIndex = currentPage
        }
    }
    
    func scrollViewDidEndDecelerating(contentOffsetX: CGFloat, frameWidth: CGFloat) {
        let newPage = Int(contentOffsetX / frameWidth)
        if newPage != currentPage {
            currentPage = newPage
            currentIndex = currentPage
        }
    }
}
