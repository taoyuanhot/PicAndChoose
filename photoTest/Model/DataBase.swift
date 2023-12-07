//
//  DataBase.swift
//  photoTest
//
//  Created by 藍景鴻 on 2023/11/22.
//

import Foundation
import Photos
import UIKit

//是否播放Guilding
var isBeenGuided:Bool = false

//從相簿中選取的照片Array，分兩種形式呈現
var arrSelectedPHAsset:[UIImage] = []  //調整成UIImage
var arrSelectedUIImage:[UIImage] = []

//自己建立的資料夾地址
var folderURL1:URL?
var folderURL2:URL?

//自己建立的資料夾名稱
var folderName1: String?
var folderName2: String?


//調整成UIImage版本增加的
var arrFolderName:[String] = []
var arrFolderNameSelected:[String] = []

//這是主畫面顯示的陣列
var arrImageView:[String] = ["img7","img6","img5","img4","img3","img2","img1"]
var arrPhotoPath:[UIImage?]  = [nil,nil,nil,nil,nil,nil,nil] //調整成UIImage

//這是不同檔案的PHAsset陣列
var arrImagesToTrash:[UIImage] = [] //調整成UIImage
var arrImagesToFolder1:[UIImage] = [] //調整成UIImage
var arrImagesToFolder2:[UIImage] = [] //調整成UIImage
var arrImagesToTrashReadyToActing:[UIImage] = [] //調整成UIImage
var arrImagesToFolder1ReadyToActing:[UIImage] = [] //調整成UIImage
var arrImagesToFolder2ReadyToActing:[UIImage] = [] //調整成UIImage

//設定頁面的全域變數
var leftOrRight:Bool = true
var darkOrLight:Bool = true

//設定HomeDirectory的清單
var arrlistDirInHDirectoryURL:[URL] = []
var arrlistDirInHDirectoryName:[String] = []


//建立一個轉換頁面的工具
var settingSheet:SettingSheet = .addFolderSheet


var arrHistoryLogUndo:[HistoryLog] = []
var arrHistoryLogRedo:[HistoryLog] = []

struct HistoryLog {
    var historyTarget:Folders!
    var historyAction:Action!
    var historyUIImage:UIImage!
}

enum SettingSheet {
    case addFolderSheet
    case deleteFolderSheet
    case setFolder1Sheet
    case setFolder2Sheet
}

enum Action {
    case push
    case pull
}

enum Folders {
    case folder1
    case folder2
    case trasnCan
    case imagePicker
}


