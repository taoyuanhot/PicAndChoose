//
//  PhotoTool.swift
//  photoTest
//
//  Created by Jonah Chou on 2023/11/22.
//

import Foundation
import UIKit
import Photos


class PhotoTool: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - 初始化工具
    var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    //MARK: - 清除Array
    func clearSelectedArray(){
        arrSelectedPHAsset = []
        arrSelectedUIImage = []
    }
    
    //MARK: - 取得selectedPHAsset
    func getArrSelectedPHAsset()->[UIImage]{ //調整成UIImage
        return arrSelectedPHAsset
    }
    
    //MARK: - 取得selectedPHAsset
    func getArrSelectedUIImage()->[UIImage]{
        return arrSelectedUIImage
    }
    
    //MARK: - 打開相簿（UIImagePickerController）
    var imagePickerCompletion: (() -> Void)?
    
    func openUIImagePickerController(completion: (() -> Void)? = nil) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            
            if status == .authorized {
                DispatchQueue.main.async {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    
                    // 保存闭包
                    self.imagePickerCompletion = completion
                    
                    self.viewController?.present(imagePicker, animated: true, completion: nil)
                }
            } else {
                print("无法存取相簿")
            }
        }
    }
    
    // 實作 UIImagePickerControllerDelegate 的方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            if let pickedImage = info[.originalImage] as? UIImage {
                print("已取得UIImage: \(pickedImage)")
                arrSelectedPHAsset.append(pickedImage) 
                arrHistoryLogUndo.append(HistoryLog(historyTarget: .imagePicker, historyAction: .pull, historyUIImage: pickedImage))
            }
        }
        // 在这里调用保存的闭包
        self.imagePickerCompletion?()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 使用者取消選擇相片
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 建立資料夾
    //create Folder and get Address
    func createFolder(folderName: String) {
        guard !folderName.isEmpty else {
            print("資料夾名稱為空")
            return
        }
        
        let fileManager = FileManager.default
        do {
            // 取得應用程式的 home directory 路徑
            let homeDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            // 在 home directory 中添加一個資料夾
            let localfolderURL = homeDirectoryURL.appendingPathComponent(folderName)
            
            // 检查目录是否已存在
            if fileManager.fileExists(atPath: localfolderURL.path) {
                print("資料夾已存在：\(localfolderURL.path)")
                return
            }
            
            try fileManager.createDirectory(at: localfolderURL, withIntermediateDirectories: true, attributes: nil)
            print("資料夾已經成功創建：\(localfolderURL.path)")
        } catch {
            print("創建資料夾時出現錯誤：\(error.localizedDescription)")
        }
    }
    
    //MARK: - 刪除資料夾＋內部檔案
    //delete Folder by URL(包括內部的photos)
    func deleteFolder(at folderURL: URL?) {
        // 確保 folderURL 不為 nil 且不是空字串
        guard let folderURL = folderURL, !folderURL.absoluteString.isEmpty else {
            print("無效的資料夾 URL")
            return
        }
        
        let fileManager = FileManager.default
        
        do {
            // 判斷資料夾是否存在
            if fileManager.fileExists(atPath: folderURL.path) {
                // 刪除資料夾及其內容
                try fileManager.removeItem(at: folderURL)
                print("資料夾已成功刪除：\(folderURL.path)")
            } else {
                print("資料夾不存在：\(folderURL.path)")
            }
        } catch {
            print("刪除資料夾時發生錯誤：\(error.localizedDescription)")
        }
    }
    
    //MARK: - 刪除資料夾內部檔案但保留資料夾
    //delete contents in Folder by URL( 不包括Folder本身)
    func deleteContentsOfFolder(at folderURL: URL?) {
        
        guard let folderURL = folderURL, !folderURL.absoluteString.isEmpty else {
            print("無效的資料夾 URL")
            return
        }
        
        let fileManager = FileManager.default
        
        do {
            // 判斷資料夾是否存在
            if fileManager.fileExists(atPath: folderURL.path) {
                // 取得資料夾內的所有檔案
                let contents = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [])
                
                // 刪除資料夾內的每個檔案
                for fileURL in contents {
                    try fileManager.removeItem(at: fileURL)
                    print("檔案已成功刪除：\(fileURL.path)")
                }
                
                print("資料夾內容已成功刪除")
            } else {
                print("資料夾不存在：\(folderURL.path)")
            }
        } catch {
            print("刪除資料夾內容時發生錯誤：\(error.localizedDescription)")
        }
    }
    
    //MARK: - 複製照片到指定資料夾
    //copy Photo to Folder by PHAsset ＆ URL
    func copyPHAsset(_ asset: PHAsset, to folderURL: URL?) {
        
        guard let folderURL = folderURL, !folderURL.absoluteString.isEmpty else {
            print("無效的資料夾 URL")
            return
        }
        
        let imageManager = PHImageManager.default()
        
        // 取得原始照片
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: requestOptions) { (image, info) in
            if let image = image, let data = image.jpegData(compressionQuality: 1.0) {
                let fileName = UUID().uuidString + ".jpg"
                let destinationURL = folderURL.appendingPathComponent(fileName)
                
                do {
                    try data.write(to: destinationURL)
                    print("照片已成功複製到：\(destinationURL.path)")
                } catch {
                    print("複製照片時發生錯誤：\(error.localizedDescription)")
                }
            } else {
                print("無法取得照片")
            }
        }
    }
    
    //MARK: - 刪除指定照片
    //delete Photo by PHAsset
    func deletePHAsset(_ asset: PHAsset?) {
        guard let asset = asset else {
            print("PHAsset 为空")
            return
        }
        
        guard !asset.localIdentifier.isEmpty else {
            print("无效的 PHAsset")
            return
        }
        
        let assetFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [asset.localIdentifier], options: nil)
        
        if assetFetchResult.count > 0 {
            // Asset exists, perform deletion
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets([asset] as NSArray)
            }) { success, error in
                if success {
                    print("相片删除成功")
                } else if let error = error {
                    print("相片删除失败：\(error)")
                }
            }
        } else {
            // Asset does not exist
            print("相片不存在")
        }
    }
    
    
}
