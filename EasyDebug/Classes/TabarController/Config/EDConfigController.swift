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
class EDConfigController: EDTableController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the custom cell
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
       
        if indexPath.section == 0 {
            let titleLabel = UILabel()
            cell.contentView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            let contentLabel = UILabel()
            titleLabel.text = "debug"
            contentLabel.text = "\(EasyDebug.shared.options.debug)"
            contentLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(contentLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                titleLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                
                contentLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
                contentLabel.trailingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: -20),
                contentLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
        }else{
            let titleLabel = UILabel()
            cell.contentView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            let switchControl = UISwitch()
            titleLabel.text = "中文/英文"
            switchControl.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(switchControl)
            
            let contentLabel = UILabel()
            contentLabel.text = "\(EasyDebug.shared.options.language.rawValue)"
            contentLabel.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(contentLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20),
                titleLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                switchControl.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
                switchControl.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                
                
                contentLabel.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -20),
                contentLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
                
            ])
        }
        
        cell.contentView.layer.cornerRadius = 6.0
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
}
