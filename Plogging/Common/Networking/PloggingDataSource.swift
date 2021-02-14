//
//  PloggingDataSource.swift
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

class PloggingDataSource<T> {
    var api: PagingAPI
    var countPerPage: Int
    var isLoadable = true
    
    private(set) var pageNumber: Int = 1
    private(set) var contents: [T] = []
    
    init(api: PagingAPI, countPerPage: Int) {
        self.api = api
        self.countPerPage = countPerPage
    }
    
    private func request(_ completion: @escaping (() -> Void)) {
        var params = self.api.params
        params["ploggingCntPerPage"] = countPerPage
        params["pageNumber"] = self.pageNumber
        
        AF.request(api.url,
                   method: .get,
                   parameters: params,
                   headers: api.header
        ).responseJSON { [self] (response) in
            print("response: \(response)")
            guard let data = response.data else {
                completion()
                return
            }
            print(String.init(data: data, encoding: .utf8))
            guard let value = try? JSONDecoder().decode(PloggingInfo.self, from: data) else {
                completion()
                return
            }
            let endPageNumber = value.meta.endPageNumber
            guard let loadedContents = value.ploggingList as? [T] else {
                completion()
                return
            }
            self.contents.append(contentsOf: loadedContents)
            if self.pageNumber < endPageNumber {
                completion()
                self.pageNumber += 1
            } else {
                if isLoadable == true {
                    completion()
                }
                self.isLoadable = false
            }
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
        return isLoadable
    }
    
}
