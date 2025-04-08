//
//  Save data and images to FileManager in Xcode.swift
//  learn
//
//  Created by Dostan Turlybek on 07.04.2025.
//
//https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html
//https://developer.apple.com/documentation/foundation/optimizing_your_app_s_data_for_icloud_backup/
/*
 1. Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
 2. Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications
 3. Data that is used only temporarily should be stored in the <Application_Home>/tmp directory. Although these files are not backed up to iCloud, remember to delete those files when you are done with them so that they do not continue to consume space on the
 4. Use the "do not back up" attribute for specifying files that should remain on device, even in low storage situations. Use this attribute with data that can be recreated but needs to persist even in low storage situations for proper functioning of your app or because customers expect it to be available during offline use. This attribute works on marked files regardless of what directory they are in, including the Documents directory. These files will not be purged and will not be included in the user's iCloud or iTunes backup. Because these files do use on-device storage
 */
import SwiftUI
#Preview {
    SaveDataAndImagesToFileManagerView()
}

class LocalFileManager{
    static let instance = LocalFileManager()
    let folderName: String = "MyApp_Image"
    
    init(){
        createFolderIfNeeded()
    }
    
    func createFolderIfNeeded(){
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path
        else{
            return
        }
        
        if !FileManager.default.fileExists(atPath: path){
            do {
                try FileManager.default.createDirectory(
                    atPath: path,
                    withIntermediateDirectories: true ,
                    attributes: nil)
                print("Succes creating folder")
            } catch let error {
                print("ERROR: \(error)")
            }
        }
    }
    
    func deleteFolder(){
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path
        else{
            return
        }
        
        
        do {
            try FileManager.default.removeItem(atPath: path)
            print("Succes deleting folder")
            print(path)
        } catch let error {
            print("ERROR: \(error)")
        }
        
    }
    
    func saveImage(image: UIImage, name: String) -> String{
        guard
            let data = image.jpegData(compressionQuality: 1.0),
            let path = getPathForImage(name: name)
        else {
            return "ERROR getting data"
        }
        
        // these are most popular directory
//        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let directory2 = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
//        let directory3 = FileManager.default.temporaryDirectory
//        
//        let path = directory2?.appendingPathComponent("\(name).jpg")
        
        
        
        do {
            try data.write(to: path)
            print(path)
            return "Success saving image"
        } catch let error{
            return "ERROR: \(error)"
        }
        // 26:30
    }
    
    func getImage(name: String) -> UIImage?{
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path)
        else{
            print("ERROR getting path")
            return nil
        }
        return UIImage(contentsOfFile: path)
    }
    
    func deleteImage(name: String) -> String{
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path)
        else{
            return "ERROR getting data"
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            return "Success deleting image"

        } catch let error{
            return "Deleting error: \(error)"
        }
    }
    
    func getPathForImage(name: String) -> URL?{
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .appendingPathComponent("\(name).jpg")
        else {
            print("Error getting path")
            return nil
        }
        return path
    }
}

class SaveDataAndImagesToFileManagerViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let imageName: String = "girl"
    let manager = LocalFileManager.instance
    @Published var infoMessage: String = ""
    
    init(){
        getImageFromFileManager( )
    }
    
    func getImageFromAssetsFolder(){
        image = UIImage(named: imageName)
    }
    
    func getImageFromFileManager(){
        image = manager.getImage(name: imageName)
    }
    
    func deleteImageFromFileManager(){
        infoMessage = manager.deleteImage(name: imageName)
        manager.deleteFolder()
    }
    
    func saveImage(){
        guard let image = image else {return}
        infoMessage = manager.saveImage(image: image, name: imageName)
    }
}

struct SaveDataAndImagesToFileManagerView: View {
    
    @StateObject var vm = SaveDataAndImagesToFileManagerViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 310, height: 310)
                        .background(Color("AccentColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                HStack{
                    Button{
                        vm.saveImage()
                    }label:{
                        Text("Save to File Manager")
                    }
                    .frame(width: 150, height: 50)
                    .foregroundStyle(.white)
                    .background(Color("AccentColor"))
                    .cornerRadius(10)
                    
                    Button{
                        vm.deleteImageFromFileManager()
                    }label:{
                        VStack{
                            Text("Delete")
                            Text("from FileManager")
                        }
                       
                    }
                    .frame(width: 150, height: 50)
                    .foregroundStyle(.white)
                    .background(.red)
                    .cornerRadius(10)
                }
                .padding()
                
                Text(vm.infoMessage)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.purple)
                 
                Spacer()
                
                
            }
            .navigationTitle("File Manager")
        }
    }
}



/*
 
 so, as far as i understand
 
 the FileManager needs for store data in device. There are diferent path for diferent cases.
 
 FileManager are easyyyyy, i think.... There are quotes about this "Tell me the file, and I’ll save it, find it, move it, or delete it for you.".
 
 FileManager store data on a device insted an application.
 
 I will use it absolutely
 
 */
