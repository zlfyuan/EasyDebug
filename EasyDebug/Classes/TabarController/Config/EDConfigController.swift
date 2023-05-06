//
//  EDConfigController.swift
//  EasyDebug
//
//  Created by zluof on 2023/3/31.
//  Copyright © 2023 zluof <https://github.com/zlfyuan/>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE
//


import UIKit

class ConfigRow{
    let key: String
    let value: Any
    init(key: String, value: Any) {
        self.key = key
        self.value = value
    }
}

class ConfigSection {
    let title: String
    let list: [ConfigRow]
    init(title: String, list: [ConfigRow]) {
        self.title = title
        self.list = list
    }
}
class EDConfigController: EDTableController{
    
    var dataSources = [ConfigSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .singleLine
        self.tableView.tableFooterView = createFooterView()
        self.parseData()
        
        // Register the custom cell
        tableView.register(EDConfigCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
    
    func createFooterView() -> UIView {
        let footView = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.size.width, height: 80))
        footView.text = "version: \(EasyDebugVersion)"
        footView.font = UIFont.systemFont(ofSize: 14)
        footView.textColor = .systemGray
        footView.textAlignment = .center
        return footView
    }
    
    func parseData() {
        dataSources.removeAll()
        let log = [ConfigRow(key: "level", value: EasyDebug.shared.options.filterLevel.description)]
        dataSources.append(ConfigSection(title:String.edLocalizedString(withKey: "title.log"), list: log))
        
        let netWork = [ConfigRow(key: String.edLocalizedString(withKey: "title.blacklist"), value: EDNetWorkManger.shared.blacklist.count)]
        dataSources.append(ConfigSection(title:String.edLocalizedString(withKey: "title.network"), list: netWork))
        
        let language = EDLanguage.allCases.map({ ConfigRow(key: $0.rawValue, value: false) })
        dataSources.append(ConfigSection(title:String.edLocalizedString(withKey: "title.language"), list: language))
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSources.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources[section].list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = self.dataSources[indexPath.section]
        let model = section.list[indexPath.row]
        let cell = EDConfigCell(style: .default, reuseIdentifier: "cell")
        
        if section.title == String.edLocalizedString(withKey: "title.language") {
            if "\(model.key)" == EasyDebug.shared.options.language.rawValue {
                cell.checkmarkModel = model
            }else{
                cell.checkmarkModel = model
                cell.accessoryType = .none
            }
        }else{
            cell.model = model
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .groupTableViewBackground
        let titleLabel = UILabel()
        titleLabel.text = self.dataSources[section].title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .systemGray
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
        ])
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        setCornerRadiusForSectionCell(cell: cell, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = self.dataSources[indexPath.section]
        let model = section.list[indexPath.row]
        if section.title == String.edLocalizedString(withKey: "title.language") {
            let language = EDLanguage.init(rawValue: model.key) ?? .English
            EasyDebug.shared.options.language = language
            EDLocalizationSetting.setCurrentLanguage(language)
            NotificationCenter.default.post(name: NotificationNameKeyReset, object: nil)
        }
        if section.title == String.edLocalizedString(withKey: "title.network") {
            let vc = EDBlackListController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if section.title == String.edLocalizedString(withKey: "title.log") {
            let alertVC = UIAlertController(title: String.edLocalizedString(withKey: "title.log.alert"),
                                            message: String.edLocalizedString(withKey: "title.log.alert.des"),
                                            preferredStyle: .actionSheet)
            EDLogLevel.allCases.forEach { level in
                let action = UIAlertAction(title: level.rawValue + level.description , style: .default) { action in
                    EasyDebug.shared.options.filterLevel = EDLogLevel.init(rawValue: level.rawValue) ?? .default
                    self.parseData()
                    self.tableView.reloadData()
                }
                alertVC.addAction(action)
               
            }
            self.present(alertVC, animated: true)
        }
    }
    
    private func setCornerRadiusForSectionCell(cell: UITableViewCell, indexPath: IndexPath) {
        let cornerRadius:CGFloat = 10.0
        let sectionCount = tableView.numberOfRows(inSection: indexPath.section)
        let shapeLayer = CAShapeLayer()
        cell.layer.mask = nil
        if sectionCount > 1 {
            switch indexPath.row {
            case 0:
                var bounds = cell.bounds
                bounds.origin.y += 1.0
                let bezierPath = UIBezierPath(roundedRect: bounds,
                                              byRoundingCorners: [.topLeft,.topRight],
                                              cornerRadii: CGSize(width: cornerRadius,height: cornerRadius))
                shapeLayer.path = bezierPath.cgPath
                cell.layer.mask = shapeLayer
            case sectionCount - 1:
                var bounds = cell.bounds
                bounds.size.height -= 1.0
                let bezierPath = UIBezierPath(roundedRect: bounds,
                                              byRoundingCorners: [.bottomLeft,.bottomRight],
                                              cornerRadii: CGSize(width: cornerRadius,height: cornerRadius))
                shapeLayer.path = bezierPath.cgPath
                cell.layer.mask = shapeLayer
            default:
                break
            }
        }
        else {
            let bezierPath = UIBezierPath(roundedRect:
                                            cell.bounds.insetBy(dx: 0.0, dy: 2.0),
                                          cornerRadius: cornerRadius)
            shapeLayer.path = bezierPath.cgPath
            cell.layer.mask = shapeLayer
        }
    }
    
}
