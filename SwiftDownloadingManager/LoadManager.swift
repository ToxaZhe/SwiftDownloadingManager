//
//  LoadManager.swift
//  SwiftDownloadingManager
//
//  Created by user on 11/18/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import Foundation

protocol LoadManagerInfoDelegate: class {
    func getLoadingInfo(_ startDate: Date?, finishedDate: Date?, downloaded: Bool, expectedBytes: Int?, writtenBytes: Int?, error: Error?)
}

class LoadManager: NSObject, URLSessionDataDelegate, URLSessionDelegate, URLSessionTaskDelegate {
    
    
    let metrics = URLSessionTaskMetrics()
    var _fileUrl: String?
    var _fileTask: URLSessionTask?
    var _fileDowloaded = false
    var _expectedFileLenght: Int64?
    var _fileData = Data()
    var _error: Error?
    var _startDowloading: Date?
    var _finishDowloading: Date?
    weak var delegate: LoadManagerInfoDelegate?
    
    
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
            completionHandler(.allow)
        }
    
    }
    
        
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            delegate?.getLoadingInfo(nil, finishedDate: nil, downloaded: true, expectedBytes: nil, writtenBytes: nil, error: error)
        } else {
            guard let url = _fileUrl else {print("LoadManager -> can't save dat - no urlString"); return}
            let fileName = FileManage.getFileName(urlString: url)
            FileManage.saveMp3ToTheAppDirectory(fileData: _fileData, fileName: fileName, onSuccess: {
                saveDownloadInfo(link: _fileUrl!, fileName: fileName)
                delegate?.getLoadingInfo(_startDowloading, finishedDate: _finishDowloading, downloaded: true, expectedBytes: nil, writtenBytes: nil, error: nil)
            }, onError: { (failure) in
                delegate?.getLoadingInfo(nil, finishedDate: nil, downloaded: true, expectedBytes: nil, writtenBytes: nil, error: failure)
            })
            
        }
    }

   
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        if task == _fileTask {
            _startDowloading = metrics.taskInterval.start
            _finishDowloading = metrics.taskInterval.end
        }
    }
    
    
    
   func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if dataTask == _fileTask {
            _fileData.append(data)
            let bytesWritten = _fileData.count
            let expectedBytes = Int(_expectedFileLenght!)
            delegate?.getLoadingInfo(nil, finishedDate: nil, downloaded: false, expectedBytes: expectedBytes, writtenBytes: bytesWritten, error: nil)
            
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
        } else if _fileTask?.state == .suspended {
            start()
        } else if _fileTask?.state == .completed {
            print("_fileTask download completed")
            _fileDowloaded = true
        }
    }
    
    
  //MARK: Save Download info to local store
    
    func saveDownloadInfo(link: String, fileName: String) {
        
        let downloadInfo = DownloadInfo(context: CoreDataManager.instance.getContext()!)
        downloadInfo.downloaded = true
        downloadInfo.startingDownload = _startDowloading as NSDate?
        downloadInfo.finishedDownload = _finishDowloading as NSDate?
        downloadInfo.urlString = link
        downloadInfo.fileName = fileName
        CoreDataManager.instance.saveMox(storeMod: downloadInfo, onError: { (failure) in
            print("\(failure.localizedDescription)")
            delegate?.getLoadingInfo(nil, finishedDate: nil, downloaded: true, expectedBytes: nil, writtenBytes: nil, error: failure)
        })

    }
    
    
}
