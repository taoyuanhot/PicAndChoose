//
//  ViewController2.swift
//  photoTest
//
//  Created by 咪咪貓 on 2023/10/18.
//

import UIKit
import Photos

class ViewControllerTrashCan: UIViewController,UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    // MARK: - 物件宣告區
    //建立兩個按鍵的outlet到時候可以改文字
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var retrieveButton: UIButton!
    //設定collectionView的layout
    @IBOutlet weak var collectionView: UICollectionView!
    
    //建立一個ViewController
    var viewControllerIimgaesAnimation:ViewControllerIimgaesAnimation!
    
    //做出一個AlertTool實體
    var alertTool:AlertTool!
    var photoTool:PhotoTool!
    
    
    // MARK: - ViewdidLoad：
    //朱老師課本版本
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //讓collectionView變成多選
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        //初始化AlertTool實體
        alertTool = AlertTool(viewController: self)
        photoTool = PhotoTool(viewController: self)
        
        collectionView.reloadData()
        adjustButtonMode()
    }
    
    // MARK: - IBAction：

    //IBAction按下retrieveButton的反應
    @IBAction func clickButtonRetrieve(_ sender: UIButton) {
        //判斷現在的狀態
        if retrieveButton.titleLabel?.text == "恢復全部" {
            //跳出Alert，按下確定後執行retriveAll()
            alertTool.alertCreater(title: "確定要恢復全部共\(arrImagesToTrash.count)張照片嗎？", message: "", button_qty: 2, button_title_1: "取消", function_1: nil, button_title_2: "確定", function_2:retriveAll)
        } else if retrieveButton.titleLabel?.text == "恢復已選" {
            //跳出Alert，按下確定後執行retriveSelected()
            alertTool.alertCreater(title: "確定要恢復已選共\(arrImagesToTrashReadyToActing.count)張照片嗎？", message: "", button_qty: 2, button_title_1: "取消", function_1: nil, button_title_2: "確定", function_2: retriveSelected)
        }
    }
    
    //IBAction按下deleteButton的反應
    @IBAction func clickButtonDelete(_ sender: UIButton) {
        //判斷現在的狀態
        if deleteButton.titleLabel?.text == "刪除全部" {
            //跳出Alert，按下確定後執行deleteAll()
            alertTool.alertCreater(title: "確定要刪除全部共\(arrImagesToTrash.count)張照片嗎？", message: "", button_qty: 2, button_title_1: "取消", function_1: nil, button_title_2: "確定", function_2:deleteAll)
        } else if deleteButton.titleLabel?.text == "刪除已選" {
            //跳出Alert，按下確定後執行deleteSelected()
            alertTool.alertCreater(title: "確定要刪除已選共\(arrImagesToTrashReadyToActing.count)張照片嗎？", message: "", button_qty: 2, button_title_1: "取消", function_1: nil, button_title_2: "確定", function_2: deleteSelected)
        }
    }
    
    //IBAction按下returnClick的反應
    @IBAction func clickButtonReturn(_ sender: UIButton) {
        print("你按下Return")
        viewControllerIimgaesAnimation.aTTool.setLocationToCenter()
        viewControllerIimgaesAnimation.aTTool.setLocationRestart()
        self.dismiss(animated: true)
    }
    
    func dismissWhenEmpty(){
        if arrImagesToTrash.isEmpty {
            viewControllerIimgaesAnimation.aTTool.setLocationToCenter()
            viewControllerIimgaesAnimation.aTTool.setLocationRestart()
            self.dismiss(animated: true)
        }
    }
    
    //建立功能：調整兩個Button文字
    func adjustButtonMode(){
        if arrImagesToTrashReadyToActing.count > 0 {
            deleteButton.setTitle("刪除已選", for: UIControl.State.normal)
            retrieveButton.setTitle("恢復已選", for: UIControl.State.normal)
        } else {
            deleteButton.setTitle("刪除全部", for: UIControl.State.normal)
            retrieveButton.setTitle("恢復全部", for: UIControl.State.normal)
        }
        self.view.setNeedsDisplay()
    }
    
    //建立功能：刪除所有的照片
    func deleteAll(){

        //調整Arr的狀態
        arrImagesToTrash.removeAll()
        //更新collectionView與button文字
        collectionView.reloadData()
        adjustButtonMode()
        //跳出Alert，回報執行成果
        alertTool.alertCreater(title: "刪除成功", message: "", button_qty: 1, button_title_1: "OK",function_1:dismissWhenEmpty)
    }
    
    //建立功能：刪除所選的照片
    func deleteSelected(){
        
        //調整兩個Arr的狀態
        arrImagesToTrash = arrImagesToTrash.filter {!arrImagesToTrashReadyToActing.contains($0)}
        arrImagesToTrashReadyToActing.removeAll()
        //更新collectionView與button文字
        collectionView.reloadData()
        adjustButtonMode()
        //跳出Alert，回報執行成果
        alertTool.alertCreater(title: "刪除成功", message: "", button_qty: 1, button_title_1: "OK",function_1:dismissWhenEmpty)
    }
    
    //建立功能：恢復全部的照片
    func retriveAll(){
        //真的把相片恢復
        arrSelectedPHAsset.append(contentsOf: arrImagesToTrash)
        //調整兩個Arr的狀態
        arrImagesToTrash.removeAll()
        //更新collectionView與button文字
        collectionView.reloadData()
        adjustButtonMode()
        //todo :回復到主畫面的img陣列
        alertTool.alertCreater(title: "恢復成功", message: "", button_qty: 1, button_title_1: "OK",function_1:dismissWhenEmpty)
    }
    
    //建立功能：恢復所選的照片
    func retriveSelected(){
        //真的把相片恢復
        arrSelectedPHAsset.append(contentsOf: arrImagesToTrashReadyToActing)
        //調整兩個Arr的狀態
        arrImagesToTrash = arrImagesToTrash.filter {!arrImagesToTrashReadyToActing.contains($0)}
        arrImagesToTrashReadyToActing.removeAll()
        //更新collectionView與button文字
        collectionView.reloadData()
        adjustButtonMode()
        //todo :回復到主畫面的img陣列
        alertTool.alertCreater(title: "恢復成功", message: "", button_qty: 1, button_title_1: "OK",function_1:dismissWhenEmpty)
    }
    
    // MARK: - Collection設定：
    // MARK: 第一階段：有幾個區段
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: 第二階段：每個區段有幾筆資料
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImagesToTrash.count
    }
    
    // MARK: 第三階段：每筆資料內容為何
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //用dequeue的方式把Cell添加進來
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath
        )
        //把邊邊變成圓角
        cell.layer.cornerRadius = 6
        //用於控制圖層的邊界。當這個屬性設置為 true 時，圖層的子圖層將被裁剪到圖層的邊界內。
        cell.layer.masksToBounds = true
        
        
        //放自己做的object，我這邊放了兩個
        //這是CustomCell的那張照片
        let imageView = cell.viewWithTag(100) as! UIImageView
//        imageView.image = getImageFromPHAsset(arrImagesToTrash[indexPath.row])
        imageView.image = arrImagesToTrash[indexPath.row]
        //調整成UIImage
        imageView.contentMode = .scaleToFill
        //這是一個平常隱藏，被選擇時會顯示的那個圈圈
        let checkmark = cell.viewWithTag(101) as! UIImageView
        checkmark.isHidden = true
        
        return cell
    }
    
    //把PHAsset轉成UIImage
    func getImageFromPHAsset(_ asset: PHAsset) -> UIImage? {
        var image: UIImage?
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()

        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat

        imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: requestOptions) { (result, _) in
            image = result
            dispatchGroup.leave()
        }
        dispatchGroup.wait()
        return image
    }
    
    // MARK: 點選效果
    //弄出點選後會產生勾選的效果
    //按下Cell後的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at indexPath: \(indexPath)")
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.isSelected = true
            //取消選取時將checkmark顯示。
            let checkmark = cell.viewWithTag(101) as! UIImageView
            checkmark.isHidden = false
            //選取時將images放到暫存區selectedImages：[UIImage]。
            let choosedPHAsset = arrImagesToTrash[indexPath.row]
            arrImagesToTrashReadyToActing.append(choosedPHAsset)
            print(arrImagesToTrashReadyToActing)
        }
        adjustButtonMode()
    }
    
    //取消按下Cell後的動作
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("Deselected item at indexPath: \(indexPath)")
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.isSelected = false
            //取消選取時將checkmark隱藏。
            let checkmark = cell.viewWithTag(101) as! UIImageView
            checkmark.isHidden = true
            //取消選取時將images移出暫存區selectedImages：[UIImage]。
            let choosedPHAsset = arrImagesToTrash[indexPath.row]
            arrImagesToTrashReadyToActing.removeAll(where: { $0 == choosedPHAsset })
            print(arrImagesToTrashReadyToActing)
        }
        adjustButtonMode()
    }
    
    // MARK: Function管理Layout
    private func resizeCell(_ pieces: CGFloat, minSpacing: CGFloat,leftEdge:CGFloat,rightEdge:CGFloat,top:CGFloat,bottom:CGFloat) {
        //建立一個collectionViewLatout的實體來管理
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //將layout設定成垂直的滑動的scrollView
        layout.scrollDirection = .vertical
        //設定Cell在CollectionView的左邊界，右邊邊界有滑桿區已經有空隙
        let leftEdge:CGFloat = leftEdge
        let rightEdge:CGFloat = rightEdge
        layout.sectionInset = UIEdgeInsets(top: -50+top, left: leftEdge, bottom: -60+bottom, right: rightEdge)
        // 取得 Collection View 寬度
        let length:CGFloat! = collectionView.bounds.width-leftEdge-rightEdge
        // 計算 Cell 寬度
        let width = floor(
            ((length) - (pieces - 1) * minSpacing) / pieces
        )
        // 計算儲存隔間的實際間距
        let realSpacing = floor(
            ((length) - pieces * width) / (pieces - 1)
        )
        //設定Cell的尺寸
        layout.itemSize = CGSize(width: width, height: width)
        //按照AutoLayout去排
        layout.estimatedItemSize = .zero
        //設定Cell之間的Spaceing
        layout.minimumInteritemSpacing = realSpacing
        layout.minimumLineSpacing = realSpacing
    }
    
    
    // MARK: - ViewDidLayoutSubview
    //在viewDidLayoutSubview設定每一排的數量跟間距。
    override func viewDidLayoutSubviews() {
        resizeCell(3, minSpacing: 8, leftEdge: 10, rightEdge: 10,top:12,bottom:20)
        
//        //按照不同裝置設定
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            //為iphone客製化版面
//            //按照不同方向客製版面
//            let orientation = UIDevice.current.orientation
//            if orientation == .portrait {
//                resizeCell(3, minSpacing: 8, leftEdge: 10, rightEdge: 10,top:12,bottom:20)
//            } else if orientation == .portraitUpsideDown {
//                resizeCell(3, minSpacing: 8, leftEdge: 10, rightEdge: 10,top:12,bottom:20)
//            } else if orientation == .landscapeLeft || orientation == .landscapeRight {
//                resizeCell(4, minSpacing: 10, leftEdge: 12, rightEdge: 12,top:12,bottom:20)
//            }
//        } 
//        else if UIDevice.current.userInterfaceIdiom == .pad {
//            //為iphone客製化版面
//            //按照不同方向客製版面
//            let orientation = UIDevice.current.orientation
//            if orientation == .portrait {
//                resizeCell(5, minSpacing: 8, leftEdge: 10, rightEdge: 10,top:12,bottom:20)
//            } else if orientation == .portraitUpsideDown {
//                resizeCell(5, minSpacing: 8, leftEdge: 10, rightEdge: 10,top:12,bottom:20)
//            } else if orientation == .landscapeLeft || orientation == .landscapeRight {
//                resizeCell(7, minSpacing: 10, leftEdge: 12, rightEdge: 12,top:12,bottom:20)
//            }
//        }
    }
}
