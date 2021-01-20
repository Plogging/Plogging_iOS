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
        return ploggingInfoBaseView
    }
    
    func addPloggingDistanceView(_ ploggingDistance: Double) {
        let distanceIconImageView =  UIImageView(image: UIImage(named: "running"))
        distanceIconImageView.frame = CGRect.init(x: DeviceScreen.width * 1/4, y: DeviceScreen.width * 2/4, width: 50, height: 50)
        ploggingInfoBaseView.addSubview(distanceIconImageView)
        
        let distanceLabel = UILabel(frame: CGRect(x: DeviceScreen.width * 1/4, y: DeviceScreen.width * 2/4 + 50, width: 150, height: 25))
        distanceLabel.text = String(ploggingDistance)
        distanceLabel.text?.append("Km")
        distanceLabel.font = distanceLabel.font.withSize(25)
        ploggingInfoBaseView.addSubview(distanceLabel)
    }
    
    func addPloggingTimeView(_ ploggingTime: String) {
        let timerIconImageView =  UIImageView(image: UIImage(named: "timer"))
        timerIconImageView.frame = CGRect.init(x: DeviceScreen.width * 2/4, y: DeviceScreen.width * 2/4, width: 50, height: 50)
        ploggingInfoBaseView.addSubview(timerIconImageView)
        
        let timeLabel = UILabel(frame: CGRect(x: DeviceScreen.width * 2/4, y: DeviceScreen.width * 2/4 + 50, width: 150, height: 25))
        timeLabel.text = ploggingTime
        timeLabel.font = timeLabel.font.withSize(25)
        ploggingInfoBaseView.addSubview(timeLabel)
    }
}
