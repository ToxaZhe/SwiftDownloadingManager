//
//  LoadManager.swift
//  SwiftDownloadingManager
//
//  Created by user on 11/18/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import Foundation


class LoadManager: NSObject, URLSessionDataDelegate {
    
    var _fileUrl: String?
    var _fileTask: URLSessionDataTask?
    var _fileDowloaded = false
    var _expectedFileLenght: Int64?
    var _fileData: Data?
    
    
    func loadFileFromUrl(urlString: String) {
        _fileUrl = urlString
        let url = URL(string: urlString)!
        let defConfigObject = URLSessionConfiguration.default
        let defaultSession = URLSession(configuration: defConfigObject, delegate: self, delegateQueue: OperationQueue.main)
        _fileTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                self._fileTask?.resume()
                self._expectedFileLenght = response?.expectedContentLength
                self._fileData = data
                print((self._fileData?.description)! as String)
//                let lenght = self._fileData?.count
//MARK: add CoreData startingDate
            }
        })
    }
   
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        if task == _fileTask {
            let startDate = metrics.taskInterval.start
            let finishedDate = metrics.taskInterval.end
            print("\(startDate) - \(finishedDate)")
            
        }
        
    }
    
    
//   func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        
//    }
//    
//   func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
//    
//    }
}
