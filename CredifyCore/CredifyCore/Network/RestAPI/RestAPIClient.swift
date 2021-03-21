//
//  RestAPIClient.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//

import Foundation
import RxSwift

struct RestAPIClient {
    private static let baseURL = URL(string: CoreService.shared.environment?.REST_URL ?? "")!
    private static let AUTH_ERROR_LIMIT = 7
    private static var authErrorCount = 0
    
    static func reset() {
        authErrorCount = 0
    }
    
    static func send<Response: Codable>(apiRequest: RestAPIRequest) -> Observable<Response> {
        return Observable<Response>.create { observer in
            var ep = URL(string: (CCUserDefaultsUtil.debugRest ?? CoreService.shared.environment?.REST_URL) ?? "") ?? RestAPIClient.baseURL
            //TODO: just hard code, we need separate 2 RestAPIClient for Call external API
            if let _ = apiRequest as? GetCredifyIdFromProviderRequest {
                ep = URL(string: "https://dev-demo-api.credify.one/sendo/create") ?? RestAPIClient.baseURL
            }
            let request = apiRequest.request(with: ep)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let e = error {
                    observer.onError(e)
                    observer.onCompleted()
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == -1001  {
                        observer.onError(CCError.requestTimeOut)
                        observer.onCompleted()
                    } else if httpResponse.statusCode == 404 {
                        observer.onError(CCError.accountNotFound)
                        observer.onCompleted()
                    } else if httpResponse.statusCode == 401 {
                        print("[\(apiRequest.path)] Got 401 Error: should request a new access token")
                    } else if httpResponse.statusCode >= 300 {
                        let dict = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String : Any]
                        print("[\(response?.url)]===[\(#function)]===[dict]: \(dict)")
                        let message = (dict?["code"] as? String) ?? "\(httpResponse.statusCode) Error"
                        observer.onError(CCError.serverError(message: message))
                        observer.onCompleted()
                    } else {
                        do {
                            let dict = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String : Any]
                            print("[\(#file)]===[\(#function)]===[dict]: \(dict)")
                            
                            print(httpResponse.allHeaderFields["tracer"])
                            let model: Response = try JSONDecoder().decode(Response.self, from: data ?? Data())
                            observer.onNext(model)
                            observer.onCompleted()
                        } catch let e {
                            let dict = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String : Any]
                            print("[\(#file)]===[\(#function)]===[serialize error]: \(dict)")
                            observer.onError(e)
                            observer.onCompleted()
                        }
                    }
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    static func dowload(downloadUrl: URL) -> Observable<Data> {
        return Observable<Data>.create { observer in
            let task = URLSession.shared.dataTask(with: downloadUrl) { data, response, err in
                if let data = data, err == nil {
                    observer.onNext(data)
                    observer.onCompleted()
                }else {
                    DispatchQueue.main.async {
                        debugPrint("Error while downloading document from url=\(downloadUrl.absoluteString): \(err.debugDescription)")
                        observer.onError(err!)
                        observer.onCompleted()
                    }
                }
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
