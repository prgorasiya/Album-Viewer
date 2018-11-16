//
//  AlbumViewModal.swift
//  Album Viewer
//
//  Created by paras gorasiya on 16/11/18.
//  Copyright © 2018 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit
import Unbox

class AlbumViewModal: NSObject {
    
    var albums: [AlbumModel] = []
    
    func fetchAlbums( complete: @escaping (_ success: Bool, _ photos: [AlbumModel]?)-> Void) {
        DispatchQueue.global().async {
            ApiManager.sharedInstance.getDataWith(URL: "albums", parameters: nil, success: { (responseObject) in
                for case let object in responseObject{
                    let json = object as! Dictionary<String, AnyObject>
                    let albumModel: AlbumModel = try! unbox(dictionary: json)
                    self.albums.append(albumModel)
                }
                complete(true, self.albums)
            }, failure: { (errorCode, errorTitle, errorMessage) in
                complete(false, nil)
            })
        }
    }
}


extension Dictionary {
    func jsonString() -> NSString? {
        let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [])
        guard jsonData != nil else {return nil}
        let jsonString = String(data: jsonData!, encoding: .utf8)
        guard jsonString != nil else {return nil}
        return jsonString! as NSString
    }
    
}
