//
//  ViewControllerIimgaesAnimation.swift
//  photoTest
//
//  Created by Jonah Chou on 2023/10/23.
//


import UIKit
import PhotosUI

class ViewControllerIimgaesAnimation: UIViewController , UIGestureRecognizerDelegate {
    
    
    // MARK: - 物件宣告區
    @IBOutlet weak var img7:UIImageView!
    @IBOutlet weak var img6:UIImageView!
    @IBOutlet weak var img5:UIImageView!
    @IBOutlet weak var img4:UIImageView!
    @IBOutlet weak var img3:UIImageView!
    @IBOutlet weak var img2:UIImageView!
    @IBOutlet weak var img1:UIImageView!
    
    //建立工具的實體
    var imgsArrayTool = ImgsArrayTool7()
    var aTTool:ATTool7!
    var alertTool:AlertTool!
    var photoTool:PhotoTool!
    
    //建立拖曳的反應區
    @IBOutlet weak var folder2Area: UIView!
    @IBOutlet weak var folder1Area: UIView!
    @IBOutlet weak var trashArea: UIView!
    //建立一個Timer
    var timer:Timer! = nil
    
    //建立button的物件才能改label name = real folderName
    @IBOutlet weak var imgNoticeDeleteRight: UIImageView!
    @IBOutlet weak var imgNoticeKeepRight: UIImageView!
    @IBOutlet weak var imgNoticeDeleteLeft: UIImageView!
    @IBOutlet weak var imgNoticeKeepLeft: UIImageView!
    @IBOutlet weak var imgNoticeSave: UIImageView!
    @IBOutlet weak var selectedListView: UIView!
    
    //
    @IBOutlet weak var saveIn1: UIButton!
    @IBOutlet weak var saveIn2: UIButton!
    @IBOutlet weak var saveIn3: UIButton!
    
    
    // MARK: - Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化工具
        aTTool = ATTool7(viewController: self, img7: img7,img6: img6, img5: img5, img4: img4, img3: img3, img2: img2, img1: img1)
        alertTool = AlertTool(viewController: self)
        photoTool = PhotoTool(viewController: self)
        
        //調整拖曳區的位置
        folder1Area.frame = CGRect(
            x: 0,
            y: Int(view.bounds.height-110),
            width: Int(view.bounds.width*0.25),
            height: 110
        )
        
        folder2Area.frame = CGRect(
            x: Int(view.bounds.width*0.25),
            y: Int(view.bounds.height-110),
            width: Int(view.bounds.width*0.25),
            height: 110
        )
        
        trashArea.frame = CGRect(
            x: Int(view.bounds.width*0.75),
            y: Int(view.bounds.height-110),
            width: Int(view.bounds.width*0.25),
            height: 110
        )
        
        
        //
        imgNoticeSave.isHidden = true
        imgNoticeSave.isUserInteractionEnabled = false
        imgNoticeSave.alpha = 0.0
        imgNoticeDeleteLeft.isHidden = true
        imgNoticeDeleteLeft.isUserInteractionEnabled = false
        imgNoticeDeleteLeft.alpha = 0.0
        imgNoticeKeepLeft.isHidden = true
        imgNoticeKeepLeft.isUserInteractionEnabled = false
        imgNoticeKeepLeft.alpha = 0.0
        imgNoticeDeleteRight.isHidden = true
        imgNoticeDeleteRight.isUserInteractionEnabled = false
        imgNoticeDeleteRight.alpha = 0.0
        imgNoticeKeepRight.isHidden = true
        imgNoticeKeepRight.isUserInteractionEnabled = false
        imgNoticeKeepRight.alpha = 0.0
        selectedListView.isUserInteractionEnabled = false
        selectedListView.isHidden = true
        selectedListView.alpha = 0.0
        selectedListView.layer.cornerRadius = 10.0
        selectedListView.layer.masksToBounds = true
        
        let arrSaveIn = [saveIn1,
                         saveIn2,
                         saveIn3]
        
        if !arrFolderNameSelected.isEmpty {
            for i in 0...arrFolderNameSelected.count-1 {
                if !arrFolderNameSelected[i].isEmpty {
                    arrSaveIn[i]!.setTitle(arrFolderNameSelected[i], for: .normal)
                } else {
                    arrSaveIn[i]!.setTitle("未設定", for: .normal)
                }
            }
        }

        
        
        
        //先把照片叫回中央再來到指定位置
        print("getImgToArrMain Start")
        if let imageMainFolderPath = Bundle.main.path(forResource: "ImageMain", ofType: nil) {
            do {
                // 获取文件夹中的文件列表
                let fileURLs = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: imageMainFolderPath), includingPropertiesForKeys: nil)
                
                // 遍历文件夹中的 JPEG 文件
                for fileURL in fileURLs {
                    if fileURL.pathExtension.lowercased() == "jpg" || fileURL.pathExtension.lowercased() == "jpeg" {
                        // 使用 UIImage 初始化方法加载 JPEG 文件
                        if let image = UIImage(contentsOfFile: fileURL.path) {
                            // 将加载的 UIImage 添加到 arrUIImageMain 数组中
                            arrSelectedPHAsset.append(image)
                        }
                    }
                }
                
                print("arrSelectedPHAsset:\(arrSelectedPHAsset)")
            } catch {
                print("Error reading contents of directory: \(error)")
            }
        } else {
            print("Bundle.main.path沒找到ImageMain")
        }
        
        aTTool.setLocationToCenter()
        aTTool.setLocationRestart()
        
        //手動建立手勢（1）:panGesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        //手動建立手勢（1）:swipeUp
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUpGesture(_:)))
        swipeUpGesture.direction = .up
        swipeUpGesture.delegate = self
        view.addGestureRecognizer(swipeUpGesture)
        
        //手動建立手勢（1）:swipeDown
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDownGesture(_:)))
        swipeDownGesture.direction = .down
        swipeDownGesture.delegate = self
        view.addGestureRecognizer(swipeDownGesture)
        
        //手動建立手勢（1）:swipeLeft
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeftGesture(_:)))
        swipeLeftGesture.direction = .left
        swipeLeftGesture.delegate = self
        view.addGestureRecognizer(swipeLeftGesture)
        
        //手動建立手勢（1）:swipeRight
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRightGesture(_:)))
        swipeRightGesture.direction = .right
        swipeRightGesture.delegate = self
        view.addGestureRecognizer(swipeRightGesture)
        
        //ReloadData
        aTTool.setLocationByArray(imgsArrayTool.getReStartImgsArray(), ATTool7.手勢動作.沒動作)
        
    }
    
    func showNoticeImage(selectedNoticeImage:UIImageView){
        self.view.bringSubviewToFront(selectedNoticeImage)
        selectedNoticeImage.isHidden = false
        UIView.animate(
            withDuration: 0.5,
            animations:
                {
                    selectedNoticeImage.alpha = 1.0
                })
        {
            (finished)
            in
            UIView.animate(
                withDuration: 0.5,
                animations:
                    {
                        selectedNoticeImage.alpha = 0.0
                    })
            {
                (finished)
                in
                selectedNoticeImage.isHidden = true
            }
        }
    }
    
    
    // MARK: - 手勢區
    //手動建立手勢（2）:判斷器
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: 上滑功能：
    //手動建立手勢（3）: objc swipeUp功能(上滑)
    @objc func handleSwipeUpGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if aTTool.checkIsNotAnimating() {
            aTTool.setLocationUp()
        }
        print("完成swipeUp")
    }
    
    // MARK: 下滑功能：
    //手動建立手勢（3）: objc swipeDown功能(下滑)
    @objc func handleSwipeDownGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if aTTool.checkIsNotAnimating() {
            aTTool.setLocationDown()
        }
        
        print("完成swipeDown")
    }
    
    
    // MARK: 建立左滑動功能
    //手動建立手勢（3）: objc swipeLeft功能(左滑)
    @objc func handleSwipeLeftGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        
        if aTTool.checkIsNotAnimating() {
            if leftOrRight {
                //如果右滑動刪除照片，左滑動就是要進到folder1
                self.showNoticeImage(selectedNoticeImage: self.imgNoticeKeepLeft)
                aTTool.setLocationLeft()
            } else {
                //如果左滑動刪除照片，左滑動就是要進到垃圾桶
                self.showNoticeImage(selectedNoticeImage: self.imgNoticeDeleteLeft)
                aTTool.setLocationLeft()
            }
        }
        print("完成swipeLeft")
    }
    
    // MARK: 建立右滑動功能
    //手動建立手勢（3）: objc swipeRight功能(右滑)
    @objc func handleSwipeRightGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        
        if aTTool.checkIsNotAnimating() {
            if leftOrRight {
                //如果右滑動刪除照片，右滑動就是要進到trash
                self.showNoticeImage(selectedNoticeImage: self.imgNoticeDeleteRight)
                aTTool.setLocationRight()
            } else {
                //如果右滑動不是刪除照片，右滑動就是要進到folder1
                self.showNoticeImage(selectedNoticeImage: self.imgNoticeKeepRight)
                aTTool.setLocationRight()
            }
        }
        print("完成swipeRight")
    }
    
    // MARK: - 建立拖曳功能
    
    //手動建立手勢（3）: objc PanGesture功能(拖曳)
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        if aTTool.checkIsNotAnimating() {
            print("拖曳進行中")
            //選擇照片
            var img:UIImageView!
            let imgRow = arrImageView[3]
            if imgRow == "img7"{
                img = img7
            } else if imgRow == "img6"{
                img = img6
            } else if imgRow == "img5"{
                img = img5
            } else if imgRow == "img4" {
                img = img4
            } else if imgRow == "img3" {
                img = img3
            } else if imgRow == "img2" {
                img = img2
            } else if imgRow == "img1" {
                img = img1
            }
            
            //拖曳時img的位置跟著改變
            let translation = gestureRecognizer.translation(in: img)
            if let view = img {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
                gestureRecognizer.setTranslation(CGPoint.zero, in: view)
            }
            
            if gestureRecognizer.state == .ended {
                let location = gestureRecognizer.location(in: view)
                if trashArea.frame.contains(location) {
                    //                    aTTool.縮小到不見(img,togo: .trasnCan)
                    //調整成UIImage
                    
                    if !arrFolderNameSelected.isEmpty {
                        self.showNoticeImage(selectedNoticeImage:self.imgNoticeSave)
                        aTTool.縮小到不見(img,togo: .folder2)
                    } else {
                        aTTool.setPhotoLocation(img!, aTTool.arrLocationMap[3], aTTool.arrSizeMap[3])
                        alertTool.alertCreater(title: "未設置相簿", message: "請點選右下角齒輪按鈕->Setting->相簿列表，點選您要選擇的資料夾。", button_qty: 1, button_title_1: "OK", function_1: nil)
                    }
                    
                } else {
                    //如果沒有拖曳到指定位置就回到原位
                    aTTool.setPhotoLocation(img!, aTTool.arrLocationMap[3], aTTool.arrSizeMap[3])
                }
            }
        }
        print("完成PanGesture")
    }
    
    
    // MARK: - Folder
    @IBAction func clickButtonUndo(_ sender: UIButton) {
        print("按下Undo")
        if !arrHistoryLogUndo.isEmpty {
            switch arrHistoryLogUndo.last?.historyAction {
            case .push:
                //原本動作是把照片推出去，undo要反過來，把照片拉進來
                let selectedUIImage = arrHistoryLogUndo.last?.historyUIImage
                arrSelectedPHAsset.append(selectedUIImage!)
                //arrHistoryLogRedo把反過來的行為紀錄上去
                var reversAction:Action!
                if arrHistoryLogUndo.last?.historyAction == Action.pull {
                    reversAction = Action.push
                } else if arrHistoryLogUndo.last?.historyAction == Action.push {
                    reversAction = Action.pull
                }
                arrHistoryLogRedo.append(
                    HistoryLog(
                        //來源一樣
                        historyTarget: arrHistoryLogUndo.last?.historyTarget,
                        //反過來紀錄
                        historyAction: reversAction,
                        //同一張照片
                        historyUIImage: arrHistoryLogUndo.last?.historyUIImage
                    )
                )
                
                //調整照片拉進來的Array
                if arrHistoryLogUndo.last?.historyTarget == .folder1 {

                        arrImagesToFolder1.removeLast()

                } else if arrHistoryLogUndo.last?.historyTarget == .folder2 {
  
                        arrImagesToFolder2.removeLast()

                } else if arrHistoryLogUndo.last?.historyTarget == .trasnCan {

                        arrImagesToTrash.removeLast()
   
                } else if arrHistoryLogUndo.last?.historyTarget == .imagePicker {
                    break
                }
                
                //arrHistoryLogUedo的最後一個回溯完了，可以刪掉了
    
                    arrHistoryLogUndo.removeLast()

                
            case .pull:
                //原本動作是把照片拉進來，undo要反過來，把照片推出去
                arrSelectedPHAsset.removeLast()
                //arrHistoryLogRedo把反過來的行為紀錄上去
                var reversAction:Action!
                if arrHistoryLogUndo.last?.historyAction == Action.pull {
                    reversAction = Action.push
                } else if arrHistoryLogUndo.last?.historyAction == Action.push {
                    reversAction = Action.pull
                }
                arrHistoryLogRedo.append(
                    HistoryLog(
                        //來源一樣
                        historyTarget: arrHistoryLogUndo.last?.historyTarget,
                        //反過來紀錄
                        historyAction: reversAction,
                        //同一張照片
                        historyUIImage: arrHistoryLogUndo.last?.historyUIImage
                    )
                )
                
                //調整照片推出去的Array
                let selectedUIImage = arrHistoryLogUndo.last?.historyUIImage
                if arrHistoryLogUndo.last?.historyTarget == .folder1 {
                    arrImagesToFolder1.append(selectedUIImage!)
                } else if arrHistoryLogUndo.last?.historyTarget == .folder2 {
                    arrImagesToFolder2.append(selectedUIImage!)
                } else if arrHistoryLogUndo.last?.historyTarget == .trasnCan {
                    arrImagesToTrash.append(selectedUIImage!)
                } else if arrHistoryLogUndo.last?.historyTarget == .imagePicker {
                    break
                }
                
                //arrHistoryLogUedo的最後一個回溯完了，可以刪掉了
                    arrHistoryLogUndo.removeLast()

                
            default:
                break
            }
        } else {
            print("沒有上一個動作")
            alertTool.alertCreater(title: "沒有上一個動作了", message: "", button_qty: 1, button_title_1: "OK", function_1: nil)
        }
        
        aTTool.setLocationToCenter()
        aTTool.setLocationRestart()
        
        print("arrSelectedPHAsset:\(arrSelectedPHAsset)")
        print("arrImagesToTrash:\(arrImagesToTrash)")
        print("arrHistoryLogUndo:\(arrHistoryLogUndo)")
        print("arrHistoryLogRedo:\(arrHistoryLogRedo)")
        
    }
    
    @IBAction func clickButtonRedo(_ sender: UIButton) {
        print("按下Redo")
        if !arrHistoryLogRedo.isEmpty {
            switch arrHistoryLogRedo.last?.historyAction {
            case .push:
                //原本動作是把照片推出去，undo要反過來，把照片拉進來
                let selectedUIImage = arrHistoryLogRedo.last?.historyUIImage
                arrSelectedPHAsset.append(selectedUIImage!)
                //arrHistoryLogUndo把反過來的行為紀錄上去
                var reversAction:Action!
                if arrHistoryLogRedo.last?.historyAction == Action.pull {
                    reversAction = Action.push
                } else if arrHistoryLogRedo.last?.historyAction == Action.push {
                    reversAction = Action.pull
                }
                arrHistoryLogUndo.append(
                    HistoryLog(
                        //來源一樣
                        historyTarget: arrHistoryLogRedo.last?.historyTarget,
                        //反過來紀錄
                        historyAction: reversAction,
                        //同一張照片
                        historyUIImage: arrHistoryLogRedo.last?.historyUIImage
                    )
                )
                
                //調整照片拉進來的Array
                if arrHistoryLogRedo.last?.historyTarget == .folder1 {
                    arrImagesToFolder1.removeLast()
                } else if arrHistoryLogRedo.last?.historyTarget == .folder2 {
                    arrImagesToFolder2.removeLast()
                } else if arrHistoryLogRedo.last?.historyTarget == .trasnCan {
                    arrImagesToTrash.removeLast()
                } else if arrHistoryLogRedo.last?.historyTarget == .imagePicker {
                    break
                }
                
                //arrHistoryLogUedo的最後一個回溯完了，可以刪掉了
                arrHistoryLogRedo.removeLast()
                
            case .pull:
                //原本動作是把照片拉進來，undo要反過來，把照片推出去
                arrSelectedPHAsset.removeLast()
                //arrHistoryLogUndo把反過來的行為紀錄上去
                var reversAction:Action!
                if arrHistoryLogRedo.last?.historyAction == Action.pull {
                    reversAction = Action.push
                } else if arrHistoryLogRedo.last?.historyAction == Action.push {
                    reversAction = Action.pull
                }
                arrHistoryLogUndo.append(
                    HistoryLog(
                        //來源一樣
                        historyTarget: arrHistoryLogRedo.last?.historyTarget,
                        //反過來紀錄
                        historyAction: reversAction,
                        //同一張照片
                        historyUIImage: arrHistoryLogRedo.last?.historyUIImage
                    )
                )
                
                //調整照片推出去的Array
                let selectedUIImage = arrHistoryLogRedo.last?.historyUIImage
                if arrHistoryLogRedo.last?.historyTarget == .folder1 {
                    arrImagesToFolder1.append(selectedUIImage!)
                } else if arrHistoryLogRedo.last?.historyTarget == .folder2 {
                    arrImagesToFolder2.append(selectedUIImage!)
                } else if arrHistoryLogRedo.last?.historyTarget == .trasnCan {
                    arrImagesToTrash.append(selectedUIImage!)
                } else if arrHistoryLogRedo.last?.historyTarget == .imagePicker {
                    break
                }
                
                //arrHistoryLogUedo的最後一個回溯完了，可以刪掉了
                arrHistoryLogRedo.removeLast()
                
            default:
                break
            }
        } else {
            print("沒有下一個動作")
            alertTool.alertCreater(title: "沒有下一個動作了", message: "", button_qty: 1, button_title_1: "OK", function_1: nil)
        }
        
        aTTool.setLocationToCenter()
        aTTool.setLocationRestart()
        
        print("arrSelectedPHAsset:\(arrSelectedPHAsset)")
        print("arrImagesToTrash:\(arrImagesToTrash)")
        print("arrHistoryLogUndo:\(arrHistoryLogUndo)")
        print("arrHistoryLogRedo:\(arrHistoryLogRedo)")
        
    }
    
    // MARK: - 離開按鈕
    
    @IBAction func clickButtonLeaving(_ sender: UIButton) {
        print("按下Leaving")
        //選了照片之後要確認imgsArrayTool.arrImagesToTrash.isEmpity
        if arrImagesToTrash.isEmpty && arrImagesToFolder1.isEmpty && arrImagesToFolder2.isEmpty  {
            //離開並關閉『Pic&Choose』? 確定/取消
            alertTool.alertCreater(title: "離開並關閉『Pic&Choose』?", message: "", button_qty: 2, button_title_1: "取消", function_1: nil, button_title_2: "確定", function_2: exitApp)
        }
        
        if !arrImagesToTrash.isEmpty {
            //結束編輯並刪除照片？確認離開將從裝置刪除垃圾桶內的n張影像。確定/取消
            alertTool.alertCreater(title: "結束編輯並刪除照片？", message: "確認離開將從裝置刪除垃圾桶內的\(arrImagesToTrash.count)張影像", button_qty: 2, button_title_1: "取消", function_1: nil, button_title_2: "確定", function_2: deleteAll)
        }
    }
    
    func exitApp(){
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    }
    
    
    
    // MARK: - 進入設定頁面
    @IBAction func clickButtonTrash(_ sender: UIButton) {
        print("按下TrashCan")
        self.performSegue(withIdentifier: "segueToViewControllerTrashCan", sender: nil)
    }
    
    
    // MARK: - 相簿功能
    @IBAction func clickButtonAlbum(_ sender: UIButton) {
        //打開Photo
        print(">>>>>>choosePhotos開始")
        photoTool.openUIImagePickerController(){
            self.aTTool.setLocationToCenter(){
                self.aTTool.setLocationByArray(self.imgsArrayTool.getReStartImgsArray(), ATTool7.手勢動作.沒動作){
                    self.aTTool.setLocationToCenter(){
                        self.aTTool.setLocationByArray(self.imgsArrayTool.getReStartImgsArray(), ATTool7.手勢動作.沒動作)
                    }
                }
                print("choosePhotos結束<<<<<<")
            }
        }
    }
    
    
    // MARK: - 進入垃圾桶頁面
    
    @IBAction func clickButtonSetting(_ sender: UIButton) {
        print("按下Setting")
        self.performSegue(withIdentifier: "segueToViewControllerSetting", sender: nil)
    }
    
    // MARK: - 換頁資料轉移
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if segue.identifier == "segueToViewControllerTrashCan" {
            let viewControllerTrashCan = segue.destination as! ViewControllerTrashCan
            viewControllerTrashCan.viewControllerIimgaesAnimation = self
        } else if segue.identifier == "segueToViewControllerSetting" {
            let viewControllerSetting = segue.destination as! ViewControllerSetting
            viewControllerSetting.viewControllerIimgaesAnimation = self
        }
    }
    
    func deleteAll(){
        //調整Arr的狀態
        arrImagesToTrash.removeAll()
        //跳出Alert，回報執行成果
        alertTool.alertCreater(title: "刪除成功", message: "", button_qty: 1, button_title_1: "OK")
    }
    
    func saveAll1(){

        //調整Arr的狀態
        arrImagesToFolder1.removeAll()
        //跳出Alert，回報執行成果
        alertTool.alertCreater(title: "儲存成功", message: "", button_qty: 1, button_title_1: "OK")
    }
    
    func saveAll2(){
        
        //調整Arr的狀態
        arrImagesToFolder2.removeAll()
        //跳出Alert，回報執行成果
        alertTool.alertCreater(title: "儲存成功", message: "", button_qty: 1, button_title_1: "OK")
    }
    
    
    @IBAction func clickSaveIn(_ sender: UIButton) {
        self.view.bringSubviewToFront(self.selectedListView)
        if selectedListView.isHidden {
            self.selectedListView.isHidden = false
            UIView.animate(
                withDuration: 0.5,
                animations:{self.selectedListView.alpha = 1.0}){(finished) in
                self.selectedListView.isUserInteractionEnabled = true
            }
        } else {
            UIView.animate(
                withDuration: 0.5,
                animations:{self.selectedListView.alpha = 0.0}){(finished) in
                self.selectedListView.isHidden = true
                self.selectedListView.isUserInteractionEnabled = false
            }
        }
    }
    
    @IBAction func clickSaveIn1(_ sender: UIButton) {
        print("choosed SaveIn1")
        if !selectedListView.isHidden {
            UIView.animate(
                withDuration: 0.5,
                animations:{self.selectedListView.alpha = 0.0}){(finished) in
                    self.selectedListView.isHidden = true
                    self.selectedListView.isUserInteractionEnabled = false
                }
        }
    }
    @IBAction func clickSaveIn2(_ sender: UIButton) {
        print("choosed SaveIn2")
        if !selectedListView.isHidden {
            UIView.animate(
                withDuration: 0.5,
                animations:{self.selectedListView.alpha = 0.0}){(finished) in
                    self.selectedListView.isHidden = true
                    self.selectedListView.isUserInteractionEnabled = false
                }
        }
    }
    @IBAction func clickSaveIn3(_ sender: UIButton) {
        print("choosed SaveIn3")
        if !selectedListView.isHidden {
            UIView.animate(
                withDuration: 0.5,
                animations:{self.selectedListView.alpha = 0.0}){(finished) in
                    self.selectedListView.isHidden = true
                    self.selectedListView.isUserInteractionEnabled = false
                }
        }
    }
    
    
}




