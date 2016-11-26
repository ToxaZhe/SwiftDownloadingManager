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
    let defaults = UserDefaults.standard
    let defaultsKey = "userFirstTime"
    
    @IBAction func backAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard defaults.object(forKey: defaultsKey) != nil else {
            defaults.set(false, forKey: defaultsKey)
            DialogHelper.showAlert(title: nil, message: "Swiping Left removing Entity ", controller: self)
            return
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSavedDownloadsInfo()
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
            
            removeDataFromApp(index: indexPath.row)
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
    
    func removeDataFromApp(index: Int) {
        let entityToRemove = fetchedData[index]
        FileManage.removeFromDirectory(fileName: entityToRemove.fileName!, onError: {(defect) in
            DialogHelper.showAlert(title: "Failed", message: "\(defect.localizedDescription)", controller: self)
        })
        CoreDataManager.instance.removeEntity(savedInfo: entityToRemove, onError: { (defect) in
            DialogHelper.showAlert(title: "Failed", message: "\(defect.localizedDescription)", controller: self)
        })
        fetchedData.remove(at: index)
    }

}
