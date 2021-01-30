//
//  RankingViewController.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/13.
//

import UIKit

class RankingViewController: UIViewController {

    @IBOutlet weak var rankingTitleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupRankingTitle()
    }
    
    private func setupRankingTitle() {
        let rankingTitleString = NSMutableAttributedString()
            .bold("연쇄쓰담마", fontSize: 35)
            .normal("님의", fontSize: 35)
            .newLine(fontSize: 35)
            .normal("랭킹을 확인하세요!", fontSize: 35)
        rankingTitleLabel.attributedText = rankingTitleString
    }
    
    private func setupTableView() {
        let userRankingNib = UINib(nibName: "RankingTableViewCell", bundle: nil)
        tableView.register(userRankingNib, forCellReuseIdentifier: "RankingTableViewCell")
        let myRankingNib = UINib(nibName: "MyRankingTableViewCell", bundle: nil)
        tableView.register(myRankingNib, forCellReuseIdentifier: "MyRankingTableViewCell")
        let rankinbRefreshNib = UINib(nibName: "RankingRefreshTableViewCell", bundle: nil)
        tableView.register(rankinbRefreshNib, forCellReuseIdentifier: "RankingRefreshTableViewCell")


        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 86
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 68, right: 0)
        tableView.contentInset = inset
    }
}

extension RankingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension RankingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: MyRankingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyRankingTableViewCell", for: indexPath) as! MyRankingTableViewCell
            return cell
        } else if indexPath.row == 1 {
            let cell: RankingRefreshTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RankingRefreshTableViewCell", for: indexPath) as! RankingRefreshTableViewCell
            return cell
        } else {
            let cell: RankingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RankingTableViewCell", for: indexPath) as! RankingTableViewCell
            cell.config(index: indexPath)
            return cell
        }
    }
}

class RankigTabBar: UIView {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubview(collectionView)
    }
}
