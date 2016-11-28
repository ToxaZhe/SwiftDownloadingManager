//
//  LoaderTableViewCell.swift
//  SwiftDownloadingManager
//
//  Created by user on 11/24/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import UIKit

class LoaderTableViewCell: UITableViewCell {

    @IBOutlet weak var stopResumeButton: UIButton!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var progressInfoLbl: UILabel!
    
    var loader: LoadManager?
    var downloaded = false
    
  //MARK:  cell info
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
////        self.fileNameLbl.text = nil
////        self.progressInfoLbl.text = nil
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
//MARK: Handle download process
    
    
    @IBAction func stopResumeAction(_ sender: UIButton) {
            if loader?._fileTask?.state == .running  {
                let imageResumeName = "resume"
                stopResumeButton.setImage(UIImage.init(named: imageResumeName), for: .normal)
                
                loader?.stop()
            }  else if loader?._fileTask?.state == .suspended {
                let imageResumeName = "image"
                stopResumeButton.setImage(UIImage.init(named: imageResumeName), for: .normal)
                loader?.start()
        }
    }
    
  

    
}
