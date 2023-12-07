//
//  AlertTool.swift
//  photoTest
//
//  Created by Jonah Chou on 2023/11/3.
//

import Foundation
import UIKit

// MARK: - Alert 功能
//建立功能：UIAlertController建立工具
class AlertTool {
    var viewController:UIViewController!
    init(viewController:Any) {
        self.viewController = viewController as? UIViewController
    }
    
    func alertCreater(
        title:String,
        message:String,
        button_qty:(Int)? = 1,
        button_title_1:(String)? = "OK",
        function_1: (() -> Void)? = nil,
        button_title_2:(String)? = "Cancel",
        function_2: (() -> Void)? = nil,
        button_title_3:(String)? = "Cancel",
        function_3: (() -> Void)? = nil,
        function_in_handler_1:(() -> Void)? = nil,
        _ completion: (() -> Void)? = nil ){
            
            //建立Alert
            let alert1 = UIAlertController(title: title, message: message, preferredStyle: .alert)
            //依照parameter提供的button_qty決定加入幾個UIAlertAction到視窗上
            if button_qty! >= 1 {
                alert1.addAction(
                    UIAlertAction(
                        title: button_title_1,
                        style: .default,
                        handler: {
                            _ in
                            //執行parameter提供的函式
                            if function_1 != nil {
                                function_1!()
                            }
                        }
                    )
                )
            }
            
            //依照parameter提供的button_qty決定加入幾個UIAlertAction到視窗上
            if button_qty! >= 2 {
                alert1.addAction(UIAlertAction(title: button_title_2, style: .default, handler: { _ in
                    //執行parameter提供的函式
                    if function_2 != nil {
                        function_2!()
                    }
                }))
            }
            
            //依照parameter提供的button_qty決定加入幾個UIAlertAction到視窗上
            if button_qty! >= 3 {
                alert1.addAction(UIAlertAction(title: button_title_3, style: .default, handler: { _ in
                    //執行parameter提供的函式
                    if function_3 != nil {
                        function_3!()
                    }
                }))
            }
            
            //把alert表現出來
            viewController.present(alert1, animated: true)
            
            if let completion = completion {
                    completion()
                }
        }
}
