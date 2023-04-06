//
//  EDAppInfoController.swift
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

class EDAppInfoController: UITableViewController {
    typealias SectionData = (title: String,info: [[String: Any]])

    var dataSources = [SectionData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 85
        tableView.keyboardDismissMode = .onDrag
        tableView.register(EDAppInfoCell.classForCoder(), forCellReuseIdentifier: reuseIdentifier)
        parseData()
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
    }
    
    func parseData() {
        let appInstace = EDApplication()
        let dic = appInstace.values.filter({$0.key != "permissionsUsageDescription" && $0.key != "xcode"})
        let app = SectionData(title:"app" ,info:[dic])
        dataSources.append(app)
        
        let deviceInstace = EDDevice()
        let device = SectionData(title:"device" ,info:[deviceInstace.values])
        dataSources.append(device)
        
        
        if let permissions = appInstace.values["permissionsUsageDescription"] as? [String: Any] {
            let permission = SectionData(title:"permission",info:[permissions])
            dataSources.append(permission)
        }
        
        if let xcode = appInstace.values["xcode"] as? [String: Any] {
            let _xcode = SectionData(title:"xcode",info:[xcode])
            dataSources.append(_xcode)
        }
        
        
        self.tableView.reloadData()
    }
 
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.dataSources.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    let reuseIdentifier = "reuseIdentifierEDAppInfoCell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EDAppInfoCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EDAppInfoCell
        cell.configure(info: self.dataSources[indexPath.section].info)
        return cell
    }
       
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .groupTableViewBackground
        let titleLabel = UILabel()
        titleLabel.text = self.dataSources[section].title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
}
