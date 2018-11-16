//
//  AlbumTableViewCell.swift
//  Album Viewer
//
//  Created by paras gorasiya on 16/11/18.
//  Copyright © 2018 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    
    var model: AlbumModel?
    
    func updateCellFor(data: AlbumModel) {
        self.model = data
        self.lblTitle.text = data.title
    }
}
