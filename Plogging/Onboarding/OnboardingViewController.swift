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
        "플로깅하며 주운 쓰레기를 기록하고 총 거리와 시간, 칼로리를 확인해요.",
        "운동점수와 환경점수를 합산한 총점이 랭킹에 반영돼요.",
        "모든 기록은 마이페이지에 저장되며 언제든 공유가 가능해요."
    ]
    
    private var isLastPage: Bool = false {
        didSet {
            if isLastPage {
                skipButton.setTitle("확인", for: .normal)
                skipButton.backgroundColor = UIColor(red: 55, green: 213, blue: 172, alpha: 1)
            } else {
                skipButton.setTitle("건너뛰기", for: .normal)
                skipButton.backgroundColor = UIColor(red: 234, green: 234, blue: 234, alpha: 1)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }

    func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
    }
    
    private func setupUI() {
        skipButton.clipsToBounds = true
        skipButton.layer.cornerRadius = 42
        
        scrollView.frame = defaultView.bounds
        defaultView.addSubview(scrollView)
        
        for x in 0..<onboardingTitleList.count {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * (defaultView.frame.size.width), y: 0, width: defaultView.frame.size.width, height: defaultView.frame.size.height))
            scrollView.addSubview(pageView)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 16, width: 330, height: 253))
            imageView.image = UIImage(named: "onboarding\(x + 1)")
            imageView.center = defaultView.center
            
            let titleLabel = UILabel(frame: CGRect(x: 0, y: imageView.frame.origin.y + imageView.frame.height + 16, width: defaultView.frame.size.width, height: 68))
            titleLabel.numberOfLines = 2
            titleLabel.attributedText = onboardingTitleList[x]

            let descriptionLabel = UILabel(frame: CGRect(x: 0, y: titleLabel.frame.origin.y + 48, width: defaultView.frame.size.width, height: 68))
            descriptionLabel.numberOfLines = 2
            descriptionLabel.text = onboardingDescriptionList[x]
            descriptionLabel.textColor = UIColor(red: 182, green: 182, blue: 182, alpha: 1)

            pageView.addSubview(imageView)
            pageView.addSubview(titleLabel)
            pageView.addSubview(descriptionLabel)
        }
        
        scrollView.contentSize = CGSize(width: defaultView.frame.size.width * 3, height: 0)
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
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl?.currentPage = Int(page)
    }
}

/// SceneDelegate에서 if User.shared.isFirstTimeUser로 체크하고 OnboardingViewController를 시작점으로 만들어주기
/// 나중에 만들어논 User클래스랑 합치기
/// key는 따로 static으로 만들기
class User {
    static let shared = User()
    
    func isFirstTimeUser() -> Bool {
        return UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotFirstTimeUser() {
        UserDefaults.standard.setValue(true, forKey: "isNewUser")
    }
}

