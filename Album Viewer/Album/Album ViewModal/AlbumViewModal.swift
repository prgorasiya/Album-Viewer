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
    
    func fetchAlbums(page: Int?, limit: Int?, complete: @escaping (_ success: Bool, _ albums: [AlbumModel]?)-> Void) {
        DispatchQueue.global().async {
            let currentPage = page != nil ? page : 0
            let currentLimit = limit != nil ? limit : 20
            ApiManager.sharedInstance.getDataWith(URL: String(format: MyAPI.kService_Get_Albums, currentPage!, currentLimit!), parameters: nil, success: { (responseObject) in
                var mappedAlbums = [AlbumModel]()
                for case let object in responseObject{
                    let json = object as! Dictionary<String, AnyObject>
                    let albumModel: AlbumModel = try! unbox(dictionary: json)
                    mappedAlbums.append(albumModel)
                }
                if mappedAlbums.count > 0 {
                    self.albums.append(contentsOf: mappedAlbums)
                }
                complete(true, mappedAlbums)
            }, failure: { (errorCode, errorTitle, errorMessage) in
                complete(false, nil)
            })
        }
    }
}
