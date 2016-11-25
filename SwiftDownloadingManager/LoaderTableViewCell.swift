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
    var urlString: String?
    var fileName: String?
    var downloaded = false
  //MARK:  cell info
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        configCellOrManageLoading()
        // Configure the view for the selected state
    }
//MARK: Handle download process
    
    func configCellOrManageLoading() {

        downloadInfo = DownloadInfo(context: CoreDataManager.instance.getContext()!)
        loader = LoadManager()
        loader?.delegate = self
        if downloaded {
            stopResumeButton.isHidden = false
            if downloadInfo?.startingDownload != nil && downloadInfo?.finishedDownload != nil {
                progressInfoLbl.text = "Started \(downloadInfo?.startingDownload) Completed \(downloadInfo?.finishedDownload)"
                guard let fileName = downloadInfo?.fileName else {fileNameLbl.text = "No File Name";return}
                fileNameLbl.text = fileName
            }
        
        } else if !downloaded && urlString != nil {
            loader?.loadFileFromUrl(urlString: (urlString)!)
        }
        guard let fileName = fileName else {fileNameLbl.text = "No File Name";return}
        fileNameLbl.text = fileName
    }
    
    func getLoadingInfo(_ startDate: Date?, finishedDate: Date?, downloaded: Bool, expectedBytes: Int?, writtenBytes: Int?, error: Error?) {
        if downloaded && startDate != nil && finishedDate != nil {
            progressInfoLbl.text = "Started \(startDate!) Completed \(finishedDate!)"
            self.downloaded = true
            downloadInfo?.downloaded = downloaded
            downloadInfo?.startingDownload = startDate as NSDate?
            downloadInfo?.finishedDownload = finishedDate as NSDate?
            downloadInfo?.urlString = urlString
            downloadInfo?.fileName = fileName
//            print("\(downloadInfo?.description)")
            CoreDataManager.instance.saveMox(storeMod: downloadInfo!, onError: { (failure) in
                progressInfoLbl.text = "\(failure.localizedDescription)"
            })
            
        } else if error == nil {
            progressInfoLbl.text = "\(writtenBytes!) bytes of \(expectedBytes!) bytes "
        } else if error != nil {
            progressInfoLbl.text = "\(error!.localizedDescription)"
        }
    }
    
    @IBAction func stopResumeAction(_ sender: UIButton) {
        if !(downloaded) {
            loader?.stopResumeDowload()
        }
        
    }
    
    @IBAction func playSongAction(_ sender: UIButton) {
        goListenSong!()
    }

    
}
