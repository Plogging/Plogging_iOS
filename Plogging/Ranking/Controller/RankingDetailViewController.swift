//
//  RankingDetailViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/14.
//

import UIKit

class RankingDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        registerNib()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
    }
    
    private func registerNib() {
        collectionView.register(RankingDetailCollectionViewCell.self)
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
