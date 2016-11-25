//
//  ViewController.swift
//  SwiftDownloadingManager
//
//  Created by user on 11/18/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var loadManager: LoadManager?
    var downloadInfo: DownloadInfo?
    var localDownloads: [DownloadInfo]?
    
    
    let identifier = "LoaderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataManager.instance.getSortedFetch(onSuccess: { (fetchedResult) in
            localDownloads = fetchedResult
        }, onError: { (defect) in
            DialogHelper.showAlert(title: "Error", message: defect.localizedDescription, controller: self)
        })

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func unwindToSelf(unwindSegue: UIStoryboardSegue) {
        if let dataVC = unwindSegue.source as? UrlsViewController {
            let downloadInfo = DownloadInfo(/*context: CoreDataManager.instance.getContext()!*/)
            if dataVC.url != nil && dataVC.fileName != nil {
                downloadInfo.urlString = dataVC.url
                downloadInfo.fileName = dataVC.fileName
                downloadInfo.downloaded = false
                print("\(localDownloads?.count)")
                localDownloads?.append(downloadInfo)
                print("\(localDownloads?.count)")
//                let index = localDownloads?.count
//                let indexPath = IndexPath(row: index! - 1, section: 0)
//                var indexPaths: [IndexPath] = [IndexPath]()
//                indexPaths.append(indexPath)
//                let cell = self.tableView.dequeueReusableCell(withIdentifier: identifier/*, for: indexPath*/) as! LoaderTableViewCell
//                print(indexPath.row)
//                cell.urlString = dataVC.url
//                print("\(cell.urlString)")
//                cell.fileName = dataVC.fileName
//                self.tableView.beginUpdates()
//                self.tableView.insertRows(at: indexPaths, with: .bottom)
//                self.tableView.endUpdates()
                //                self.tableView.reloadData()
                
//                cell.loader?.loadFileFromUrl(urlString: downloadInfo.urlString!)
            }
            
            self.tableView.reloadData()
            
        }
    }
    
    //MARK; TableView DataSource/Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if localDownloads?.count != nil{
            return localDownloads!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! LoaderTableViewCell
        cell.urlString = localDownloads![indexPath.row].urlString
        cell.downloaded = localDownloads![indexPath.row].downloaded
        cell.fileName = localDownloads![indexPath.row].fileName
        cell.downloadInfo?.startingDownload = localDownloads![indexPath.row].startingDownload
        cell.downloadInfo?.finishedDownload = localDownloads![indexPath.row].finishedDownload
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            localDownloads?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

