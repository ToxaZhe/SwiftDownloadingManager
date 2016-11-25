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
    static var error: Error?
    
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
        do {
            try fileData.write(to: URL.init(fileURLWithPath: name), options: .atomic)
            onSuccess()
        } catch {
            print(error.localizedDescription)
            onError(error)
        }
    }
    
    static func getFileFromAppDocumentsDerictory(urlString:String, onSuccess:(Data) ->(), onError:(Error) -> ())  {
        let url = URL(string: urlString)
        guard url != nil else {return}
        let fileName = url?.lastPathComponent
        let documentsUrl = applicationDocumentsDirectory()
        let fullFileName = String(format: "%@/%@.mp3", documentsUrl.path,fileName!)
        if fileManager.fileExists(atPath: fullFileName) {
            do {
                let fileData = try Data.init(contentsOf: URL.init(fileURLWithPath: fullFileName))
                onSuccess(fileData)
            } catch {
                print(error.localizedDescription)
                onError(error)
            }
            
        }
    }
}
