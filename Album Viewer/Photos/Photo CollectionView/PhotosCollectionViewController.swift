//
//  PhotosCollectionViewController.swift
//  Album Viewer
//
//  Created by paras gorasiya on 16/11/18.
//  Copyright © 2018 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit
import MKProgress
import SKPhotoBrowser

class PhotosCollectionViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var album: AlbumModel!
    var currentPage = 1
    var lastPage = 1
    var images = [SKPhoto]()
    
    lazy var photoViewModal: PhotoViewModal = {
        return PhotoViewModal()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        getPhotosDataFor(albumId: album.id!, page: 1)
    }
    
    
    func initView() {
        self.navigationItem.title = album.title
    }
    
    
    func getPhotosDataFor(albumId: Int, page: Int) {
        photoViewModal.fetchPhotos(album: albumId, page: page, limit: 20) { (status, photos) in
            DispatchQueue.main.async {
                MKProgress.hide()
                if status == true{
                    if photos?.count == 0{
                        self.currentPage = self.lastPage
                    }
                    else{
                        self.lastPage += 1
                        self.createPhotoArrayForPhotoBrowser(photos: photos!)
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    func createPhotoArrayForPhotoBrowser(photos: [PhotoModel]) {
        for case let object in photos {
            let photo = SKPhoto.photoWithImageURL(object.url!)
            photo.shouldCachePhotoURLImage = true
            photo.caption = object.title
            images.append(photo)
        }
    }
    
    
    func configurePhotoBrowserOptions() {
        SKPhotoBrowserOptions.displayStatusbar = false
        SKPhotoBrowserOptions.displayDeleteButton = false
        SKPhotoBrowserOptions.displayCounterLabel = false
        SKPhotoBrowserOptions.displayBackAndForwardButton = false
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayHorizontalScrollIndicator = false
        SKPhotoBrowserOptions.displayVerticalScrollIndicator = false
        SKCaptionOptions.captionLocation = .bottom
    }
}


extension PhotosCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoViewModal.photos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("Cell does not exists in storyboard")
        }
        
        let photo = photoViewModal.photos[indexPath.item]
        cell.updateCellFor(data: photo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! PhotoCollectionViewCell
        let originImage = cell.imageView.image
        
        self.configurePhotoBrowserOptions()
        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: cell)
        browser.initializePageIndex(indexPath.row)
        present(browser, animated: true, completion: {})
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: DeviceSize.deviceWidth/2-2, height: DeviceSize.deviceWidth/2-3)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastRowIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            if currentPage != lastPage {
                currentPage += 1
                self.getPhotosDataFor(albumId: self.album.id!, page: currentPage)
            }
        }
    }
}
