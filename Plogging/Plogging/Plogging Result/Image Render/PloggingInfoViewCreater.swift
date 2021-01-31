//
//  PloggingInfoViewCreater.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/07.
//

import UIKit

class PloggingInfoViewCreater {
    let ploggingInfoBaseView = UIImageView()
    
    func createFloggingInfoView(_ distance: String, _ trashCount: String) -> UIImageView {
        addPloggingDistanceView(distance)
        addTrashCountView(trashCount)
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
    
    func addPloggingDistanceView(_ ploggingDistance: String) {
        let distanceIconImageView =  UIImageView(image: UIImage(named: "running"))
        distanceIconImageView.frame = CGRect.init(x: 22, y: DeviceInfo.screenWidth * 6/7, width: 32, height: 32)
        ploggingInfoBaseView.addSubview(distanceIconImageView)
        
        let distanceLabel = UILabel(frame: CGRect(x: 57, y: DeviceInfo.screenWidth * 6/7, width: 100, height: 32))
        distanceLabel.text = ploggingDistance
        distanceLabel.text?.append("km")
        distanceLabel.font = UIFont(name: "SFProDisplay-Black", size: 23)
        distanceLabel.textColor = UIColor.white
        ploggingInfoBaseView.addSubview(distanceLabel)
    }
    
    func addTrashCountView(_ trashCount: String) {
        let trashIconImageView =  UIImageView(image: UIImage(named: "trash"))
        trashIconImageView.frame = CGRect.init(x: DeviceInfo.screenWidth * 1/3 + 22, y: DeviceInfo.screenWidth * 6/7, width: 32, height: 32)
        ploggingInfoBaseView.addSubview(trashIconImageView)
        
        let trashLabel = UILabel(frame: CGRect(x: DeviceInfo.screenWidth * 1/3 + 57, y: DeviceInfo.screenWidth * 6/7, width: 100, height: 32))
        trashLabel.text = trashCount
        trashLabel.font = UIFont(name: "SFProDisplay-Black", size: 23)
        trashLabel.textColor = UIColor.white
        ploggingInfoBaseView.addSubview(trashLabel)
    }
}
