//
//  EDLogController.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/7.
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

import Foundation

class EDLogController: EDTableController {
    
    var dataSources = EDLog.shared.logInfo
    var searchController: UISearchController!
    var filteredContacts = [EDLogData]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSources = EDLog.shared.logInfo
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = createFooterView()
    }
    
    func createFooterView() -> UIView {
        let footView = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.size.width, height: 80))
        footView.text = "共\(dataSources.count)项"
        footView.font = UIFont.systemFont(ofSize: 14)
        footView.textColor = .systemGray
        footView.textAlignment = .center
        return footView
    }
    
    func updateCountLabel() {
        if let label = self.tableView.tableFooterView as? UILabel{
            label.text = "共\(dataSources.count)项"
        }
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as? EDLogCell
        if cell == nil {
            cell = EDLogCell.init(reuseIdentifier: "reuseIdentifier")
        }
        let model = self.dataSources[indexPath.section]
        cell?.model = model
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSources[indexPath.section]
        let logDetailVc = EDLogDetailController()
        logDetailVc.logModel = model
        self.navigationController?.pushViewController(logDetailVc, animated: true)
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

extension EDLogController: EDFeatureActionable {
    func updateSearchResults(for searchText: String?) {
        if let keyword = searchText,!keyword.isEmpty {
            dataSources = EDLog.shared.logInfo.filter { (model: EDLogData) -> Bool in
                return model.message.lowercased().contains(keyword.lowercased())
            }
        } else {
            dataSources = EDLog.shared.logInfo
        }
        updateCountLabel()
        tableView.reloadData()
    }
    
    func clearResults() {
        EDLog.shared.logInfo = []
        dataSources = []
        updateCountLabel()
        self.tableView.reloadData()
    }
}
