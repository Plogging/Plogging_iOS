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
                self.refresh.endRefreshing()
            }
        }
    }
    private var userPloggingRankig: RankingUser? {
        didSet{
            DispatchQueue.main.async {
                let indexPathRow = 0
                let indexPosition = IndexPath(row: indexPathRow, section: 0)
                self.tableView.reloadRows(at: [indexPosition], with: .none)
                self.refresh.endRefreshing()
            }
        }
    }
    var refresh: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarClear()
        setupTableView()
        setupRankingTitle()
        createRefreshControl()
        requestBothRankingAPI()
    }
    
    private func requestBothRankingAPI() {
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
        // TODO: - id는 저장된 유저 정보
        let param: [String: Any] = ["rankType": type]

        APICollection.sharedAPI.requestUserRanking(id: "hyer1k@naver.com:custom", param: param) { (response) in
            self.userPloggingRankig = try? response.get()
        }
    }
    
    private func setupRankingTitle() {
        let rankingTitleString = NSMutableAttributedString()
            .heavy("연쇄쓰담마", fontSize: 35)
            .medium("님의", fontSize: 35)
            .newLine(fontSize: 35)
            .medium("랭킹을 확인하세요!", fontSize: 35)
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
        tableView.estimatedRowHeight = 28
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 68, right: 0)
        tableView.contentInset = inset
    }
    
    private func createRefreshControl() {
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateRanking), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    @objc private func updateRanking() {
        requestBothRankingAPI()
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
        // weekly, monthly enum화
        if weeklyView.alpha == 1 {
            requestRankingAPI(type: "weekly")
            requestUserRanking(type: "weekly")
        } else {
            requestRankingAPI(type: "monthly")
            requestUserRanking(type: "monthly")
        }
    }
}

extension RankingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 1 else { return }
        
        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
        if let mypage = storyboard.instantiateViewController(identifier: "MyPage") as? MyPageViewController {
            mypage.type = .ranking
            self.navigationController?.pushViewController(mypage, animated: true)
        }
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
            if let model = userPloggingRankig?.data {
                cell.config(model: model)
            }
            return cell
        } else if indexPath.row == 1 {
            let cell: RankingRefreshTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        } else {
            let cell: RankingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            if let model = ploggingRankingList?.data[indexPath.row - 2]  {
                cell.config(model, index: indexPath)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 132
        } else if indexPath.row == 1 {
            return 28
        } else {
            return 95
        }
    }
}

extension RankingViewController: RefreshCellDelegate {
    func refreshButtonCall() {
        refreshRankingList()
    }
}
