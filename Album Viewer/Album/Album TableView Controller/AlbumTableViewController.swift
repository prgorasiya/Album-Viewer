//
//  AlbumTableViewController.swift
//  Album Viewer
//
//  Created by paras gorasiya on 16/11/18.
//  Copyright © 2018 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit

class AlbumTableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    lazy var albumViewModal: AlbumViewModal = {
        return AlbumViewModal()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initData()
    }
    
    
    func initView() {
        self.navigationItem.title = "Albums"
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100
    }
    
    
    func initData() {
        albumViewModal.fetchAlbums { (status, albums) in
            if status == true{
                self.tableView.reloadData()
            }
            else{
                
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
            fatalError("Cell not exists in storyboard")
        }
        
        let album = albumViewModal.albums[indexPath.row]
        cell.updateCellFor(data: album)
        
        return cell
    }
}
