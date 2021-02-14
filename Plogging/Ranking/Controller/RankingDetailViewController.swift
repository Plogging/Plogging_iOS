//
//  RankingDetailViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/14.
//

import UIKit

class RankingDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var headerView: CustomHeaderView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        registerNib()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func animateHeader() {
        self.headerHeightConstraint.constant = 300
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut,
                       animations: {
                        self.view.layoutIfNeeded()
                       }, completion: nil)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerNib() {
        collectionView.register(RankingDetailCollectionViewCell.self)
    }

}

extension RankingDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 헤더 뷰 증가
        if scrollView.contentOffset.y < 0 {
            self.headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
            headerView.incrementColorAlpha(offset: self.headerHeightConstraint.constant)
            headerView.incrementAlpha(offset: self.headerHeightConstraint.constant)
        }
        // 헤더 뷰 감소
        else if scrollView.contentOffset.y > 0 && self.headerHeightConstraint.constant >= 65 {
            self.headerHeightConstraint.constant -= scrollView.contentOffset.y/100
            headerView.decrementColorAlpha(offset: scrollView.contentOffset.y)
            headerView.decrementAlpha(offset: self.headerHeightConstraint.constant)
            
            if self.headerHeightConstraint.constant < 65 {
                self.headerHeightConstraint.constant = 65
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightConstraint.constant > 300 {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant > 300 {
            animateHeader()
        }
    }
}

extension RankingDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RankingDetailCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

extension RankingDetailViewController: UICollectionViewDelegate {
    
}

extension RankingDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
//        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - 40) / 2.0
        return CGSize(width: size, height: size)
    }
}
