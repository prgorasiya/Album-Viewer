//
//  AlbumTableViewController.swift
//  Album Viewer
//
//  Created by paras gorasiya on 16/11/18.
//  Copyright © 2018 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit
import MKProgress

class AlbumTableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var currentPage = 1
    var lastPage = 1
    
    lazy var albumViewModal: AlbumViewModal = {
        return AlbumViewModal()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        MKProgress.show()
        getAlbumDataFor(page: currentPage)
    }
    
    
    func initView() {
        self.navigationItem.title = "Albums"
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 150
    }
    
    
    func getAlbumDataFor(page: Int) {
        albumViewModal.fetchAlbums(page: page, limit: 20) { (status, albums) in
            DispatchQueue.main.async {
                MKProgress.hide()
                if status == true{
                    if albums?.count == 0{
                        self.currentPage = self.lastPage
                    }
                    else{
                        self.lastPage += 1
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}


extension AlbumTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumViewModal.albums.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumTableViewCell else {
            fatalError("Cell does not exists in storyboard")
        }
        
        let album = albumViewModal.albums[indexPath.row]
        cell.updateCellFor(data: album)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            if currentPage != lastPage {
                currentPage += 1
                self.getAlbumDataFor(page: currentPage)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedAlbum = albumViewModal.albums[indexPath.row]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PhotoCollectionViewControllerID") as! PhotosCollectionViewController
        nextViewController.album = selectedAlbum
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
}
