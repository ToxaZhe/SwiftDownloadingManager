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
    
    
    var downloadInfo: DownloadInfo?
    var loader: LoadManager?
//    var urlString: String?
//    var fileName: String?
//    var downloaded = false
    var temporaryModel: TemporaryModel?
    var cellTag: Int?
    var tags = Set<Int>()
  //MARK:  cell info
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.fileNameLbl.text = nil
        self.progressInfoLbl.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        if !tags.contains(cellTag!) {
//            tags.insert(cellTag!)
            configCellOrManageLoading()
//        }
        // Configure the view for the selected state
    }
//MARK: Handle download process
    
    func configCellOrManageLoading() {

        loader = LoadManager()
        loader?.delegate = self
        if !temporaryModel!.downloaded && temporaryModel?.urlString != nil {
            loader?.loadFileFromUrl(urlString: (temporaryModel!.urlString)!)
        }
        guard let fileName = temporaryModel!.fileName else {fileNameLbl.text = "No File Name";return}
        fileNameLbl.text = fileName
    }
    
    func getLoadingInfo(_ startDate: Date?, finishedDate: Date?, downloaded: Bool, expectedBytes: Int?, writtenBytes: Int?, error: Error?) {
        if downloaded && startDate != nil && finishedDate != nil {
            progressInfoLbl.text = "Started \(startDate!) Completed \(finishedDate!)"
            temporaryModel!.downloaded = true
        } else if error == nil {
            progressInfoLbl.text = "download \(writtenBytes!) of \(expectedBytes!) bytes "
        } else if error != nil {
            progressInfoLbl.text = "\(error!.localizedDescription)"
        }
    }
    
    @IBAction func stopResumeAction(_ sender: UIButton) {
        if !(temporaryModel!.downloaded) {
            if loader?._fileTask?.state == .running  {
                let imageResumeName = "resume"
                stopResumeButton.setImage(UIImage.init(named: imageResumeName), for: .normal)
                
                loader?.stop()
            }  else if loader?._fileTask?.state == .suspended {
                let imageResumeName = "image"
                stopResumeButton.setImage(UIImage.init(named: imageResumeName), for: .normal)
                loader?.start()
            } else if loader?._fileTask?.state == .completed {
                let imageResumeName = "image"
                stopResumeButton.setImage(UIImage.init(named: imageResumeName), for: .normal)
            }
        }
    }
    
  

    
}
