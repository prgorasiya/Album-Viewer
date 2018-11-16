//
//  PhotoViewModal.swift
//  Album Viewer
//
//  Created by paras gorasiya on 16/11/18.
//  Copyright © 2018 paras gorasiya. All rights reserved.
//

import Foundation
import Unbox

class PhotoViewModal: NSObject {
    
    var photos: [PhotoModel] = []
    
    func fetchPhotos(album: Int, page: Int?, limit: Int?, complete: @escaping (_ success: Bool, _ photos: [PhotoModel]?)-> Void) {
        DispatchQueue.global().async {
            let currentPage = page != nil ? page : 0
            let currentLimit = limit != nil ? limit : 20
            ApiManager.sharedInstance.getDataWith(URL: String(format: MyAPI.kService_Get_Photos, album, currentPage!, currentLimit!), parameters: nil, success: { (responseObject) in
                var mappedPhotos = [PhotoModel]()
                for case let object in responseObject{
                    let json = object as! Dictionary<String, AnyObject>
                    let photoModel: PhotoModel = try! unbox(dictionary: json)
                    mappedPhotos.append(photoModel)
                }
                if mappedPhotos.count > 0 {
                    self.photos.append(contentsOf: mappedPhotos)
                }
                complete(true, mappedPhotos)
            }, failure: { (errorCode, errorTitle, errorMessage) in
                complete(false, nil)
            })
        }
    }
}
