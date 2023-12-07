
import UIKit
import Foundation
import Photos

class ImgsArrayTool7 {
    
    //MARK: - 靜態儲存屬性
    
    //做出一個回傳狀態的String
    var info:String = ""
    //做出一個Tag去呈現現在show到第幾張
    var photoTag:Int = 0
    //做出一個輔助陣列去算呈現哪一張照片
    let arrPhotoTagHelper = [3,2,1,0,-1,-2,-3]
    
    //MARK: - 重置Class
    func reset(){
        arrSelectedPHAsset = []
        arrImageView = ["img7","img6","img5","img4","img3","img2","img1"]
        arrPhotoPath = [nil,nil,nil,nil,nil,nil,nil]
        info = ""
        photoTag = 0
        arrImagesToTrash = []
        arrImagesToFolder1 = []
        arrImagesToFolder2 = []
        
        print("完成getReStartImgsArray")
        print("arrSelectedPHAsset狀態：\(arrSelectedPHAsset)")
        print("arrImageView 狀態：\(arrImageView)")
        print("arrPhotoPath 狀態：\(arrPhotoPath)")
        print("info 狀態：\(info )")
        print("photoTag 狀態：\(photoTag )")
        print("arrPhotoPath狀態：\(arrImagesToTrash)")
        print("arrPhotoPath狀態：\(arrImagesToFolder1)")
        print("arrPhotoPath狀態：\(arrImagesToFolder2)")
        print("------------------以上-------------------")
    }
    
    
    //MARK: - 建立初始狀態
    func getReStartImgsArray()->Array<Array<Any>>{
        
        if !arrSelectedPHAsset.isEmpty {
            
            arrImageView = ["img7","img6","img5","img4","img3","img2","img1"]
            photoTag = 0
            
            for i in 0...6{
                if  0 <= photoTag+arrPhotoTagHelper[i] && photoTag+arrPhotoTagHelper[i] <= arrSelectedPHAsset.count-1 {
                    let tryGetImage = arrSelectedPHAsset[photoTag+arrPhotoTagHelper[i]]
                    arrPhotoPath[i] = tryGetImage
                } else {
                    arrPhotoPath[i] = nil
                }
                info = "完成getReStartImgsArray"
            }
        } else {
            info = "未執行getReStartImgsArray，arrImagesFromAlbum為空"
        }
        
        print("完成getReStartImgsArray")
        print("arrImageView狀態：\(arrImageView)")
        print("arrPhotoPath狀態：\(arrPhotoPath)")
        print("------------------以上-------------------")
        return [arrImageView,arrPhotoPath]
    }
    
    
    //MARK: - 建立下滑
    func getSwipeDownImgArray()->Array<Array<Any>>{

        if !arrSelectedPHAsset.isEmpty {
            if 0 <= photoTag  &&  photoTag < arrSelectedPHAsset.count-1 {
                if let last = arrImageView.last {
                    arrImageView.removeLast()
                    arrImageView.insert(last, at: 0)
                }
                photoTag += 1
                for i in 0...6{
                    if  0 <= photoTag+arrPhotoTagHelper[i] && photoTag+arrPhotoTagHelper[i] <= arrSelectedPHAsset.count-1 {
                        let tryGetImage = arrSelectedPHAsset[photoTag+arrPhotoTagHelper[i]]
                        //arrImageView[i].image = tryGetImage //為了測試關閉
                        arrPhotoPath[i] = tryGetImage
                    } else {
                        arrPhotoPath[i] = nil
                    }
                }
                info = "完成getSwipeDownImgArray"
            } else if photoTag == arrSelectedPHAsset.count-1 {
                info = "未執行getSwipeDownImgArray，現在是最後一張"
            }
        } else {
            info = "未執行getSwipeDownImgArray，arrImagesFromAlbum為空"
        }
        
        print("完成getSwipeDownImgArray")
        print("arrImageView狀態：\(arrImageView)")
        print("arrPhotoPath狀態：\(arrPhotoPath)")
        print("------------------以上-------------------")
        return [arrImageView,arrPhotoPath]
    }
    
    
    //MARK: - 建立上滑
    func getSwipeUpImgArray()->Array<Array<Any>>{
        if !arrSelectedPHAsset.isEmpty {
            if 0 < photoTag  &&  photoTag <= arrSelectedPHAsset.count-1 {
                if let first = arrImageView.first {
                    arrImageView.removeFirst()
                    arrImageView.append(first)
                }

                photoTag -= 1

                for i in 0...6{
                    if  0 <= photoTag+arrPhotoTagHelper[i] && photoTag+arrPhotoTagHelper[i] <= arrSelectedPHAsset.count-1 {
                        let tryGetImage = arrSelectedPHAsset[photoTag+arrPhotoTagHelper[i]]
                        arrPhotoPath[i] = tryGetImage
                    } else {
                        arrPhotoPath[i] = nil
                    }
                }
                info = "完成getSwipeUpImgArray"
            } else if 0 == photoTag {
                info = "未執行getSwipeUpImgArray，現在是第一張"
            }
        } else {
            info = "未執行getSwipeUpImgArray，arrImagesFromAlbum為空"
        }
        
        print("完成getSwipeUpImgArray")
        print("arrImageView狀態：\(arrImageView)")
        print("arrPhotoPath狀態：\(arrPhotoPath)")
        print("------------------以上-------------------")
        return [arrImageView,arrPhotoPath]
    }
    
    
    //MARK: - 建立右滑(丟垃圾桶arrImagesToTrash)
    func getSwipeRightArray()->Array<Array<Any>>{
        if !arrSelectedPHAsset.isEmpty {
            
            let selectedimage = arrSelectedPHAsset[photoTag]
            arrSelectedPHAsset.remove(at: photoTag)

            if leftOrRight {
                arrImagesToTrash.append(selectedimage)
                arrHistoryLogUndo.append(HistoryLog(historyTarget: .trasnCan, historyAction: .push, historyUIImage: selectedimage))
            } else {
                arrImagesToFolder1.append(selectedimage)
                arrHistoryLogUndo.append(HistoryLog(historyTarget: .folder1, historyAction: .push, historyUIImage: selectedimage))
            }

            if photoTag == arrSelectedPHAsset.count-1+1 {
                photoTag -= 1
                let element = arrImageView[3]
                arrImageView.remove(at: 3)
                arrImageView.insert(element, at: 6)
            } else {
                photoTag += 0
                let element = arrImageView[3]
                arrImageView.remove(at: 3)
                arrImageView.insert(element, at: 0)
                
            }
            
            for i in 0...6{
                if  0 <= photoTag+arrPhotoTagHelper[i] && photoTag+arrPhotoTagHelper[i] <= arrSelectedPHAsset.count-1 {
                    let tryGetImage = arrSelectedPHAsset[photoTag+arrPhotoTagHelper[i]]
                    arrPhotoPath[i] = tryGetImage
                } else {
                    arrPhotoPath[i] = nil
                }
            }
            info = "完成getSwipeRightArray"
        } else {
            info = "未執行getSwipeDownImgArray，arrImagesFromAlbum為空"
        }
        
        print("完成getSwipeRightArray")
        print("arrImageView狀態：\(arrImageView)")
        print("arrPhotoPath狀態：\(arrPhotoPath)")
        print("arrPhotoPath狀態：\(arrImagesToTrash)")
        print("------------------以上-------------------")
        return [arrImageView,arrPhotoPath,arrImagesToTrash]
    }
    
    //MARK: - 建立左滑(丟儲存區arrImagesToFolder1)
    func getSwipeLeftArray()->Array<Array<Any>>{

        if !arrSelectedPHAsset.isEmpty {

            let selectedimage = arrSelectedPHAsset[photoTag]
            arrSelectedPHAsset.remove(at: photoTag)

            if leftOrRight {
                arrImagesToFolder1.append(selectedimage)
                arrHistoryLogUndo.append(HistoryLog(historyTarget: .folder1, historyAction: .push, historyUIImage: selectedimage))
            } else {
                arrImagesToTrash.append(selectedimage)
                arrHistoryLogUndo.append(HistoryLog(historyTarget: .trasnCan, historyAction: .push, historyUIImage: selectedimage))
            }

            if photoTag == arrSelectedPHAsset.count-1+1 {
                photoTag -= 1
                let element = arrImageView[3]
                arrImageView.remove(at: 3)
                arrImageView.insert(element, at: 6)
            } else {
                photoTag += 0
                let element = arrImageView[3]
                arrImageView.remove(at: 3)
                arrImageView.insert(element, at: 0)
            }

            for i in 0...6{
                if  0 <= photoTag+arrPhotoTagHelper[i] && photoTag+arrPhotoTagHelper[i] <= arrSelectedPHAsset.count-1 {
                    let tryGetImage = arrSelectedPHAsset[photoTag+arrPhotoTagHelper[i]]
                    arrPhotoPath[i] = tryGetImage
                } else {
                    arrPhotoPath[i] = nil
                }
            }
            info = "完成getSwipeLeftArray"
        } else {
            info = "未執行getSwipeLeftArray，arrImagesFromAlbum為空"
        }
        
        print("完成getSwipeLeftArray")
        print("arrImageView狀態：\(arrImageView)")
        print("arrPhotoPath狀態：\(arrPhotoPath)")
        print("arrImagesToFolder1狀態：\(arrImagesToFolder1)")
        print("------------------以上-------------------")
        return [arrImageView,arrPhotoPath,arrImagesToFolder1]
    }
    
    
    //MARK: - 建立拖曳(丟儲存區arrImagesToKepp2)
    func getPanArray(togo:Folders)->Array<Array<Any>>{
        if !arrSelectedPHAsset.isEmpty {
            
            let selectedimage = arrSelectedPHAsset[photoTag]
            arrSelectedPHAsset.remove(at: photoTag)
            
            switch togo {
            case .folder1:
                arrImagesToFolder1.append(selectedimage)
                arrHistoryLogUndo.append(HistoryLog(historyTarget: .folder1, historyAction: .push, historyUIImage: selectedimage))
            case .folder2:
                arrImagesToFolder2.append(selectedimage)
                arrHistoryLogUndo.append(HistoryLog(historyTarget: .folder2, historyAction: .push, historyUIImage: selectedimage))
            case .trasnCan:
                arrImagesToTrash.append(selectedimage)
                arrHistoryLogUndo.append(HistoryLog(historyTarget: .trasnCan, historyAction: .push, historyUIImage: selectedimage))
            default:
                break
            }
            
            if photoTag == arrSelectedPHAsset.count-1+1 {
                photoTag -= 1
                let element = arrImageView[3]
                arrImageView.remove(at: 3)
                arrImageView.insert(element, at: 6)
            } else {
                photoTag += 0
                let element = arrImageView[3]
                arrImageView.remove(at: 3)
                arrImageView.insert(element, at: 0)
            }
            
            for i in 0...6{
                if  0 <= photoTag+arrPhotoTagHelper[i] && photoTag+arrPhotoTagHelper[i] <= arrSelectedPHAsset.count-1 {
                    let tryGetImage = arrSelectedPHAsset[photoTag+arrPhotoTagHelper[i]]
                    arrPhotoPath[i] = tryGetImage
                } else {
                    arrPhotoPath[i] = nil
                }
            }
            info = "完成getPanArray"
        } else {
            info = "未執行getPanArray，arrImagesFromAlbum為空"
        }
        
        print("完成getPanArray")
        print("imgview狀態：\(arrImageView)")
        print("PhotoPath狀態：\(arrPhotoPath)")
        print("------------------以上-------------------")
        return [arrImageView,arrPhotoPath]
    }
}


