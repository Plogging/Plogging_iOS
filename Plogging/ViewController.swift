//
//  ViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/03.
//

import UIKit

public enum tabBarItems: Int {
    case ranking
    case plogging
    case mypage
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var rankingView: UIView!
    @IBOutlet weak var ploggingView: UIView!
    @IBOutlet weak var myPageView: UIView!
    @IBOutlet weak var ploggingTabItem: UITabBarItem!
    @IBOutlet weak var shadowView: UIView!
    var rankingViewController: RankingViewController?
    var ploggingController: PloggingViewController?
    var myPageViewController: MyPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        self.tabBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RankingSegue" {
            rankingViewController = segue.destination as? RankingViewController
        } else if segue.identifier == "PloggingSegue" {
            ploggingController = segue.destination as? PloggingViewController
        } else if segue.identifier == "MypageSegue" {
            myPageViewController = segue.destination as? MyPageViewController
        }
    }
    
    func setUp() {
        tabBar.selectedItem = ploggingTabItem
        
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -1)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 0.5
        
        tabBar.clipsToBounds = true
        tabBar.layer.cornerRadius = 40
        tabBar.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.bringSubviewToFront(shadowView)
    }
}

// MARK: UITabBarDelegate
extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case tabBarItems.ranking.rawValue :
            view.bringSubviewToFront(rankingView)
        case tabBarItems.plogging.rawValue :
            view.bringSubviewToFront(ploggingView)
        case tabBarItems.mypage.rawValue :
            view.bringSubviewToFront(myPageView)
        default:
            break
        }
        view.bringSubviewToFront(shadowView)
    }
}
