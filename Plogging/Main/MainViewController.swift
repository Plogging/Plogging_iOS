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
    var ploggingController: PloggingStartViewController?
    var myPageViewController: MyPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestUserData()
        setUpTabBarUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case MainTab.ranking.segueIdentifier:
            let navigationController = segue.destination as? UINavigationController
            rankingViewController = navigationController?.topViewController as? RankingViewController
        case MainTab.plogging.segueIdentifier:
            ploggingController = segue.destination as? PloggingStartViewController
        case MainTab.myPage.segueIdentifier:
            let navigationController = segue.destination as? UINavigationController
            myPageViewController = navigationController?.topViewController as? MyPageViewController
        default:
            break
        }
    }
    
    func requestUserData() {
        guard let id = PloggingUserData.shared.getUserId() else {
            self.makeLoginRootViewController()
            return
        }
        
        APICollection.sharedAPI.requestUserInfo(id: id) { (response) in
            let userData = try? response.get()
            if userData?.rc != 200 {
                // 쿠키가 유효하지 않음
                self.makeLoginRootViewController()
                return
            } else {
                PloggingUserData.shared.setUserData(userData ?? nil)
            }
        }
    }
    
    func setUpTabBarUI() {
        tabBar.selectedItem = ploggingTabItem
        
        shadowView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -1)
        
        tabBar.clipsToBounds = true
        tabBar.layer.cornerRadius = 37
        tabBar.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.bringSubviewToFront(shadowView)
    }
    
    func setTabBarHidden(_ isHidden: Bool) {
        tabBar.isHidden = isHidden
        shadowView.isHidden = isHidden
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
            myPageViewController?.mypageTabReload()
        default:
            break
        }
        view.bringSubviewToFront(shadowView)
    }
}
