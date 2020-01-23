//
//  ServiceManager.swift
//  PhotosProject
//
//  Created by Yusuf ali cezik on 21.01.2020.
//  Copyright © 2020 Yusuf Ali Cezik. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ApiResult<Value, RequestError> {
    case success(Value)
    case failure(RequestError)
    
    init(value: Value){
        self = .success(value)
    }
    
    init(error: RequestError){
        self = .failure(error)
    }
}

enum RequestError: Error {
    case unknownError
    case connectionError
    case invalidRequest
    case notFound
    case serverError
}

class ServiceManager {
    
    static let shared = ServiceManager()
    
    private init(){}
    
    func loadData<T: Decodable>(url:String, type: T.Type) -> Observable<ApiResult<T, RequestError>> {
        return Observable.from([url])
        .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
            let request = URLRequest(url: URL(string: url)!)
            return URLSession.shared.rx.response(request: request)
        }.map { response, data -> ApiResult<T, RequestError> in
            switch response.statusCode {
            case 200:
                let mData = try JSONDecoder().decode(type, from: data)
                return ApiResult(value: mData)
            case 404:
                return ApiResult(error: .notFound)
            case 400:
                return ApiResult(error: .invalidRequest)
            case 500:
                return ApiResult(error: .serverError)
            default:
                return ApiResult(error: .unknownError)
                //throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
            }
        }.asObservable() 
    }
}

