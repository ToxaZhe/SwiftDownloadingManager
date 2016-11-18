//
//  LoadManager.swift
//  SwiftDownloadingManager
//
//  Created by user on 11/18/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import Foundation


class LoadManager: NSObject, URLSessionDataDelegate, URLSessionDelegate, URLSessionTaskDelegate {
    
    
    let metrics = URLSessionTaskMetrics()
    var _fileUrl: String?
    var _fileTask: URLSessionTask?
    var _fileDowloaded = false
    var _expectedFileLenght: Int64?
    var _fileData = Data()
    
    
    func loadFileFromUrl(urlString: String) {
        _fileUrl = urlString
        let url = URL(string: urlString)!
        let defConfigObject = URLSessionConfiguration.default
        let defaultSession = URLSession(configuration: defConfigObject, delegate: self, delegateQueue: OperationQueue.main)
        _fileTask = defaultSession.dataTask(with: url)
        self._fileTask?.resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if dataTask == _fileTask {
            _expectedFileLenght = response.expectedContentLength
            print("\(_expectedFileLenght)")
            completionHandler(.allow)
        }
    
    }

   
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        if task == _fileTask {
            print("\(task.countOfBytesExpectedToReceive) - \(task.countOfBytesReceived) ")
            let startDate = metrics.taskInterval.start
            let finishedDate = metrics.taskInterval.end
            print("\(startDate) - \(finishedDate)")
        }
    }
    
    
   func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if dataTask == _fileTask {
            _fileData.append(data)
            print("\(_fileData.count)")
        }
    }
    
    
    func start() {
        _fileTask?.resume()
    }
    
    func stop() {
        _fileTask?.suspend()
    }
    
    
    func stopResumeDowload() {
        if _fileTask?.state == .running {
            stop()
        } else {
            start()
        }
    }
    
    
    
    
    
    
}
