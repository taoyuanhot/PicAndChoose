//
//  ViewControllerSetFolder.swift
//  photoTest
//
//  Created by 藍景鴻 on 2023/11/27.
//

import UIKit

class ViewControllerSetFolder: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var viewControllerSetting:ViewControllerSetting!
    
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var alertTool:AlertTool!
    var photoTool:PhotoTool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        alertTool = AlertTool(viewController: self)
        photoTool = PhotoTool(viewController: self)
        
        
        myTitle.text = "新增相簿"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "新增單個或多個"
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFolderCell", for: indexPath)
        if let label = cell.viewWithTag(55) as? UILabel {
            label.text = "相簿名稱："
        }
        
        if let textField = cell.viewWithTag(56) as? UITextField {
            textField.tag = indexPath.row
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        return cell
    }
    
    var newAlbumName1:String?
    var newAlbumName2:String?
    var newAlbumName3:String?
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Use textField.tag to determine the corresponding indexPath.row
        let selectedRow = textField.tag
        // Update the corresponding album name based on the selectedRow
        switch selectedRow {
        case 0:
            newAlbumName1 = textField.text
        case 1:
            newAlbumName2 = textField.text
        case 2:
            newAlbumName3 = textField.text
        default:
            break
        }

        // Print for verification
        print("Selected Row: \(selectedRow)")
        print("newAlbumName1: \(newAlbumName1 ?? "")")
        print("newAlbumName2: \(newAlbumName2 ?? "")")
        print("newAlbumName3: \(newAlbumName3 ?? "")")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    @IBAction func clickButtonReturn(_ sender: UIButton) {
        print("你按下Return")
        dismiss()
    }
    
    func dismiss(){
        self.dismiss(animated: true)
    }
    

    @IBAction func clicklAddAlbum(_ sender: UIButton) {
        if newAlbumName1 != nil {
            arrFolderName.append(newAlbumName1!)
            print("arrFolderName:\(arrFolderName)")
        }
        if newAlbumName2 != nil {
            arrFolderName.append(newAlbumName2!)
            print("arrFolderName:\(arrFolderName)")
        }
        if newAlbumName3 != nil {
            arrFolderName.append(newAlbumName3!)
            print("arrFolderName:\(arrFolderName)")
        }
        
        viewControllerSetting.tableView.reloadData()
        dismiss()
    }
    

    
}
