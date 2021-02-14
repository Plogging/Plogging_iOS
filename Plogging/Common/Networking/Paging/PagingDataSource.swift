//
//  PagingDataSource.swift
//  Plogging
//
//  Created by 전소영 on 2021/02/13.
//

import Foundation
import Alamofire

struct PagingAPI {
    var url: String
    var params: [String : Any]
    var header: HTTPHeaders
}

enum PagingDataType<T> {
    case mypage
    case ranking
    
    func createParser() -> Parser {
        switch self {
        case .mypage:
            return PloggingParser<T>.init()
        case .ranking:
            //랭킹 Parser로 변경
            return PloggingParser<T>.init()
        }
    }
}

class PagingDataSource<T> {
    var api: PagingAPI
    var isLastPage = false
    var isLoading = false
    
    private(set) var pageNumber = 1
    private(set) var contents: [T] = []
    
    var parser: Parser
    
    init(api: PagingAPI, type: PagingDataType<T>) {
        self.api = api
        self.parser = type.createParser()
    }
    
    private func request(_ completion: @escaping (() -> Void)) {
        var params = self.api.params
        params["pageNumber"] = self.pageNumber
        
        isLoading = true
        AF.request(api.url,
                   method: .get,
                   parameters: params,
                   headers: api.header
        ).responseJSON { [self] (response) in
            print("response: \(response)")
            isLoading = false
            guard let data = response.data else {
                completion()
                return
            }
            let loadedContents: [T] = parser.parseList(from: data)
            let endPageNumber: Int = parser.getEndPageNumber(from: data)

            self.contents.append(contentsOf: loadedContents)
            
            if self.pageNumber < endPageNumber {
                self.pageNumber += 1
            } else {
                self.isLastPage = true
            }
            completion()
        }
    }
    
    func loadFromFirst(completion: @escaping (() -> Void)) {
        request(completion)
    }
    
    func loadNext(completion: @escaping (() -> Void)) {
        guard isNextLoadable() else {
            return
        }
        request(completion)
    }
    
    func isNextLoadable() -> Bool {
        return !isLastPage && !isLoading
    }
}
