//
//  AlbumModel.swift
//  Album Viewer
//
//  Created by paras gorasiya on 16/11/18.
//  Copyright © 2018 paras gorasiya. All rights reserved.
//

import Foundation
import Unbox

struct AlbumModel {
    let id: String?
    let userId: String?
    let title: String?
}


extension AlbumModel: Unboxable {
    init(unboxer: Unboxer) throws {
        id = unboxer.unbox(key: "id")
        userId = unboxer.unbox(key: "userId")
        title = unboxer.unbox(keyPath: "title")
    }
}
