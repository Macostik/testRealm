//
//  APIRequest.swift
//  BinarySwipe
//
//  Created by Yuriy on 6/16/16.
//  Copyright © 2016 EasternPeak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Header {
    static let data = ["range": "bytes=0-","version": "0.6.5",
    "id": "C05B71A3-6B78-450C-A9B4-C2F62E46C67C",
    "code": "085540135298", "protocol":
    "0.0.1","accept-encoding": "deflate, gzip"]
}

enum MainURL: String {
    case base = "http://217.71.92.66/jra/cv.dev/"
}

func requestHandler(_ function: Any, urlRequest: URLRequestConvertible, completionHandler: @escaping (JSON?) -> Void) {
    Logger.log("\n\t url - \(function)", color: .Yellow)
    Alamofire.request(urlRequest)
        .validate()
        .responseJSON { response in
            var errorDescription = ""
            var errorReason = ""
            if case let .failure(error) = response.result {
                if let error = error as? AFError {
                    switch error {
                    case .invalidURL(let url):
                        errorReason = "Invalid URL: " + "\(url) - \(error.localizedDescription)"
                    case .parameterEncodingFailed(let reason):
                        errorDescription = "Parameter encoding failed: " + "\(error.localizedDescription)"
                        errorReason = "Failure Reason: " + "\(reason)"
                    case .multipartEncodingFailed(let reason):
                        errorDescription = "Multipart encoding failed: " + "\(error.localizedDescription)"
                        errorReason = "Failure Reason: " + "\(reason)"
                    case .responseValidationFailed(let reason):
                        errorDescription = "Response validation failed: " + "\(error.localizedDescription)"
                        errorReason = "Failure Reason: " + "\(reason)"
                        
                        switch reason {
                        case .dataFileNil, .dataFileReadFailed:
                            errorDescription = "Downloaded file could not be read"
                        case .missingContentType(let acceptableContentTypes):
                            errorDescription = "Content Type Missing: " + "\(acceptableContentTypes)"
                        case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                            errorDescription = "Response content type: " + "\(responseContentType) " + "was unacceptable: " + "\(acceptableContentTypes)"
                        case .unacceptableStatusCode(let code):
                            errorDescription = "Response status code was unacceptable: " + "\(code)"
                        }
                    case .responseSerializationFailed(let reason):
                        errorDescription = "Response serialization failed: " + "\(error.localizedDescription)"
                        errorReason = "Failure Reason: " + "\(reason)"
                    }
                    
                    errorDescription =  "Underlying error: " + "\(error.underlyingError)"
                } else if let error = error as? URLError {
                    errorDescription = "URLError occurred: " + "\(error)"
                } else {
                    errorDescription = "Unknown error: " + "\(error)"
                }
                Logger.log("\tAPI called function - \(function)\n\t" + errorDescription + errorReason, color: .Red)
                UIAlertController.alert(String(format: errorDescription), message: errorReason).show()
                completionHandler(nil)
            }
            
            if case let .success(value) = response.result {
                let json = JSON(value)
                Logger.log("\tAPI called function - \(function)\n\tRESPONSE - \(json)\n\tTIMELINE - \(response.timeline)", color: .Green)
                completionHandler(json)
            }
    }
}

func performRequest(_ function: Any, urlRequest: URLRequestConvertible, completion: @escaping (JSON?, Bool) -> Void) {
    requestHandler(function, urlRequest: urlRequest ) { json in
        guard json != nil else {
            completion(nil, false)
            return }
        completion(json, true)
    }
}

enum Request: URLRequestConvertible {
    
    typealias T = EntryParametersPresenting
    
    case metaData(T)
    case contentItem(T)
    
    
    func asURLRequest() throws -> URLRequest {
        
        var method: HTTPMethod {
            switch self {
            case .metaData, .contentItem:
                return .get
            }
        }
        
        let headersParam: (HTTPHeaders?) = {
            switch self {
            case .metaData(let newPost):
                return newPost.entryParameters.1
            case .contentItem(let newPost):
                return newPost.entryParameters.1
            }
        }()
        
        let url: URL = {
            var relativePath: String = ""
            switch self {
            case .metaData(let newPost):
                relativePath = (newPost.entryParameters.0?.0 ?? "") + "MetaData"
            case .contentItem(let newPost):
                relativePath = (newPost.entryParameters.0?.0 ?? "") + "ContentItems"
            }

            return Foundation.URL(string: relativePath)!
        }()
        
        let bodyParams: Body? = {
            return nil
        }()
        
        Logger.log("API call\n\t url - \(url)\n\t method - \(method)\n\t headerParams - \(headersParam ?? ["":""])\n\t bodyParam - \(bodyParams?.1 ?? ["":""])", color: .Yellow)
        
        return Alamofire.request(url, method: method, parameters: bodyParams?.parameters,
                                 encoding: JSONEncoding.default, headers: headersParam).request!
    }
    
    static func getMetaData(_ entry: T, completion: @escaping (JSON?, Bool) -> Void) {
        performRequest(#function, urlRequest: metaData(entry), completion: completion)
    }
    
    static func getContentItem(_ entry: T, completion: @escaping (JSON?, Bool) -> Void) {
        performRequest(#function, urlRequest: contentItem(entry), completion: completion)
    }
}
