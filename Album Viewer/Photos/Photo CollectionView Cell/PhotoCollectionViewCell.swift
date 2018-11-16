//
//  PhotoCollectionViewCell.swift
//  Album Viewer
//
//  Created by paras gorasiya on 16/11/18.
//  Copyright © 2018 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    var model: PhotoModel?
    
    func updateCellFor(data: PhotoModel) {
        self.model = data
        self.imageView.image = UIImage().coloredImage(color: .darkGray)
        self.imageView.loadImageUsingCache(withUrl: data.thumbnailUrl)
    }
}
