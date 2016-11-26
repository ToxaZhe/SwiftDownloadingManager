//
//  PlaerViewController.swift
//  SwiftDownloadingManager
//
//  Created by user on 11/26/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import UIKit
import  AVFoundation


class PlaerViewController: UIViewController {

    
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var fileName: String?
    var player: AVAudioPlayer?
    @IBAction func backAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPlayerWithData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fileNameLbl.text = fileName
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        playPause()
    }

    func initPlayerWithData() {
        
    FileManage.getFileFromAppDocumentsDerictory(fileName: fileName!, onSuccess: { (fileData) in
        do {
            
            player = try AVAudioPlayer(data: fileData)
            player?.play()
            player?.numberOfLoops = -1
        } catch let error {
            DialogHelper.showAlert(title: "error", message: "\(error.localizedDescription)", controller: self)
        }
        
        
    }) { (defect) in
        DialogHelper.showAlert(title: "error", message: "\(defect.localizedDescription)", controller: self)
        }
        
    }
    
    func playPause() {
        guard let player = self.player else {return}
        if player.isPlaying {
            playPauseButton.setImage(UIImage.init(named: "play"), for: .normal)
            player.pause()
        } else {
            playPauseButton.setImage(UIImage.init(named: "image"), for: .normal)
            player.play()
        }
    }
   
}