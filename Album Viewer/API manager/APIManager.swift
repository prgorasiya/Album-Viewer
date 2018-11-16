//
//  APIManager.swift
//  Album Viewer
//
//  Created by paras gorasiya on 16/11/18.
//  Copyright © 2018 paras gorasiya. All rights reserved.
//

import Foundation
import Alamofire


@objc class ApiManager : NSObject {
    
    var manager: SessionManager!
    
    @objc static let sharedInstance: ApiManager = {
        let instance = ApiManager()
        return instance
    }()
    
    
    override init() {
        super.init()
        self.manager = getAlamofireManagerInstance()
    }
    
    
    func getAlamofireManagerInstance() -> SessionManager {
        return Alamofire.SessionManager(configuration: URLSessionConfiguration.default, serverTrustPolicyManager: nil)
    }
    
    
    func baseURL() -> String{
        return String("https://jsonplaceholder.typicode.com")
    }
    
    
    func getWebServiceUrl(serviceName: String) -> String{
        return String(format: "%@/%@", baseURL(), serviceName)
    }
    
    
    @objc func getDataWith(URL: String, parameters: [String: Any]?, success successBlock: @escaping (([Any]) -> Void), failure failureBlock: @escaping ((Int, String?, String?) -> Void)) {
        
        var url = URL
        
        if !URL.hasPrefix("http") {
            url = getWebServiceUrl(serviceName: URL)
        }
        
        self.manager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success(_):
                if let json = response.result.value {
                    successBlock(json as! [Any])
                }
                else{
                    successBlock(response.result.value as! [Any])
                }
            case .failure(let error):
                debugPrint("getEvents error: \(error)")
                if ((response.response?.statusCode) != nil) {
                    failureBlock((response.response?.statusCode)!, nil, nil)
                }
                else{
                    failureBlock(0, nil, nil)
                }
            }
            }.responseString { response in
                //                print("Success: \(response.result.isSuccess)")
                //                print("Response String: \(response.result.value)")
        }
    }
}




