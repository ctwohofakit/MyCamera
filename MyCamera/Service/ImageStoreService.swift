//
//  ImageStoreService.swift
//  MyCamera
//
//  Created by Kit Sitou on 6/18/26.
//
import Combine
import Foundation
import UIKit

class ImageStoreService {
    private let folderName: String = "CameraDemoStorage"
    
    enum Kind{
        case before
        case after
    }
    
    func makeFileName(id:UUID, kind: Kind) -> String{
        if kind == .before{
            return id.uuidString + "_before.jpg" //
        }else{
            return id.uuidString + "_after.jpg"
        }
    }
    
    func saveIMG(_ image: UIImage, fileName: String) throws {
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            throw NSError(domain: folderName, code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not save the iamge"])
            
        }
        let url = fileURL(fileName: fileName)
        try data.write(to: url, options: .atomic)
        
    }
    
    
    func loadIMG(fileName: String) -> UIImage? {
        let url = fileURL(fileName: fileName)
        
        if FileManager.default.fileExists(atPath: url.path()) == false {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {return nil}
        
        return UIImage(data: data)
    }
    
    
    func deleteIMG(fileName:String){
        let url = fileURL(fileName: fileName)
        if FileManager.default.fileExists(atPath: url.path()) == false{
            return
        }
        
        try? FileManager.default.removeItem(at: url)
    }
    
    
    
    
    func createFolderIfNeeded(){
        let url = folderURL()
        
        if FileManager.default.fileExists(atPath: url.path){
            return
        }
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        
    }
    
    
    
    //create folder URL
    func docURL()->URL{
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
    }
    
    //get the foler url
    func folderURL()->URL{
        docURL().appendingPathComponent(folderName)
    }
    
    func fileURL(fileName:String)->URL{
        docURL().appendingPathComponent(fileName)
    }
    
}
