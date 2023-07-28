//
//  EDNetworkingController.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/2.
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

class EDNetworkingController: EDTableController {
    
    var dataSources = EDNetWorkManger.shared.netWorkDataSources
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSources = EDNetWorkManger.shared.netWorkDataSources
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = createFooterView()
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func createFooterView() -> UIView {
        let footView = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.size.width, height: 80))
        footView.text = "\(dataSources.count) \(String.edLocalizedString(withKey: "title.count"))"
        footView.font = UIFont.systemFont(ofSize: 14)
        footView.textColor = .systemGray
        footView.textAlignment = .center
        return footView
    }
    
    func updateCountLabel() {
        if let label = self.tableView.tableFooterView as? UILabel{
            label.text = "\(dataSources.count) \(String.edLocalizedString(withKey: "title.count"))"
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as? EDNetworkCell
        if cell == nil {
            cell = EDNetworkCell.init(reuseIdentifier: "reuseIdentifier")
        }
        let model = self.dataSources[indexPath.section]
        cell?.model = model
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSources[indexPath.section]
        self.navigationController?.pushViewController(EDNetworkingDetailController(with: model), animated: true)
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
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let copyAction = UITableViewRowAction(style: .normal, title: String.edLocalizedString(withKey: "title.copy")) { (action, indexPath) in
            let model = self.dataSources[indexPath.section]
            EDLogInfo(model.description)
            let pasteboard = UIPasteboard.general
            pasteboard.string = model.description
        }
        copyAction.backgroundColor = .systemBlue
        let deleteAction = UITableViewRowAction(style: .destructive, title: String.edLocalizedString(withKey: "title.delete")) { (action, indexPath) in
            tableView.beginUpdates()
            self.tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: .fade)
            self.dataSources.remove(at: indexPath.section)
            EDNetWorkManger.shared.netWorkDataSources = self.dataSources
            tableView.endUpdates()
        }
        return [deleteAction,copyAction]
    }
    
}

extension EDNetworkingController: EDFeatureActionable {
    
    func clearResults() {
        dataSources = []
        EDNetWorkManger.shared.netWorkDataSources = []
        updateCountLabel()
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchText: String?) {
        if let keyword = searchText,!keyword.isEmpty {
            dataSources = EDNetWorkManger.shared.netWorkDataSources.filter { (model: EDNetWorkStructure) -> Bool in
                if let url = model.requestLine.url?.absoluteString {
                    return url.lowercased().contains(keyword.lowercased())
                }
                if let method = model.responseStateLine.httpMethod {
                    return method.lowercased().contains(keyword.lowercased())
                }
                let code = model.responseStateLine.statusCode
                return "\(code)".lowercased().contains(keyword.lowercased())
            }
        } else {
            dataSources = EDNetWorkManger.shared.netWorkDataSources
        }
        updateCountLabel()
        tableView.reloadData()
    }
}
