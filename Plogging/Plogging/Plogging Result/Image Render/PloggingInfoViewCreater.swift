//
//  PloggingInfoViewCreater.swift
//  Plogging
//
//  Created by 전소영 on 2021/01/07.
//

import UIKit

class PloggingInfoViewCreater {
    let ploggingInfoBaseView = UIImageView()
    let fontSize = DeviceInfo.screenWidth * 0.065
    let iconSize = DeviceInfo.screenWidth * 0.075
    let logoSize = DeviceInfo.screenWidth * 0.25
    
    func createPloggingInfoView(distance: String, trashCount: String) -> UIImageView {
        addPloggingDistanceView(distance)
        addTrashCountView(trashCount)
        addTodayDate()
        addLogo()
        return ploggingInfoBaseView
    }
    
    func addTodayDate() {
        let dateLabel = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = dateFormatter.string(from: Date())
        dateLabel.font = UIFont(name: "SFProDisplay-Black", size: fontSize)
        dateLabel.textColor = UIColor.white
        dateLabel.frame = CGRect(x: 19, y: 24, width: 200, height: fontSize)
        ploggingInfoBaseView.addSubview(dateLabel)
    }
    
    func addPloggingDistanceView(_ ploggingDistance: String) {
        let distanceIconImageView =  UIImageView(image: UIImage(named: "running"))
        distanceIconImageView.frame = CGRect.init(x: 19, y: DeviceInfo.screenWidth * 6/7, width: iconSize, height: iconSize)
        ploggingInfoBaseView.addSubview(distanceIconImageView)
        
        let distanceLabel = UILabel(frame: CGRect(x: 54, y: DeviceInfo.screenWidth * 6/7 + 2, width: 130, height: fontSize))
        distanceLabel.text = ploggingDistance
        distanceLabel.text?.append("km")
        distanceLabel.font = UIFont(name: "SFProDisplay-Black", size: fontSize)
        distanceLabel.textColor = UIColor.white
        ploggingInfoBaseView.addSubview(distanceLabel)
    }
    
    func addTrashCountView(_ trashCount: String) {
        let trashIconImageView =  UIImageView(image: UIImage(named: "trashCan"))
        trashIconImageView.frame = CGRect.init(x: DeviceInfo.screenWidth * 1/3 + 35, y: DeviceInfo.screenWidth * 6/7, width: iconSize, height: iconSize)
        ploggingInfoBaseView.addSubview(trashIconImageView)
        
        let trashLabel = UILabel(frame: CGRect(x: DeviceInfo.screenWidth * 1/3 + 70, y: DeviceInfo.screenWidth * 6/7 + 2, width: 80, height: fontSize))
        trashLabel.text = trashCount
        trashLabel.text?.append("개")
        trashLabel.font = UIFont(name: "SFProDisplay-Black", size: fontSize)
        trashLabel.textColor = UIColor.white
        ploggingInfoBaseView.addSubview(trashLabel)
    }
    
    func addLogo() {
        let logoImageView =  UIImageView(image: UIImage(named: "logo"))
        logoImageView.frame = CGRect.init(x: DeviceInfo.screenWidth * 2/3 + 17, y: DeviceInfo.screenWidth * 2/3 + 10, width: logoSize, height: logoSize)
        ploggingInfoBaseView.addSubview(logoImageView)
    }
}
