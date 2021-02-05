//
//  Protocol+ReusableCell.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/06.
//

import UIKit

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
