//
//  ViewController.swift
//  SwiftDownloadingManager
//
//  Created by user on 11/18/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LoadManagerInfoDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var loadManager: LoadManager?
    var downloadingLinks = [String]()
    var loads = [LoadManager]()

    
    let identifier = "LoaderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        

        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let showCoreDataInfo = "ShowCoreDataInfo"
        let chooseDownloadUrlSegue = "ChooseDownloadUrlSegue"
        if segue.identifier == showCoreDataInfo {
            
//            let destVC = segue.destination as! FetchedDownloadsViewController
//            destVC.fetchedData = downloadedFilesData!
            
        } else if segue.identifier == chooseDownloadUrlSegue {
            let destVC = segue.destination as! UrlsViewController
            destVC.downloadingLinks = downloadingLinks
        }
    }

    @IBAction func unwindToSelf(unwindSegue: UIStoryboardSegue) {
        if let dataVC = unwindSegue.source as? UrlsViewController {
            if dataVC.url != nil {
                loadManager = LoadManager()
                loadManager?.delegate = self
                loadManager?.loadFileFromUrl(urlString: dataVC.url!)
                loads.append(loadManager!)
                downloadingLinks.append(dataVC.url!)
                
            }
            self.tableView.reloadData()
        }
    }
    
    //MARK; TableView DataSource/Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loads.count != 0{
            return loads.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier/*, for: indexPath*/) as! LoaderTableViewCell
        cell.fileNameLbl.text = loads[indexPath.row]._fileName
        cell.progressInfoLbl.text = loads[indexPath.row]._dowloadingStage
        cell.loader = loads[indexPath.row]
            return cell
    }
    
    
    func getLoadingInfo() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    
}


