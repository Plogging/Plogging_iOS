//
//  Protocol+NibLodable.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/06.
//

import UIKit

protocol NibLoadable: AnyObject {
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
