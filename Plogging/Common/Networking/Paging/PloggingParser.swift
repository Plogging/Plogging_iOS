//
//  PloggingParser.swift
//  Plogging
//
//  Created by 전소영 on 2021/02/15.
//

import Foundation

class PloggingParser<T>: Parser {
    func parseList<T>(from data: Data) -> [T] {
        guard let value = try? JSONDecoder().decode(PloggingInfo.self, from: data),
              let loadedContents = value.ploggingList as? [T] else {
            return []
        }
        return loadedContents
    }
    
    func getEndPageNumber(from data: Data) -> Int {
        guard let value = try? JSONDecoder().decode(PloggingInfo.self, from: data) else {
            return 0
        }
        let endPageNumber = value.meta.endPageNumber
        return endPageNumber
    }
}
