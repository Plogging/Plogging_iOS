//
//  SNSLoginData.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/07.
//

import Foundation

enum SNSType: String {
    case naver
    case kakao
    case apple
}

class SNSLoginData {
    var type: String = ""
    var userId: String = ""
    var userName: String = ""
}
