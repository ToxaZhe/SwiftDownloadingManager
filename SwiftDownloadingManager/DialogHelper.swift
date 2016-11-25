//
//  DialogHelper.swift
//  SwiftDownloadingManager
//
//  Created by Mobile Developer on 11/25/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import Foundation
import UIKit


class DialogHelper {
    
    static func showAlert (title: String?, message: String, controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
