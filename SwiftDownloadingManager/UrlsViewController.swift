//
//  UrlsViewController.swift
//  SwiftDownloadingManager
//
//  Created by Mobile Developer on 11/25/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import UIKit




class UrlsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let context = CoreDataManager.instance.getContext()
    
    var url: String?
    var fileName: String?
    let urlStrings = [song1UrlString, song2UrlString, song3UrlString, song4UrlString, song5UrlString, song6UrlString, song7UrlString, song8UrlString, song9UrlString, song10UrlString, song11UrlString, song12UrlString, song13UrlString, song14UrlString, song15UrlString, song16UrlString, song17UrlString, song18UrlString, song19UrlString, song20UrlString]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }


    //MARK: TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let color = UIColor.orange
        cell.textLabel?.text = FileManage.getFileName(urlString: urlStrings[indexPath.row])
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = color
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueIdentifier = "GoBackWithNeedeUrl"
//        let downloadInfo = DownloadInfo(context: context!)
        url = urlStrings[indexPath.row]
        fileName = FileManage.getFileName(urlString: url!)
//        downloadInfo.urlString = url
//        downloadInfo.downloaded = false
//        downloadInfo.fileName = fileName
        
        
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    
}
