//
//  ViewControllerGuilding.swift
//  photoTest
//
//  Created by 藍景鴻 on 2023/11/29.
//

import UIKit

class ViewControllerGuilding: UIViewController, UIGestureRecognizerDelegate {
    
    var arrImgGuilding = [
        UIImage(named: "P1"),
        UIImage(named: "P2"),
        UIImage(named: "P3"),
        UIImage(named: "P4"),
    ]
    
    var arrButtonCGRect = [
        CGRect(x: 185-50, y: 611-14, width: 120, height: 70),
        CGRect(x: 185-50, y: 512-10, width: 120, height: 70),
        CGRect(x: 185-50, y: 448-6, width: 120, height: 70),
        CGRect(x: 185-50, y: 390-2, width: 120, height: 70),
    ]
    
    var currentImgTag:Int = 0

    @IBOutlet weak var imgGuilding: UIImageView!
    @IBOutlet weak var buttonNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgGuilding.image = arrImgGuilding[currentImgTag]
        buttonNext.frame = arrButtonCGRect[currentImgTag]
        
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
        

    }
    
    //手動建立手勢（2）:判斷器
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //手動建立手勢（3）: objc swipeLeft功能(左滑)
    @objc func handleSwipeLeftGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if currentImgTag < 3 {
            currentImgTag += 1
            print("currentImgTag:\(currentImgTag)")
            imgGuilding.image = arrImgGuilding[currentImgTag]
            buttonNext.frame = arrButtonCGRect[currentImgTag]
            print("完成swipeLeft")
        } else if currentImgTag == 3 {
            isBeenGuided = true
            print("isBeenGuided:\(isBeenGuided)")
            print("完成教學囉")
            currentImgTag = 0
            self.performSegue(withIdentifier: "segueToViewControllerIimgaesAnimation", sender: nil)
        }
    }
    
    // MARK: 建立右滑動功能
    //手動建立手勢（3）: objc swipeRight功能(右滑)
    @objc func handleSwipeRightGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if currentImgTag > 0 {
            currentImgTag -= 1
            print("currentImgTag:\(currentImgTag)")
            imgGuilding.image = arrImgGuilding[currentImgTag]
            buttonNext.frame = arrButtonCGRect[currentImgTag]
            print("完成swipeLeft")
        } else {
            print("這是第一頁不能再左滑")
        }
    }
    

    @IBAction func clickButtonNext(_ sender: UIButton) {
        if currentImgTag < 3 {
            currentImgTag += 1
            print("currentImgTag:\(currentImgTag)")
            imgGuilding.image = arrImgGuilding[currentImgTag]
            buttonNext.frame = arrButtonCGRect[currentImgTag]
            print("完成swipeLeft")
        } else if currentImgTag == 3 {
            isBeenGuided = true
            print("isBeenGuided:\(isBeenGuided)")
            print("完成教學囉")
            currentImgTag = 0
            self.performSegue(withIdentifier: "segueToViewControllerIimgaesAnimation", sender: nil)
        }
    }
    
}
