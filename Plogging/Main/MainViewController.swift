//
//  MainViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/03.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var rankingView: UIView!
    @IBOutlet weak var ploggingView: UIView!
    @IBOutlet weak var myPageView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var ploggingTabItem: UITabBarItem!
    
    var rankingViewController: RankingViewController?
    var ploggingController: PloggingViewController?
    var myPageViewController: MyPageViewController?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case MainTab.ranking.segueIdentifier:
            rankingViewController = segue.destination as? RankingViewController
        case MainTab.plogging.segueIdentifier:
            ploggingController = segue.destination as? PloggingViewController
        case MainTab.myPage.segueIdentifier:
            myPageViewController = segue.destination as? MyPageViewController
        default:
            break
        }
    }
    
    func setUpTabBarUI() {
        tabBar.selectedItem = ploggingTabItem
        
        shadowView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -1)
        
        tabBar.clipsToBounds = true
        tabBar.layer.cornerRadius = 40
        tabBar.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.bringSubviewToFront(shadowView)
    }
}

// MARK: UITabBarDelegate
extension MainViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case MainTab.ranking.index:
            view.bringSubviewToFront(rankingView)
        case MainTab.plogging.index:
            view.bringSubviewToFront(ploggingView)
        case MainTab.myPage.index:
            view.bringSubviewToFront(myPageView)
        default:
            break
        }
        view.bringSubviewToFront(shadowView)
    }
}
