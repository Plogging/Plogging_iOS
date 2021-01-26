//
//  PloggingInfoViewCreater.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/07.
//

import UIKit

class PloggingInfoViewCreater {
    let ploggingInfoBaseView = UIImageView()
    
    func createFloggingInfoView(_ distance: Double, _ time: String) -> UIImageView {
        addPloggingDistanceView(distance)
        addPloggingTimeView(time)
        addTodayDate()
        return ploggingInfoBaseView
    }
    
    func addTodayDate() {
        let dateLabel = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.font = UIFont(name: "SFProDisplay-Black", size: 23)
        dateLabel.textColor = UIColor.white
        dateLabel.frame = CGRect(x: 28, y: 24, width: 152, height: 31)
        ploggingInfoBaseView.addSubview(dateLabel)
    }
    
    func addPloggingDistanceView(_ ploggingDistance: Double) {
        let distanceIconImageView =  UIImageView(image: UIImage(named: "running"))
        distanceIconImageView.frame = CGRect.init(x: 22, y: DeviceScreen.width * 6/7, width: 32, height: 32)
        ploggingInfoBaseView.addSubview(distanceIconImageView)
        
        let distanceLabel = UILabel(frame: CGRect(x: 57, y: DeviceScreen.width * 6/7, width: 100, height: 32))
        distanceLabel.text = String(ploggingDistance)
        distanceLabel.text?.append("km")
        distanceLabel.font = UIFont(name: "SFProDisplay-Black", size: 23)
        distanceLabel.textColor = UIColor.white
        ploggingInfoBaseView.addSubview(distanceLabel)
    }
    
    func addPloggingTimeView(_ ploggingTime: String) {
        let timerIconImageView =  UIImageView(image: UIImage(named: "trash"))
        timerIconImageView.frame = CGRect.init(x: DeviceScreen.width * 1/3 + 22, y: DeviceScreen.width * 6/7, width: 32, height: 32)
        ploggingInfoBaseView.addSubview(timerIconImageView)
        
        let timeLabel = UILabel(frame: CGRect(x: DeviceScreen.width * 1/3 + 57, y: DeviceScreen.width * 6/7, width: 100, height: 32))
        timeLabel.text = ploggingTime
        timeLabel.font = UIFont(name: "SFProDisplay-Black", size: 23)
        timeLabel.textColor = UIColor.white
        ploggingInfoBaseView.addSubview(timeLabel)
    }
}
