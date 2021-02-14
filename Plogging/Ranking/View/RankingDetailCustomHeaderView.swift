//
//  RankingDetailCustomHeaderView.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/14.
//

import UIKit

class CustomHeaderView: UIView {

    var imageView:UIImageView!
    let defaultView = UIView()
    let notDefaultView = UIView()

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
        
        let imageViewConstraints:[NSLayoutConstraint] = [
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        NSLayoutConstraint.activate(imageViewConstraints)
        
        imageView.image = UIImage(named: "header")
        imageView.contentMode = .scaleAspectFill
        
        defaultHeaderUI()
        notDefaultHeaderUI()
    }
    
    func defaultHeaderUI() {
        defaultView.translatesAutoresizingMaskIntoConstraints = false
        defaultView.backgroundColor = .clear
        self.addSubview(defaultView)

        let defaultViewConstraints:[NSLayoutConstraint] = [
            defaultView.topAnchor.constraint(equalTo: self.topAnchor),
            defaultView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            defaultView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        NSLayoutConstraint.activate(defaultViewConstraints)
        
        // 뒤로가기 버튼
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        defaultView.addSubview(backButton)
        let backButtonConstraints:[NSLayoutConstraint] = [
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 63),
        ]
        NSLayoutConstraint.activate(backButtonConstraints)
        backButton.setImage(UIImage(named: "buttonBack"), for: .normal)
        
        // 유저 닉네임
        let nickNameLabel = UILabel()
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        defaultView.addSubview(nickNameLabel)
        
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
        let userIcon = UIImageView()
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        defaultView.addSubview(userIcon)
        
        let imageConstraints:[NSLayoutConstraint] = [
            userIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            userIcon.topAnchor.constraint(equalTo: topAnchor, constant: 78),
            userIcon.widthAnchor.constraint(equalToConstant: 74),
            userIcon.heightAnchor.constraint(equalToConstant: 74)
        ]
        NSLayoutConstraint.activate(imageConstraints)
        userIcon.image = UIImage(named: "ranking")
    }
    
    func notDefaultHeaderUI() {
        notDefaultView.alpha = 0
        notDefaultView.translatesAutoresizingMaskIntoConstraints = false
        notDefaultView.backgroundColor = .clear
        self.addSubview(notDefaultView)

        let notDefaultViewViewConstraints:[NSLayoutConstraint] = [
            notDefaultView.topAnchor.constraint(equalTo: self.topAnchor),
            notDefaultView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            notDefaultView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            notDefaultView.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(notDefaultViewViewConstraints)
        
        // 뒤로가기 버튼
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        notDefaultView.addSubview(backButton)
        let backButtonConstraints:[NSLayoutConstraint] = [
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 63),
        ]
        NSLayoutConstraint.activate(backButtonConstraints)
        backButton.setImage(UIImage(named: "buttonBack"), for: .normal)
        
        // 유저 닉네임
        let nickNameLabel = UILabel()
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        notDefaultView.addSubview(nickNameLabel)
        
        let nickNameConstraints:[NSLayoutConstraint] = [
            nickNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 43),
            nickNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
        ]
        NSLayoutConstraint.activate(nickNameConstraints)
        nickNameLabel.text = "나는혜리💙"
        nickNameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 26)
        nickNameLabel.textColor = .white
        nickNameLabel.textAlignment = .left
        
        // 유저 아이콘
        let userIcon = UIImageView()
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        notDefaultView.addSubview(userIcon)
        
        let imageConstraints:[NSLayoutConstraint] = [
            userIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            userIcon.topAnchor.constraint(equalTo: topAnchor, constant: 78),
            userIcon.widthAnchor.constraint(equalToConstant: 48),
            userIcon.heightAnchor.constraint(equalToConstant: 48)
        ]
        NSLayoutConstraint.activate(imageConstraints)
        userIcon.image = UIImage(named: "ranking")
    }
    
    func decrementDefualtAlpha(offset: CGFloat) {
        if self.defaultView.alpha >= 0 {
            let alphaOffset = max((offset - 65)/85.0, 0)
            self.defaultView.alpha = alphaOffset
        }
        if defaultView.alpha == 0 {
            self.notDefaultView.alpha = 1
        }
    }

    func incrementDefaultAlpha(offset: CGFloat) {
        if self.defaultView.alpha <= 1 {
            let alphaOffset = max((offset - 65)/85, 0)
            self.defaultView.alpha = alphaOffset
        }
        if defaultView.alpha >= 0.2 {
            self.notDefaultView.alpha = 0
        }
    }
}
