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

class EDConfigCell: UITableViewCell {

    
    fileprivate let titleLabel = UILabel()
    fileprivate let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(reuseIdentifier: String?) {
        self.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(titleLabel)
        
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = .systemGray
        valueLabel.numberOfLines = 0
        contentView.addSubview(valueLabel)
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: contentView.frame.width / 2),
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8)
        ])
        
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    var model: ConfigRow? = nil {
        didSet{
            guard let _model = model else {
                return
            }
            titleLabel.text = _model.key
            valueLabel.text = "\(_model.value)"
        }
    }
    
    override var frame: CGRect {
        didSet{
            var newFrame = frame
            newFrame.origin.x += 16
            newFrame.size.width -= 32
            super.frame = newFrame
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


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
        
        let log = [ConfigRow(key: "level", value: "dataSourcesdataSourcesdataSourcesdataSourcesdataSourcesdataSourcesdataSourcesdataSourcesdataSourcesdataSources")]
        dataSources.append(ConfigSection(title:String.edLocalizedString(withKey: "title.log"), list: log))
        
        let netWork = [ConfigRow(key: "黑名单", value: 10)]
        dataSources.append(ConfigSection(title:String.edLocalizedString(withKey: "title.network"), list: netWork))
        
        let language = EDLanguage.allCases.map({ ConfigRow(key: $0.rawValue, value: false) })
        dataSources.append(ConfigSection(title:String.edLocalizedString(withKey: "title.language"), list: language))
        
        // Register the custom cell
        tableView.register(EDConfigCell.classForCoder(), forCellReuseIdentifier: "cell")
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
        if section.title == String.edLocalizedString(withKey: "title.language") {
            let cell = EDConfigCell(style: .default, reuseIdentifier: "cell")
            if "\(model.key)" == EasyDebug.shared.options.language.rawValue {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            cell.textLabel?.text = model.key
            return cell
        }else{
            let cell = EDConfigCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.text = model.key
            cell.detailTextLabel?.text = "\(model.value)"
            return cell
        }
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
