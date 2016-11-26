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
    var temporaryModel: TemporaryModel?
    var localDownloads = [TemporaryModel]()
    var downloadedFilesData: [DownloadInfo]?
    var downloadingLinks = [String]()
    var cells = [LoaderTableViewCell]()
    
    let identifier = "LoaderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
//        getSavedDownloadsInfo()
        
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
            if dataVC.temporaryModel != nil {
//                let index = cells.count
//                let indexPath = IndexPath(row: index, section: 0)
                temporaryModel = dataVC.temporaryModel
//                localDownloads.append(temporaryModel!)
//                let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! LoaderTableViewCell
//                cell.temporaryModel = temporaryModel
//                print(temporaryModel?.fileName as Any)
//                cells.append(cell)
//                cell.cellTag = cells.count
//                for cell in cells {
//                    print (cell.temporaryModel?.fileName as Any)
//                }
//                print("\(cells.count), \(cell.tag)")
//                downloadingLinks.append(temporaryModel!.urlString!)
            }
            self.tableView.reloadData()
        }
    }
    
    //MARK; TableView DataSource/Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cells.count != 0{
            return cells.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier/*, for: indexPath*/) as! LoaderTableViewCell
//            cell.temporaryModel = localDownloads[indexPath.row]
//            cell.fileNameLbl.text = localDownloads[indexPath.row].fileName
//            cell.cellTag = cell.tag
        let cell = cells[indexPath.row]
        
            return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.beginUpdates()
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.endUpdates()
//        }
//    }

    
    //MARK: Handle coreData fetch request and fetch downloaded urls
    
    
//    func getSavedDownloadsInfo() {
//        CoreDataManager.instance.getSortedFetch(onSuccess: { (fetchedResult) in
//            downloadedFilesData = fetchedResult
//            //            for file in downloadedFiles! {
//            //                print("\(file.finishedDownload)")
//            //            }
//            
//            for savedDownload in downloadedFilesData! {
//                
//                guard let link = savedDownload.urlString else {return}
//                downloadedLinks.append(link)
//                print(downloadedLinks.count as Any)
//            }
//        }, onError: { (defect) in
//            DialogHelper.showAlert(title: "Error", message: defect.localizedDescription, controller: self)
//        })
//
//    }
    
    
    
    
}


