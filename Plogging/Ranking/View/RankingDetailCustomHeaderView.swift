//
//  RankingDetailCustomHeaderView.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/14.
//

import UIKit

class CustomHeaderView: UIView {

    var imageView:UIImageView!
    var userIcon:UIImageView!
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    func setUpUserData() {
        
    }
    
    func setUpView() {
        self.backgroundColor = .clear
        // 배경 이미지 설정
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        let constraints:[NSLayoutConstraint] = [
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
        imageView.image = UIImage(named: "header")
        imageView.contentMode = .scaleAspectFill

        // 뒤로가기 버튼
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backButton)
        let backButtonConstraints:[NSLayoutConstraint] = [
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 63),
        ]
        NSLayoutConstraint.activate(backButtonConstraints)
        backButton.setImage(UIImage(named: "buttonBack"), for: .normal)
        
        // 유저 닉네임
        let nickNameLabel = UILabel()
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nickNameLabel)
        
        let nickNameConstraints:[NSLayoutConstraint] = [
            nickNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            nickNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 109),
        ]
        NSLayoutConstraint.activate(nickNameConstraints)
        nickNameLabel.text = "나는혜리💙"
        nickNameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 35)
        nickNameLabel.textColor = .white
        nickNameLabel.textAlignment = .left
        
        // 유저 아이콘
        userIcon = UIImageView()
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userIcon)
        
        let imageConstraints:[NSLayoutConstraint] = [
            userIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            userIcon.topAnchor.constraint(equalTo: topAnchor, constant: 78),
            userIcon.widthAnchor.constraint(equalToConstant: 74),
            userIcon.heightAnchor.constraint(equalToConstant: 74)
        ]
        NSLayoutConstraint.activate(imageConstraints)
        userIcon.image = UIImage(named: "ranking")
    }
    
    func createStackView() {
        
    }
    
    func decrementColorAlpha(offset: CGFloat) {
//        if self.colorView.alpha <= 1 {
//            let alphaOffset = (offset/500)/85
//            self.colorView.alpha += alphaOffset
//        }
    }
    
    func decrementAlpha(offset: CGFloat) {
        if self.userIcon.alpha >= 0 {
            let alphaOffset = max((offset - 65)/85.0, 0)
            self.userIcon.alpha = alphaOffset
        }
    }
    
    func incrementColorAlpha(offset: CGFloat) {
//        if self.colorView.alpha >= 0.6 {
//            let alphaOffset = (offset/200)/85
//            self.colorView.alpha -= alphaOffset
//        }
    }
    
    func incrementAlpha(offset: CGFloat) {
        if self.userIcon.alpha <= 1 {
            let alphaOffset = max((offset - 65)/85, 0)
            self.userIcon.alpha = alphaOffset
        }
    }
}
