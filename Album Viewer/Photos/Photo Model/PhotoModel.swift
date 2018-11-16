//
//  PhotoModel.swift
//  Album Viewer
//
//  Created by paras gorasiya on 16/11/18.
//  Copyright © 2018 paras gorasiya. All rights reserved.
//

import Foundation
import Unbox

struct PhotoModel {
    let albumId: String?
    let id: String?
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}


extension PhotoModel: Unboxable {
    init(unboxer: Unboxer) throws {
        albumId = unboxer.unbox(key: "albumId")
        id = unboxer.unbox(key: "id")
        title = unboxer.unbox(keyPath: "title")
        url = unboxer.unbox(key: "url")
        thumbnailUrl = unboxer.unbox(key: "thumbnailUrl")
    }
}
