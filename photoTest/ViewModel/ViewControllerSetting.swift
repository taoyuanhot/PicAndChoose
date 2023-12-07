//
//  ViewControllerSetting.swift
//  photoTest
//
//  Created by 咪咪貓 on 2023/11/5.
//

import UIKit

class ViewControllerSetting: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var viewControllerIimgaesAnimation:ViewControllerIimgaesAnimation!
    
    @IBOutlet weak var tableView: UITableView!
    
    var alertTool:AlertTool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        alertTool = AlertTool(viewController: self)
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func clickButtunReturn(_ sender: UIButton) {
        print("你按下Return")
        
        let arrSaveIn = [viewControllerIimgaesAnimation.saveIn1,
                         viewControllerIimgaesAnimation.saveIn2,
                         viewControllerIimgaesAnimation.saveIn3]
        if !arrFolderNameSelected.isEmpty {
            for i in 0...arrFolderNameSelected.count-1 {
                if !arrFolderNameSelected[i].isEmpty {
                    arrSaveIn[i]!.setTitle(arrFolderNameSelected[i], for: .normal)
                } else {
                    arrSaveIn[i]!.setTitle("未設定", for: .normal)
                }
            }
        } else {
            for i in 0...2 {
                arrSaveIn[i]!.setTitle("未設定", for: .normal)
            }
        }

        self.dismiss(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return arrFolderName.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithSwitch", for: indexPath)
            
            if let label = cell.viewWithTag(1) as? UILabel {
                if indexPath.row == 0 {
                    label.text = "操作設定"
                } else {
                    label.text = "背景設定"
                }
            }
            
            if let label = cell.viewWithTag(2) as? UILabel {
                if indexPath.row == 0 {
                    label.text = "左滑或右滑刪除"
                } else {
                    label.text = "深色或淺色背景"
                }
            }
            
            if let switchControl = cell.viewWithTag(3) as? UISwitch {
                if indexPath.row == 0 {
                    if leftOrRight == true {
                        switchControl.isOn = true
                    } else {
                        switchControl.isOn = false
                    }
                    
                    switchControl.addTarget(self, action: #selector(directionSwitchChanged), for: .valueChanged)
                } else {
                    
                    if darkOrLight {
                        switchControl.isOn = true
                        
                    } else {
                        switchControl.isOn = false
                    }
                    
                    switchControl.addTarget(self, action: #selector(colorSwitchChanged), for: .valueChanged)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellFolderSetting", for: indexPath)
            if let button = cell.viewWithTag(4) as? UIButton {
                //如果按了刪除，就從arrFolderName刪除
                //確認arrFolderNameSelected有沒有同一個名字，如果有也要進行刪除
                button.tag = indexPath.row
                button.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
                
            }
            if let label = cell.viewWithTag(5) as? UILabel {
                label.text = arrFolderName[indexPath.row]
            }
            if let label = cell.viewWithTag(6) as? UILabel {
                label.text = "啟用/關閉編輯"
            }
            if let switchControl = cell.viewWithTag(7) as? UISwitch {
                //switchon的話就把該筆加入arrFolderNameSelected
                //switchof的話就把該筆從arrFolderNameSelected
                switchControl.tag = indexPath.row
                switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
                // Check if the label text is in arrFolderNameSelected
                let labelText = arrFolderName[indexPath.row]
                switchControl.isOn = arrFolderNameSelected.contains(labelText)
                
            }
            return cell
        }
    }
    
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        // Access the indexPath.row using the button's tag
        let rowToDelete = sender.tag

        // Remove the corresponding element from arrFolderName
        if rowToDelete < arrFolderName.count {
            let folderToDelete = arrFolderName[rowToDelete]
            arrFolderName.remove(at: rowToDelete)
            print("arrFolderName:\(arrFolderName)")
            // Remove the folder from arrFolderNameSelected if it exists
            if let indexInSelected = arrFolderNameSelected.firstIndex(of: folderToDelete) {
                arrFolderNameSelected.remove(at: indexInSelected)
                print("arrFolderNameSelected:\(arrFolderNameSelected)")
            }

            // Reload the table view to reflect the changes
            tableView.reloadData()
        }
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        // Handle switch value change
        let indexPath = IndexPath(row: sender.tag, section: 0)
        print(sender.tag)
        print("sender.isOn:\(sender.isOn)")
        if sender.isOn {
            if arrFolderNameSelected.count < 3 {
                // Add the folder to arrFolderNameSelected
                arrFolderNameSelected.append(arrFolderName[indexPath.row])
                print("arrFolderNameSelected:\(arrFolderNameSelected)")
            } else {
                sender.isOn = false
                alertTool.alertCreater(title: "您只能設定三個相簿", message: "您可以取消已選相簿並且再選擇此相簿。", button_qty: 1, button_title_1: "OK", function_1: nil)
            }
        } else {
            // Remove the folder from arrFolderNameSelected if it exists
            if let indexInSelected = arrFolderNameSelected.firstIndex(of: arrFolderName[indexPath.row]) {
                arrFolderNameSelected.remove(at: indexInSelected)
                print("arrFolderNameSelected:\(arrFolderNameSelected)")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray3
        
        // 創建一個標籤，設置標題和文字顏色
        let label = UILabel()
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.textColor = UIColor.black // 你想要的title顏色
        label.frame = CGRect(x: 15, y: 5, width: tableView.frame.size.width - 16, height: 30) // 調整標籤位置和大小
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "個人設置"
        } else {
            return "相簿列表"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else {
            return 80
        }
    }
    
    
    
    
    @objc func directionSwitchChanged(_ sender: UISwitch) {
        print("你觸碰開關：調整左右滑")
        if sender.isOn {
            leftOrRight = true
            alertTool.alertCreater(title: "修改成功", message: "現在右滑動是將照片丟到垃圾桶，左滑是丟到指定的資料夾。", button_qty: 1, button_title_1: "OK", function_1: nil)
        } else {
            leftOrRight = false
            alertTool.alertCreater(title: "修改成功", message: "現在左滑動是將照片丟到垃圾桶，右滑是丟到指定的資料夾。", button_qty: 1, button_title_1: "OK", function_1: nil)
        }
    }
    
    @objc func colorSwitchChanged(_ sender: UISwitch) {
        print("你觸碰開關：深淺色模式")
        if #available(iOS 13.0, *) {
            let appDelegate = UIApplication.shared.windows.first
            if sender.isOn {
                darkOrLight = true
                print("調整成淺色模式")
                appDelegate?.overrideUserInterfaceStyle = .light
            } else {
                darkOrLight = false
                print("調整成深色模式")
                appDelegate?.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    @IBAction func clickButtonAddAlbum(_ sender: UIButton) {
        print("按下clickButtonAddAlbum")
        self.performSegue(withIdentifier: "segueToViewControllerSettingFolder", sender: nil)
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if segue.identifier == "segueToViewControllerSettingFolder" {
            let viewControllerSetFolder = segue.destination as! ViewControllerSetFolder
            viewControllerSetFolder.viewControllerSetting = self
        }
    }
    
    
    
}
