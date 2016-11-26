//
//  FetchedDownloadsViewController.swift
//  SwiftDownloadingManager
//
//  Created by user on 11/26/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import UIKit

class FetchedDownloadsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var index: Int?
    var fetchedData = [DownloadInfo]()
    let identifier = "ListenSongSegue"
    
    @IBAction func backAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSavedDownloadsInfo()
        DialogHelper.showAlert(title: nil, message: "Swiping Left removing Entity ", controller: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == identifier {
            let destVC = segue.destination as! PlaerViewController
            destVC.fileName = fetchedData[index!].fileName
        }
    }

   //MARK: TableView Delegate\DataSource
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: identifier, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedData.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.textColor = UIColor.brown
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.text = "push \(fetchedData[indexPath.row].fileName!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("\(indexPath.row)")
            let entityToRemove = fetchedData[indexPath.row]
            CoreDataManager.instance.removeEntity(savedInfo: entityToRemove, onError: { (defect) in
                DialogHelper.showAlert(title: "Failed", message: "\(defect.localizedDescription)", controller: self)
            })
            fetchedData.remove(at: indexPath.row)

            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
                    }
    }

    //MARK: Handle Fetch from Core Data and removing dowloaded links
    
    func getSavedDownloadsInfo() {
        CoreDataManager.instance.getSortedFetch(onSuccess: { (fetchedResult) in
            fetchedData = fetchedResult
        }, onError: { (defect) in
            DialogHelper.showAlert(title: "Error", message: defect.localizedDescription, controller: self)
        })
        
    }

    }
