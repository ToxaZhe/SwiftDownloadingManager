//
//  ViewController.swift
//  SwiftDownloadingManager
//
//  Created by user on 11/18/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let loadManager = LoadManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadManager.loadFileFromUrl(urlString: "https://promodj.com/download/6059313/Laurence%20Revey%20-%20L%27Immortel%20%28Soomeen%20Extended%29%20%28promodj.com%29.mp3")
        print("\(loadManager._expectedFileLenght)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

