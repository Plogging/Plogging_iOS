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
    
    private var ploggingList: RankingGlobal? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupRankingTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestRankingAPI()
    }
    
    private func requestRankingAPI() {
        let param: [String: Any] = ["rankType": "weekly",
                                    "offset": 0,
                                    "limit": 10]
        
        APICollection.sharedAPI.requestGlobalRanking(param: param) { (response) in
            self.ploggingList = try? response.get()
        }
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

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 86
        
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
        guard let count = ploggingList?.count else {
            return 1
        }
        return count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: MyRankingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyRankingTableViewCell", for: indexPath) as! MyRankingTableViewCell
            return cell
        } else {
            let cell: RankingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RankingTableViewCell", for: indexPath) as! RankingTableViewCell
            if let model = ploggingList?.rankData[indexPath.row - 1]  {
                cell.config(model, index: indexPath)
            }
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
