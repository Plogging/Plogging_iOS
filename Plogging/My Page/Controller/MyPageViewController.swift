//
//  MyPageViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/13.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        registerNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerNib() {
        let nib = UINib(nibName: "PloggingMyListCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "PloggingMyListCollectionViewCell")
    }
}

extension MyPageViewController: UICollectionViewDelegate {
    
}

extension MyPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PloggingMyListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PloggingMyListCollectionViewCell", for: indexPath) as! PloggingMyListCollectionViewCell
        
        return cell
    }
    
    
}
