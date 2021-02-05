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
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var weeklyView: UIView!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var monthlyView: UIView!
    
    private var ploggingList: RankingGlobal? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var refresh: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupRankingTitle()
        createRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestRankingAPI(type: "weekly")
    }
    
    private func requestRankingAPI(type: String) {
        let param: [String: Any] = ["rankType": type,
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
    
    private func registerNib() {
        let userRankingNib = UINib(nibName: "RankingTableViewCell", bundle: nil)
        tableView.register(userRankingNib, forCellReuseIdentifier: "RankingTableViewCell")
        let myRankingNib = UINib(nibName: "MyRankingTableViewCell", bundle: nil)
        tableView.register(myRankingNib, forCellReuseIdentifier: "MyRankingTableViewCell")
        let rankinbRefreshNib = UINib(nibName: "RankingRefreshTableViewCell", bundle: nil)
        tableView.register(rankinbRefreshNib, forCellReuseIdentifier: "RankingRefreshTableViewCell")
    }
    
    private func setupTableView() {
        registerNib()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 86
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 68, right: 0)
        tableView.contentInset = inset
    }
    
    private func createRefreshControl() {
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateRanking), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    @objc private func updateRanking() {
        refresh.endRefreshing()
        tableView.reloadData()
    }
    
    @IBAction func weeklyButtonClick(_ sender: UIButton) {
        weeklyButton.setTitleColor(UIColor.greenBlue, for: .normal)
        monthlyButton.setTitleColor(UIColor.rankingGray, for: .normal)
        
        weeklyView.alpha = 1
        monthlyView.alpha = 0
        
        requestRankingAPI(type: "weekly")
    }
    
    @IBAction func montlyButtonClick(_ sender: UIButton) {
        weeklyButton.setTitleColor(UIColor.rankingGray, for: .normal)
        monthlyButton.setTitleColor(UIColor.greenBlue, for: .normal)
        
        weeklyView.alpha = 0
        monthlyView.alpha = 1
        
        requestRankingAPI(type: "monthly")
    }
    
    private func refreshRankingList() {
        // weekly
        tableView.reloadData()
        
        // monthly
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
            return 2
        }
        return count + 2
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
            if let model = ploggingList?.rankData[indexPath.row - 2]  {
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
