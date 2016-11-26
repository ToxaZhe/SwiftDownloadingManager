//
//  FileManager.swift
//  SwiftDownloadingManager
//
//  Created by user on 11/23/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

import Foundation


class FileManage {
    
    static let fileManager = FileManager.default
    
    static func applicationDocumentsDirectory() -> (URL) {
        let documentsUrl = fileManager.urls(for: .documentDirectory,in: .userDomainMask).last!
        return documentsUrl
    }
    
    
    static func getFileName(urlString: String) -> (String) {
        let url = URL(string: urlString)
        guard let fileName = url?.lastPathComponent else {return "NoName"}
        return fileName
    }
    
    static func saveMp3ToTheAppDirectory(fileData: Data, fileName: String,onSuccess: () -> (), onError:(Error) -> ()) {
        let documentsUrl = applicationDocumentsDirectory()
        let filePath = documentsUrl.path
        let name = "\(filePath)/\(fileName).mp3"
        if !fileManager.fileExists(atPath: name) {
            do {
                try fileData.write(to: URL.init(fileURLWithPath: name), options: .atomic)
                onSuccess()
            } catch {
                onError(error)
            }
        } else {
            print("file already exists at path")
        }
    }
    
    static func getFileFromAppDocumentsDerictory(fileName:String, onSuccess:(Data) -> (), onError:(Error) -> ())  {
        let documentsUrl = applicationDocumentsDirectory()
        let fullFileName = String(format: "%@/%@.mp3", documentsUrl.path,fileName)
        if fileManager.fileExists(atPath: fullFileName) {
            do {
                let fileData = try Data.init(contentsOf: URL.init(fileURLWithPath: fullFileName))
                onSuccess(fileData)
            } catch {
                onError(error)
            }
            
        }
    }
    
    static func removeFromDirectory (fileName: String, onError: (Error) -> ()) {
        let documentsUrl = applicationDocumentsDirectory()
        let fullFileName = String(format: "%@/%@.mp3", documentsUrl.path,fileName)
        if fileManager.fileExists(atPath: fullFileName) {
            do {
                try fileManager.removeItem(atPath: fullFileName)
            } catch {
                onError(error)
            }
        }
    }
}
