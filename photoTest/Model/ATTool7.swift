//
//  ATTool.swift
//  photoTest
//
//  Created by 咪咪貓 on 2023/10/30.
//

//＊＊是對應不同VC使用時要做的修改
//％％是增刪UIImageView陣列數量的部分

import Foundation
import UIKit
import Photos
class ATTool7 {
    
    // MARK: - 動畫模組
    
    //**
    var viewController:ViewControllerIimgaesAnimation
    //%%增加兩個UIImageView
    var img7: UIImageView!
    var img6: UIImageView!
    var img5: UIImageView!
    var img4: UIImageView!
    var img3: UIImageView!
    var img2: UIImageView!
    var img1: UIImageView!
    
    //%%增加兩個UIImageView進init方法
    //**
    init(viewController: ViewControllerIimgaesAnimation, img7: UIImageView,img6: UIImageView,img5: UIImageView, img4: UIImageView, img3: UIImageView, img2: UIImageView, img1: UIImageView) {
        self.viewController = viewController
        self.img7 = img7
        self.img6 = img6
        self.img5 = img5
        self.img4 = img4
        self.img3 = img3
        self.img2 = img2
        self.img1 = img1
        
        self.螢幕寬 = viewController.view.frame.width
        self.螢幕高 = viewController.view.frame.height
        self.照片區高 = 螢幕高 - 上條高 - 下條高 - 安全寬*2
        self.照片基礎高 = 照片區高/((中照片比*中照片裸露比)+(旁照片比*旁照片裸露比)+(旁旁照片比*旁旁照裸露比))
    }
    
    //計算位置用
    var 螢幕寬:CGFloat!
    var 螢幕高:CGFloat!
    var 上條高 = CGFloat(120)
    var 下條高 = CGFloat(100)
    var 安全寬 = CGFloat(20)
    var 照片區高:CGFloat!
    var 中照片比 = CGFloat(1)
    var 旁照片比 = CGFloat(0.85)
    var 旁旁照片比 = CGFloat(0.75)
    var 中照片裸露比 = CGFloat(1)
    var 旁照片裸露比 = CGFloat(1)
    var 旁旁照裸露比 = CGFloat(2/3)
    var 照片基礎高:CGFloat!
    
    
    // MARK: 建立位置的架構
    //%%增加下下下 上上上
    enum 要移動的位置 {
        case 下下下
        case 下下
        case 下
        case 中
        case 上
        case 上上
        case 上上上
        case 右
        case 左
    }
    
    //%%增加旁旁旁
    enum  要變化尺寸 {
        case 旁旁旁
        case 旁旁
        case 旁
        case 中
        case 左右
    }
    
    enum  手勢動作 {
        case 向上
        case 向下
        case 向左
        case 向右
        case 拖曳
        case 沒動作
    }

    // MARK: 協助後續array可以抓到對應位置
    //%%增加下下下 上上上 跟 旁旁旁
    let arrLocationMap = [要移動的位置.下下下,要移動的位置.下下,要移動的位置.下,要移動的位置.中,要移動的位置.上,要移動的位置.上上,要移動的位置.上上上,要移動的位置.左,要移動的位置.右]
    let arrSizeMap = [要變化尺寸.旁旁旁,要變化尺寸.旁旁,要變化尺寸.旁,要變化尺寸.中,要變化尺寸.旁,要變化尺寸.旁旁,要變化尺寸.旁旁旁,要變化尺寸.左右,要變化尺寸.左右]
    
    // MARK: 取得要變化位置
    func  getTargetLocation(_ targetLocation:要移動的位置)->CGPoint{
        
        var 移動目標x:CGFloat!
        var 移動目標y:CGFloat!
        switch targetLocation {
            //%%增加下下下 上上上
        case .下下下:
            移動目標x = 螢幕寬/2
            移動目標y = 上條高 + 安全寬 + 照片基礎高*旁旁照片比/2 + 安全寬
        case .下下:
            移動目標x = 螢幕寬/2
            移動目標y = 上條高 + 安全寬 + 照片基礎高*旁旁照片比/2
        case .下:
            移動目標x = 螢幕寬/2
            移動目標y = 上條高+安全寬+照片區高/2 - (照片基礎高*中照片比*0.4)
        case .中:
            移動目標x = 螢幕寬/2
            移動目標y = 上條高+安全寬+照片區高/2
        case .上:
            移動目標x = 螢幕寬/2
            移動目標y = 上條高 + 安全寬 + 照片區高/2 + (照片基礎高*中照片比*0.4)
        case .上上:
            移動目標x = 螢幕寬/2
            移動目標y = 上條高 + 安全寬 + 照片區高 - 照片基礎高*旁旁照片比/2
        case .上上上:
            移動目標x = 螢幕寬/2
            移動目標y = 上條高 + 安全寬 + 照片區高 - 照片基礎高*旁旁照片比/2 - 安全寬
        case .左:
            移動目標x = 螢幕寬/2 - 螢幕寬
            移動目標y = 上條高 + 安全寬 + 照片區高/2
        case .右:
            移動目標x = 螢幕寬/2 + 螢幕寬
            移動目標y = 上條高 + 安全寬 + 照片區高/2
        }
        return CGPoint(x: 移動目標x, y: 移動目標y)
    }
    
    // MARK: 取得要變化尺寸
    func getTargetSize(_ targetSize:要變化尺寸)->CGSize{
        var 縮放目標w:CGFloat!
        var 縮放目標h:CGFloat!
        switch targetSize {
            //%%增加旁旁旁
        case .中:
            縮放目標w = 照片基礎高*中照片比
            縮放目標h = 照片基礎高*中照片比
        case .旁:
            縮放目標w = 照片基礎高*旁照片比
            縮放目標h = 照片基礎高*旁照片比
        case .旁旁:
            縮放目標w = 照片基礎高*旁旁照片比
            縮放目標h = 照片基礎高*旁旁照片比
        case .左右:
            縮放目標w = 照片基礎高*旁照片比
            縮放目標h = 照片基礎高*旁照片比
        case .旁旁旁:
            縮放目標w = 照片基礎高*旁旁照片比
            縮放目標h = 照片基礎高*旁旁照片比
        }
        return CGSize(width: 縮放目標w, height: 縮放目標h)
    }
    
    //建立每一個UIImageView是否在跑動畫，如果是true就不給跑，埋設在func setPhotoLocation的timer前後
    //%%增加img7IsAnimating img6IsAnimating
    
    func checkIsNotAnimating()->Bool{
        let answer:Bool = !img7IsAnimating && !img6IsAnimating && !img5IsAnimating && !img4IsAnimating && !img3IsAnimating && !img2IsAnimating && !img1IsAnimating
        return answer
    }
    
    var img7IsAnimating:Bool = false
    var img6IsAnimating:Bool = false
    var img5IsAnimating:Bool = false
    var img4IsAnimating:Bool = false
    var img3IsAnimating:Bool = false
    var img2IsAnimating:Bool = false
    var img1IsAnimating:Bool = false
    
    
    func setPhotoLocation(_ img:UIImageView,_ targetLocation:要移動的位置,_ targetSize:要變化尺寸 , _ completion: (() -> Void)? = nil){
        print("<<<<<<<開始setPhotoLocation2>>>>>>>>>")
        
        //print("移動照片開始")
        let 初始位置x = img.center.x
        let 初始位置y = img.center.y
        let 初始尺寸w = img.frame.size.width
        let 初始尺寸h = img.frame.size.height
        
        let 移動目標 = getTargetLocation(targetLocation)
        let 移動目標x = 移動目標.x
        let 移動目標y = 移動目標.y
        
        let 縮放目標 = getTargetSize(targetSize)
        let 縮放目標w = 縮放目標.width
        let 縮放目標h = 縮放目標.height
        
        //方便調整縮放的速度，可以調整這邊
        let 縮小倍率:CGFloat = 20
        
        let 移動速度x:CGFloat! = abs(移動目標x - 初始位置x)/縮小倍率
        let 移動速度y:CGFloat! = abs(移動目標y - 初始位置y)/縮小倍率
        let 縮放速度w:CGFloat = abs(縮放目標w - 初始尺寸w)/縮小倍率
        let 縮放速度h:CGFloat = abs(縮放目標h - 初始尺寸h)/縮小倍率
        
        //功能區
        func 縮小w(){
            if img.frame.width >= 縮放速度w {
                img.frame.size = CGSize(width: img.frame.width - 縮放速度w, height: img.frame.height)
                img.center = CGPoint(x: img.center.x + 縮放速度w/2, y: img.center.y)
            } else {
                img.frame.size = CGSize(width: img.frame.width - img.frame.width, height: img.frame.height)
                img.center = CGPoint(x: img.center.x + img.frame.width/2, y: img.center.y)
            }
        }
        
        func 縮小h(){
            if img.frame.height >= 縮放速度h {
                img.frame.size = CGSize(width: img.frame.width, height: img.frame.height - 縮放速度h)
                img.center = CGPoint(x: img.center.x, y: img.center.y + 縮放速度h/2)
            } else {
                img.frame.size = CGSize(width: img.frame.width, height: img.frame.height - img.frame.height)
                img.center = CGPoint(x: img.center.x, y: img.center.y + img.frame.height/2)
            }
        }
        
        func 放大w(){
            img.frame.size = CGSize(width: img.frame.width + 縮放速度w, height: img.frame.height)
            img.center = CGPoint(x: img.center.x - 縮放速度w/2, y: img.center.y)
        }
        
        func 放大h(){
            img.frame.size = CGSize(width: img.frame.width, height: img.frame.height + 縮放速度h)
            img.center = CGPoint(x: img.center.x, y: img.center.y - 縮放速度h/2)
        }
        
        func 縮放成指定尺寸w(){
            let 目標差w:CGFloat = 縮放目標w-img.frame.width
            img.frame.size = CGSize(width: img.frame.width + 目標差w, height: img.frame.height)
            img.center = CGPoint(x: img.center.x - 目標差w/2, y: img.center.y)
        }
        
        func 縮放成指定尺寸h(){
            let 目標差h:CGFloat = 縮放目標h-img.frame.height
            img.frame.size = CGSize(width: img.frame.width, height: img.frame.height + 目標差h)
            img.center = CGPoint(x: img.center.x, y: img.center.y - 目標差h/2)
        }
        
        func 左移(){
            img.center.x -= 移動速度x
        }
        
        func 右移(){
            img.center.x += 移動速度x
        }
        
        func 上移(){
            img.center.y -= 移動速度y
        }
        
        func 下移(){
            img.center.y += 移動速度y
        }
        
        func 調整至指定位置x(){
            let 目標差x:CGFloat = 移動目標x-img.center.x
            img.center.x += 目標差x
        }
        
        func 調整至指定位置y(){
            let 目標差y:CGFloat = 移動目標y-img.center.y
            img.center.y += 目標差y
        }
        
        
        //把外部的imgIsAnimating抓來內部使用
        //%%增加img7IsAnimating img6IsAnimating
        var 函式內的imgIsAnimatig:Bool?
        if img == img7 {
            函式內的imgIsAnimatig = self.img7IsAnimating
        } else if img == img6 {
            函式內的imgIsAnimatig = self.img6IsAnimating
        } else if img == img5 {
            函式內的imgIsAnimatig = self.img5IsAnimating
        } else if img == img4 {
            函式內的imgIsAnimatig = self.img4IsAnimating
        } else if img == img3 {
            函式內的imgIsAnimatig = self.img3IsAnimating
        } else if img == img2 {
            函式內的imgIsAnimatig = self.img2IsAnimating
        }  else if img == img1 {
            函式內的imgIsAnimatig = self.img1IsAnimating
        } else {
            函式內的imgIsAnimatig = false
            print("你選用的Img:UIImageView沒有預設的imgIsAnimating")
        }
        //判別imgIsAnimating為false，執行程式
        if 函式內的imgIsAnimatig == false {
            //更改imgIsAnimating = true
            //%%增加img7IsAnimating img6IsAnimating
            if img == img7 {
                self.img7IsAnimating = true
            } else if img == img6 {
                self.img6IsAnimating = true
            } else if img == img5 {
                self.img5IsAnimating = true
            } else if img == img4 {
                self.img4IsAnimating = true
            } else if img == img3 {
                self.img3IsAnimating = true
            } else if img == img2 {
                self.img2IsAnimating = true
            }  else if img == img1 {
                self.img1IsAnimating = true
            }
            
            // MARK: Timer
            //            print("進入Timer前一行")
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats:true) { [self]
                timer
                in
                
                var 尺寸w很接近:Bool!
                var 要繼續縮小w:Bool!
                var 尺寸h很接近:Bool!
                var 要繼續縮小h:Bool!
                
                var 位置x很接近:Bool!
                var 要繼續x左移:Bool!
                var 位置y很接近:Bool!
                var 要繼續y上移:Bool!
                
                
                尺寸w很接近 = (縮放目標w-縮放速度w) <= img.frame.width && img.frame.width <=  (縮放目標w+縮放速度w)
                要繼續縮小w = 縮放目標w < img.frame.width
                
                尺寸h很接近 = (縮放目標h-縮放速度h) <= img.frame.height && img.frame.height <=  (縮放目標h+縮放速度h)
                要繼續縮小h = 縮放目標w < img.frame.height
                
                位置y很接近 = (移動目標y-移動速度y) <= img.center.y  && img.center.y <= (移動目標y+移動速度y)
                要繼續y上移 = 移動目標y < img.center.y
                
                位置x很接近 = (移動目標x-移動速度x) <= img.center.x  && img.center.x <= (移動目標x+移動速度x)
                要繼續x左移 = 移動目標x < img.center.x
                
                func 縮放(){
                    if 尺寸w很接近  {
                        縮放成指定尺寸w()
                    } else {
                        if 要繼續縮小w {
                            縮小w()
                        } else {
                            放大w()
                        }
                    }
                    
                    if 尺寸h很接近  {
                        縮放成指定尺寸h()
                    } else {
                        if 要繼續縮小h {
                            縮小h()
                        } else {
                            放大h()
                        }
                    }
                }
                
                func 移動(){
                    if 位置x很接近 {
                        調整至指定位置x()
                    } else {
                        if 要繼續x左移 {
                            左移()
                        } else {
                            右移()
                        }
                    }
                    
                    if 位置y很接近 {
                        調整至指定位置y()
                    } else {
                        if 要繼續y上移 {
                            上移()
                        } else {
                            下移()
                        }
                    }
                }
                
                縮放()
                移動()
                viewController.view.setNeedsDisplay()
                
                
                if 尺寸w很接近 && 尺寸h很接近 && 位置x很接近 && 位置y很接近 {
                    //完成修改，把來源的判斷改成false
                    //%%增加img7IsAnimating img6IsAnimating
                    if img == img7 {
                        self.img7IsAnimating = false
                    } else if img == img6 {
                        self.img6IsAnimating = false
                    } else if img == img5 {
                        self.img5IsAnimating = false
                    } else if img == img4 {
                        self.img4IsAnimating = false
                    } else if img == img3 {
                        self.img3IsAnimating = false
                    } else if img == img2 {
                        self.img2IsAnimating = false
                    }  else if img == img1 {
                        self.img1IsAnimating = false
                    }
                    timer.invalidate()
                    
                    //完成了就通知一聲
                    //%%增加img7IsAnimating img6IsAnimating
                    if img == img7 {
                        print("img7的Timer完成任務")
                    } else if img == img6 {
                        print("img6的Timer完成任務")
                    } else if img == img5 {
                        print("img5的Timer完成任務")
                    } else if img == img4 {
                        print("img4的Timer完成任務")
                    } else if img == img3 {
                        print("img3的Timer完成任務")
                    } else if img == img2 {
                        print("img2的Timer完成任務")
                    }  else if img == img1 {
                        print("img1的Timer完成任務")
                    }
                    
                    //這是一個IsAnimating檢查器
                    //                    print("第1階段動畫完成")
                    //                    print("img5IsAnimating?:\(self.img5IsAnimating)")
                    //                    print("img4IsAnimating?:\(self.img4IsAnimating)")
                    //                    print("img3IsAnimating?:\(self.img3IsAnimating)")
                    //                    print("img2IsAnimating?:\(self.img2IsAnimating)")
                    //                    print("img1IsAnimating?:\(self.img1IsAnimating)")
                    
                    completion?()
                }
            }
            //進入 Timer後的程式碼會先被程式執行，很怪
            //            print("進入Timer")
        }
    }
    
    
    func setLocationByArray(_ targetArray:Array<Array<Any>>,_ direction:手勢動作 ,_ completion: (() -> Void)? = nil){
        
        //執行五次
        for i in 0...6 {
            
            //設定位置
            //取得要更動的img
            var img:UIImageView!
            //從array中取得img的名稱
            let imgRow = targetArray[0][i]
            //按照名稱配對img
            //%%增加img7IsAnimating img6IsAnimating
            if imgRow as! String == "img7" {
                img = img7
            } else if imgRow as! String == "img6" {
                img = img6
            } else if imgRow as! String == "img5"{
                img = img5
            } else if imgRow as! String == "img4" {
                img = img4
            } else if imgRow as! String == "img3" {
                img = img3
            } else if imgRow as! String == "img2" {
                img = img2
            } else if imgRow as! String == "img1" {
                img = img1
            }
            
            //設定層次
            //中間張調到最外層，下滑時下下到最底層，上滑時上上到最底層
            if direction == 手勢動作.向下 {
                if arrLocationMap[i] == 要移動的位置.下下下 {
                    viewController.view.sendSubviewToBack(img)
                } else if arrLocationMap[i] == 要移動的位置.中 {
                    viewController.view.bringSubviewToFront(img)
                }
            } else if direction == 手勢動作.向上 {
                if arrLocationMap[i] == 要移動的位置.中 {
                    viewController.view.bringSubviewToFront(img)
                } else if arrLocationMap[i] == 要移動的位置.上上上 {
                    viewController.view.sendSubviewToBack(img)
                }
            } else if direction == 手勢動作.向右 || direction == 手勢動作.向左 || direction == 手勢動作.拖曳 {
                if arrLocationMap[i] == 要移動的位置.中 {
                    viewController.view.bringSubviewToFront(img)
                } else if arrLocationMap[i] == 要移動的位置.上上上 {
                    viewController.view.sendSubviewToBack(img)
                }  else if arrLocationMap[i] == 要移動的位置.下下下 {
                    viewController.view.sendSubviewToBack(img)
                }
            }
            
            
            //調整到相對的位置(穩定版)
            //            setPhotoLocation(img!, arrLocationMap[i], arrSizeMap[i])
            
            //調整到相對的位置（調整中）
            //手勢向右 or 向右
            if direction == 手勢動作.向右 {
                //不是最後一張的狀況
                if !(viewController.imgsArrayTool.photoTag == arrSelectedPHAsset.count-1) {
                    // 抓到下下下張來移動（原始的中間張）
                    if i == 0 {
                        //先移到外面
                        setPhotoLocation(img!, arrLocationMap[8], arrSizeMap[8]) {
                            //跑第二階段動畫:移回下下下張
                            img!.isHidden = true
                            self.setPhotoLocation(img!, self.arrLocationMap[0], self.arrSizeMap[0]){
                            }
                        }
                    } else {
                        //其他張按照正常跑位
                        setPhotoLocation(img!, arrLocationMap[i], arrSizeMap[i])
                    }
                } else {
                    //是最後一張的狀況
                    // 抓到上上上張來移動（原始的中間張）
                    if i == 6 {
                        //先移到外面
                        setPhotoLocation(img!, arrLocationMap[8], arrSizeMap[8]) {
                            //跑第二階段動畫:移回上上上張
                            img!.isHidden = true
                            self.setPhotoLocation(img!, self.arrLocationMap[6], self.arrSizeMap[6]){
                            }
                        }
                    } else {
                        //其他張按照正常跑位
                        setPhotoLocation(img!, arrLocationMap[i], arrSizeMap[i])
                    }
                }
                
            } else if direction == 手勢動作.向左 {
                //不是最後一張的狀況
                if !(viewController.imgsArrayTool.photoTag == arrSelectedPHAsset.count-1) {
                    // 抓到下下張來移動（原始的中間張）
                    if i == 0 {
                        //先移到外面
                        setPhotoLocation(img!, arrLocationMap[7], arrSizeMap[7]) {
                            //再移回下下張
                            img!.isHidden = true
                            self.setPhotoLocation(img!, self.arrLocationMap[0], self.arrSizeMap[0]){
                            }
                        }
                    } else {
                        setPhotoLocation(img!, arrLocationMap[i], arrSizeMap[i])
                    }
                } else {
                    //是最後一張的狀況
                    // 抓到上上張來移動（原始的中間張）
                    if i == 6 {
                        //先移到外面
                        setPhotoLocation(img!, arrLocationMap[7], arrSizeMap[7]) {
                            //再移回上上張
                            img!.isHidden = true
                            self.setPhotoLocation(img!, self.arrLocationMap[6], self.arrSizeMap[6]){
                            }
                        }
                    } else {
                        setPhotoLocation(img!, arrLocationMap[i], arrSizeMap[i])
                    }
                }
            } else {
                setPhotoLocation(img!, arrLocationMap[i], arrSizeMap[i])
            }
            
            
            //設定照片
            //從array中取出path
            let path = targetArray[1][i]

            if let unwrappedPath = path as? UIImage {
                // 如果有照片就開啟img同時調整成正確的照片
                img.isHidden = false
                img.image = unwrappedPath
            } else {
                // 如果沒照片就隱藏img同時丟一個dummy照片給它。
                img.isHidden = true
                img.image = UIImage(systemName: "xmark.seal.fill")
            }
            
            
        }
        
        if let completion = completion {
                completion()
            }
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
    
    
    //一秒讓所有UIImageView跑回中間集合
    func setLocationToCenter(_ completion: (() -> Void)? = nil){
        //取得初始陣列陣列
        img7.frame.size = getTargetSize(要變化尺寸.旁旁)
        img6.frame.size = getTargetSize(要變化尺寸.旁旁)
        img5.frame.size = getTargetSize(要變化尺寸.旁旁)
        img4.frame.size = getTargetSize(要變化尺寸.旁旁)
        img3.frame.size = getTargetSize(要變化尺寸.旁旁)
        img2.frame.size = getTargetSize(要變化尺寸.旁旁)
        img1.frame.size = getTargetSize(要變化尺寸.旁旁)
        img7.center = getTargetLocation(要移動的位置.中)
        img6.center = getTargetLocation(要移動的位置.中)
        img5.center = getTargetLocation(要移動的位置.中)
        img4.center = getTargetLocation(要移動的位置.中)
        img3.center = getTargetLocation(要移動的位置.中)
        img2.center = getTargetLocation(要移動的位置.中)
        img1.center = getTargetLocation(要移動的位置.中)
        viewController.view.bringSubviewToFront(img1)
        viewController.view.bringSubviewToFront(img7)
        viewController.view.bringSubviewToFront(img2)
        viewController.view.bringSubviewToFront(img6)
        viewController.view.bringSubviewToFront(img3)
        viewController.view.bringSubviewToFront(img5)
        viewController.view.bringSubviewToFront(img4)
        if let completion = completion {
                completion()
            }
    }
    
    //動畫方式讓所有UIImageView分佈到初始位置
    func setLocationRestart(_ completion: (() -> Void)? = nil){
        //取得重置的陣列
        let startArray = viewController.imgsArrayTool.getReStartImgsArray()
        setLocationByArray(startArray,手勢動作.沒動作)
        if let completion = completion {
                completion()
            }
    }
    
    // MARK: 建立上滑的動畫功能
    func setLocationUp(_ completion: (() -> Void)? = nil){
        //取得重置的陣列
        let swipeUpArray = viewController.imgsArrayTool.getSwipeUpImgArray()
        setLocationByArray(swipeUpArray,手勢動作.向上)
        if let completion = completion {
                completion()
            }
    }
    // MARK: 建立下滑的動畫功能
    func setLocationDown(_ completion: (() -> Void)? = nil){
        //取得重置的陣列
        let swipeDownArray = viewController.imgsArrayTool.getSwipeDownImgArray()
        setLocationByArray(swipeDownArray,手勢動作.向下)
        if let completion = completion {
                completion()
            }
    }
    // MARK: 建立左滑的動畫功能
    func setLocationLeft(_ completion: (() -> Void)? = nil){
        //取得重置的陣列
        let swipeLeftArray = viewController.imgsArrayTool.getSwipeLeftArray()
        setLocationByArray(swipeLeftArray,手勢動作.向左)
        if let completion = completion {
                completion()
            }
    }
    // MARK: 建立右滑的動畫功能
    func setLocationRight(_ completion: (() -> Void)? = nil){
        //取得重置的陣列
        let swipeRightArray = viewController.imgsArrayTool.getSwipeRightArray()
        setLocationByArray(swipeRightArray,手勢動作.向右)
        if let completion = completion {
                completion()
            }
    }
    
    
    // MARK: 建立縮小功能
    func 縮小到不見(_ img:UIImageView,togo:Folders,_ completion: (() -> Void)? = nil){
        UIView.animate(withDuration: 0.2) {
            img.alpha = 0.0
            img.transform = CGAffineTransform(scaleX: 0.03, y: 0.03)
        } completion: { _ in
            //縮小隱藏後要回到原位置
            //要直接跳回去，減少Animating執行時間
//            img.frame.size = self.getTargetSize(要變化尺寸.中)
                img.alpha = 1.0
                img.transform = CGAffineTransform.identity
                img.isHidden = true
                img.center = self.getTargetLocation(要移動的位置.中)
            let panArray = self.viewController.imgsArrayTool.getPanArray(togo: togo)
                self.setLocationByArray(panArray,手勢動作.拖曳)
            
            print("arrImagesToFolder2:\(arrImagesToFolder2)")
        }
        if let completion = completion {
                completion()
            }
    }
    
    func checkFolderIsSetted(togo:Folders)->Bool{
        switch togo {
        case .folder1 :
            if folderName1 == nil || folderURL1 == nil {
                return false
            } else {
                return true
            }
        case .folder2 :
            if folderName2 == nil || folderURL2 == nil {
                return false
            } else {
                return true
            }
        default:
            return true
        }
    }
    
}


