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
    
    private var ploggingRankingList: RankingGlobal? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var userPloggingRankig: RankingUser? {
        didSet{
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
        requestUserRanking(type: "weekly")
    }
    
    private func requestRankingAPI(type: String) {
        let param: [String: Any] = ["rankType": type,
                                    "rankCntPerPage": 10,
                                    "pageNumber": 1]
        
        APICollection.sharedAPI.requestGlobalRanking(param: param) { (response) in
            self.ploggingRankingList = try? response.get()
        }
    }
    
    private func requestUserRanking(type: String) {
        let param: [String: Any] = ["rankType": type]
        
        APICollection.sharedAPI.requestUserRanking(param: param) { (response) in
            self.userPloggingRankig = try? response.get()
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
        tableView.register(RankingTableViewCell.self)
        tableView.register(MyRankingTableViewCell.self)
        tableView.register(RankingRefreshTableViewCell.self)
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
        guard let count = ploggingRankingList?.data.count else {
            return 2
        }
        return count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: MyRankingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        } else if indexPath.row == 1 {
            let cell: RankingRefreshTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        } else {
            let cell: RankingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            if let model = ploggingRankingList?.data[indexPath.row - 2]  {
                cell.config(model, index: indexPath)
            }
            return cell
        }
    }
}
