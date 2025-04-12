//
//  PhotoModelFileManager.swift
//  learn
//
//  Created by Dostan Turlybek on 12.04.2025.
//

import Foundation
import SwiftUI

class PhotoModelFileManager{
    
    static let instance = PhotoModelFileManager()
    let folderName: String = "downloadedPhotos"
    
    private init(){ createFolderIfNeeded() }
    
    func createFolderIfNeeded(){
        guard let url = getFolderPath() else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do{
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                print("Created folder")
            } catch let error {
                print("ERROR creating folder: \(error)")
            }
        }
    }
    
    private func getFolderPath() -> URL?{
        return FileManager
            .default
            .urls(
                for: .cachesDirectory,
                in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    private func getImagePath(key: String) -> URL?{
        guard let folder = getFolderPath() else { return nil }
        return folder.appendingPathComponent(key + ".png")
    }
    
    func add(key: String, value: UIImage){
        guard
            let data = value.pngData(),
            let url = getImagePath(key: key)
        else {
            return
        }
        
        do {
            try data.write(to: url)
        } catch let error{
            print("Error to saving to file manager: \(error)")
        }
    }
    
    func get(key: String) -> UIImage? {
        guard
            let url = getImagePath(key: key),
            FileManager.default.fileExists(atPath: url.path)
        else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
}
