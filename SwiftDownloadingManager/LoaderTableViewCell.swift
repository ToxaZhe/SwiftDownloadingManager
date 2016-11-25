//
//  LoaderTableViewCell.swift
//  SwiftDownloadingManager
//
//  Created by user on 11/24/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import UIKit

class LoaderTableViewCell: UITableViewCell, LoadManagerInfoDelegate {

    @IBOutlet weak var stopResumeButton: UIButton!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var progressInfoLbl: UILabel!
    @IBOutlet weak var playSongButton: UIButton!
    
    var goListenSong: (() -> ())?
    var downloadInfo: DownloadInfo?
    var loader: LoadManager?
  //MARK:  cell info
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configCellOrManageLoading()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//MARK: Handle download process
    
    func configCellOrManageLoading() {
        
        downloadInfo = DownloadInfo()
        loader = LoadManager()
        loader?.delegate = self
        if downloadInfo!.downloaded {
            stopResumeButton.isHidden = false
            if downloadInfo?.startingDownload != nil && downloadInfo?.finishedDownload != nil {
                progressInfoLbl.text = "Started \(downloadInfo?.startingDownload) Completed \(downloadInfo?.finishedDownload)"
                guard let fileName = downloadInfo?.fileName else {fileNameLbl.text = "No File Name";return}
                fileNameLbl.text = fileName
            } else if !(downloadInfo!.downloaded) && downloadInfo?.urlString != nil {
                loader?.loadFileFromUrl(urlString: (downloadInfo?.urlString)!)        }
            guard let fileName = downloadInfo?.fileName else {fileNameLbl.text = "No File Name";return}
            fileNameLbl.text = fileName
        }

    }
    
    func getLoadingInfo(_ startDate: Date?, finishedDate: Date?, downloaded: Bool, progress: Double?, error: Error?) {
        if downloaded && startDate != nil && finishedDate != nil {
            progressInfoLbl.text = "Started \(startDate!) Completed \(finishedDate!)"
            let localDataSaver = CoreDataManager()
            downloadInfo?.downloaded = true
            downloadInfo?.startingDownload = startDate as NSDate?
            downloadInfo?.finishedDownload = finishedDate as NSDate?
            localDataSaver.saveMox(storeMod: downloadInfo!, onError: { (failure) in
                progressInfoLbl.text = "\(failure.localizedDescription)"
            })
            
        } else if error == nil {
            progressInfoLbl.text = "completed \(progress!)%"
        } else if error != nil {
            progressInfoLbl.text = "\(error!.localizedDescription)"
        }
    }
    
    @IBAction func stopResumeAction(_ sender: UIButton) {
        if !(downloadInfo!.downloaded) {
            loader?.stopResumeDowload()
        }
        
    }
    
    @IBAction func playSongAction(_ sender: UIButton) {
        goListenSong!()
    }

    
}
