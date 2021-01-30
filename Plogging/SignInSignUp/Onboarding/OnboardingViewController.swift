//
//  OnboardingViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/20.
//


import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var defaultView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let scrollView = UIScrollView()
    
    private let onboardingTitleList: [NSMutableAttributedString] = [
        NSMutableAttributedString()
            .bold("조깅", fontSize: 26)
            .normal("하며", fontSize: 26)
            .newLine(fontSize: 26)
            .bold("쓰레기", fontSize: 26)
            .normal("를 주워요!", fontSize: 26),
        
        NSMutableAttributedString()
            .bold("플로깅", fontSize: 26)
            .normal("이 끝난 후", fontSize: 26)
            .newLine(fontSize: 26)
            .normal("내", fontSize: 26)
            .bold("랭킹", fontSize: 26)
            .normal("을 확인해요!", fontSize: 26),
        
        NSMutableAttributedString()
            .bold("SNS", fontSize: 26)
            .normal("를 통해", fontSize: 26)
            .newLine(fontSize: 26)
            .bold("플로깅 기록", fontSize: 26)
            .normal("을 공유해요!", fontSize: 26)
    ]
    
    private let onboardingDescriptionList = [
        "플로깅하며 주운 쓰레기를 기록하고\n총 거리와 시간, 칼로리를 확인해요.",
        "운동점수와 환경점수를 합산한 총점이\n랭킹에 반영돼요.",
        "모든 기록은 마이페이지에 저장되며\n언제든 공유가 가능해요."
    ]
    
    private var isLastPage: Bool = false {
        didSet {
            if isLastPage {
                let confirmImage = UIImage(named: "confirm")
                skipButton.setImage(confirmImage, for: .normal)
            } else {
                let skipImage = UIImage(named: "skip")
                skipButton.setImage(skipImage, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupButtonUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPageLayout()
    }

    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
    }
    
    private func setupButtonUI() {
        skipButton.clipsToBounds = true
        skipButton.layer.cornerRadius = 40
    }
    
    private func setupPageLayout() {
        scrollView.frame = defaultView.bounds
        defaultView.addSubview(scrollView)
        
        for x in 0..<onboardingTitleList.count {
            // 페이지
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * (defaultView.frame.size.width),
                                                y: 0,
                                                width: defaultView.frame.size.width,
                                                height: defaultView.frame.size.height))
            
            // 이미지
            let imageView = UIImageView(frame: CGRect(x: 0,
                                                      y: 100,
                                                      width: 330,
                                                      height: 253))
            imageView.image = UIImage(named: "onboarding\(x + 1)")
            imageView.contentMode = .scaleAspectFit
            imageView.center.x = self.defaultView.center.x
            
            // 제목
            let titleLabel = UILabel(frame: CGRect(x: 0,
                                                   y: imageView.frame.origin.y + imageView.frame.height + 54,
                                                   width: defaultView.frame.size.width,
                                                   height: 68))
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 2
            titleLabel.attributedText = onboardingTitleList[x]

            // 부제목
            let descriptionLabel = UILabel(frame: CGRect(x: 0,
                                                         y: imageView.frame.origin.y + imageView.frame.height + 54 + titleLabel.frame.height + 18,
                                                         width: defaultView.frame.size.width,
                                                         height: 46))
            descriptionLabel.textAlignment = .center
            descriptionLabel.numberOfLines = 2
            descriptionLabel.text = onboardingDescriptionList[x]
            descriptionLabel.textColor = UIColor.lightGrayColor

            // 포함
            scrollView.addSubview(pageView)
            pageView.addSubview(imageView)
            pageView.addSubview(titleLabel)
            pageView.addSubview(descriptionLabel)
        }
        
        let fullContentSize = defaultView.frame.size.width * 3
        scrollView.contentSize = CGSize(width: fullContentSize, height: 0)
    }
    
    @IBAction func ClickedSkipButton(_ sender: UIButton) {
        User.shared.setIsNotFirstTimeUser()
        dismiss(animated: true, completion: nil)
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }

    func setIndiactorForCurrentPage()  {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl?.currentPage = page
        
        if page == onboardingTitleList.count - 1 {
            isLastPage = true
        } else {
            isLastPage = false
        }
    }
}

/// SceneDelegate에서 if User.shared.isFirstTimeUser로 체크하고 OnboardingViewController를 시작점으로 만들어주기
/// 나중에 만들어논 User클래스랑 합치기
/// key는 따로 static으로 만들기
class User {
    static let shared = User()
    
    func isFirstTimeUser() -> Bool {
        return UserDefaults.standard.bool(forKey: "isFirstTimeUser")
    }
    
    func setIsNotFirstTimeUser() {
        UserDefaults.standard.setValue(true, forKey: "isFirstTimeUser")
    }
}
