//
//  SettingsVC.swift
//  sgc
//
//  Created by roey ben arieh on 08/08/2022.
//

import UIKit
import RealmSwift

let realm = try! Realm()
class SettingsVC: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var settings: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // inserting the settings types to the realm database if they dont exist
        insertSettings()
        
        // handling the settings as GUI
        settings.dataSource = self
        
        // making sure keybaord can be escaped
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: present DB data as GUI
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(setting.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // changing the cell according to the DB information
        let DBSetting = realm.objects(setting.self)[indexPath.row]
        
        // design special table cell for each king of setting
        switch DBSetting.value {
        case let value where value.boolValue != nil:
            let settingCell = settings.dequeueReusableCell(withIdentifier: "boolSettingCell", for: indexPath) as! BoolSettingTableViewCell
            settingCell.setting = DBSetting
            settingCell.name.text = DBSetting.name
            settingCell.value.isOn = value.boolValue!
            return settingCell
        case let value where value.intValue != nil:
            let settingCell = settings.dequeueReusableCell(withIdentifier: "IntegerSettingCell", for: indexPath) as! IntegerSettingTableViewCell
            settingCell.setting = DBSetting
            settingCell.name.text = DBSetting.name
            settingCell.value.text = String(value.intValue!)
            return settingCell
        default:
            break
        }
        return UITableViewCell()
    }
    
    
    // MARK: initializing the DB
    func getSetting(name: String) -> Object?{
        return realm.objects(setting.self).filter("name = '\(name)'").first
    }
    
    func insertSettings(){
        let settings = [
                        ["automatic injection", true],
                        ["injection timeout", 50],
                        ["injection ratio", 10]
                       ]
        settings.forEach{
            if getSetting(name: ($0)[0] as! String) == nil {
                let new_setting = setting()
                new_setting.name = ($0)[0] as! String
                new_setting.value = AnyRealmValue._rlmFromObjc(($0)[1])! // ($0)[1] as! AnyRealmValue
                try! realm.write {
                    realm.add(new_setting)
                }
            }
        }
    }
}
class setting: Object {
    @Persisted var name : String
    @Persisted var value: AnyRealmValue
}
class SettingTableViewCell: UITableViewCell {
    var setting : setting?
}
class BoolSettingTableViewCell: SettingTableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UISwitch!
    
    
    // there is a error from this function but the execution is OK, the problem is with UIKit
    @IBAction func switchDidChange(_ sender: UISwitch) {
        print("changed bool value to: " + String(sender.isOn))
        try! realm.write {
            self.setting?.value = AnyRealmValue.bool(sender.isOn)
        }
    }
    
}
class IntegerSettingTableViewCell: SettingTableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UITextField!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //value.inputa
    }
    @IBAction func pressedEnterInTextField(_ sender: UITextField) {
        print("changed text value to: " + sender.text!)
        try! realm.write {
            self.setting?.value = AnyRealmValue.int(Int(sender.text!)!)
        }
    }
}
