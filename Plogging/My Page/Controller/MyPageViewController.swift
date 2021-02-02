//
//  MyPageViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/13.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let imageView = UIImageView(image: UIImage(named: "onboarding1"))

    override func viewDidLoad() {
        super.viewDidLoad()

        
        registerNib()
        setupCollectionView()
        setupStickyHeader()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
    }
    
    private func setupStickyHeader() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        view.addSubview(imageView)
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

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 40
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}

extension MyPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = -scrollView.contentOffset.y
        let height = max(offsetY, 130)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    }
}
