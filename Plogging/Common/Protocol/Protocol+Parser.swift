//
//  Protocol+Parser.swift
//  Plogging
//
//  Created by 전소영 on 2021/02/14.
//

import Foundation

protocol Parser {
    func parseList<T>(from data: Data) -> [T]
    func getEndPageNumber(from data: Data) -> Int
}
