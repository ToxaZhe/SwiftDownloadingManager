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
    var temporaryModel: TemporaryModel?
    var url: String?
    var fileName: String?
    var downloadingLinks = [String]()
    var urlStrings = [song1UrlString, song2UrlString, song3UrlString, song4UrlString, song5UrlString, song6UrlString, song7UrlString, song8UrlString, song9UrlString, song10UrlString, song11UrlString, song12UrlString, song13UrlString, song14UrlString, song15UrlString, song16UrlString, song17UrlString, song18UrlString, song19UrlString, song20UrlString]
    
    
    @IBAction func backAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeUsedLinks()
    }

    //MARK: TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let color = UIColor.orange
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = FileManage.getFileName(urlString: urlStrings[indexPath.row])
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = color
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueIdentifier = "GoBackWithNeedeUrl"
        temporaryModel = TemporaryModel()
        url = urlStrings[indexPath.row]
        fileName = FileManage.getFileName(urlString: url!)
        temporaryModel?.urlString = url
        temporaryModel?.downloaded = false
        temporaryModel?.fileName = fileName
        
        
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
    //MARK: Working with loaded/loading links
        func removeUsedLinks() {
            CoreDataManager.instance.getSortedFetch(onSuccess: { (fetchedResult) in
                for savedDownload in fetchedResult {
                    guard let link = savedDownload.urlString else {return}
                    let index = urlStrings.index(of: link)
                    if urlStrings.contains(link) {
                        urlStrings.remove(at: index!)
                    }
                }
            }, onError: { (defect) in
                DialogHelper.showAlert(title: "Error", message: defect.localizedDescription, controller: self)
            })
            removeDownloadingLinks()
        }
 
    func removeDownloadingLinks() {
        for link in urlStrings {
            let index = urlStrings.index(of: link)
            if downloadingLinks.contains(link) {
                urlStrings.remove(at: index!)
            }
        }
        self.tableView.reloadData()
    }

}
