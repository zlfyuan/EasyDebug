//
//  EDNetworkingDetailController.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/3.
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

class EDNetworkingDetailController: EDTableController {
    
    var model = EDNetWorkStructure()
    typealias SectionData = (title: String,info: [[String: Any]])
    init(with model: EDNetWorkStructure) {
        super.init(style: .grouped)
        self.model = model
        self.title = self.model.requestLine.url?.host
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataSources = [SectionData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.register(EDNetworkDetailCell.classForCoder(), forCellReuseIdentifier: reuseIdentifier)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = true
        
        parseData()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: String.edLocalizedString(withKey: "title.share"), style: .plain, target: self, action: #selector(shareBarButtonItemAction)),
                                                   UIBarButtonItem(title: String.edLocalizedString(withKey: "title.copy"), style: .plain, target: self, action: #selector(copyButtonItemAction))]
    }
    
    @objc func shareBarButtonItemAction() {
        let text = self.model.description
        EDCommon.share(text, in: self)
    }
    
    @objc func copyButtonItemAction() {
        guard self.navigationItem.rightBarButtonItem?.title == String.edLocalizedString(withKey: "title.copy") else{ return }
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.model.description
        if let rightBarButtonItem = self.navigationItem.rightBarButtonItems?.first {
            rightBarButtonItem.title = String.edLocalizedString(withKey: "title.yes")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // 这里是需要延时执行的代码
                rightBarButtonItem.title = String.edLocalizedString(withKey: "title.copy")
            }
        }
        
    }
    
    @objc func sectionCopyAction(_ button: UIButton) {
        guard button.titleLabel?.text == String.edLocalizedString(withKey: "title.copy") else{ return }
        let index = button.tag - 1000
        let model = dataSources[index]
        var pasteboardString = ""
        model.info.forEach { dic in
            dic.forEach { (key: String, value: Any) in
                pasteboardString += "\(key):\n"
                pasteboardString += "\(value)\n"
            }
        }
        let pasteboard = UIPasteboard.general
        pasteboard.string = pasteboardString
        button.setTitle(String.edLocalizedString(withKey: "title.yes"), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 这里是需要延时执行的代码
            button.setTitle(String.edLocalizedString(withKey: "title.copy"), for: .normal)
        }
    }
    
    func parseData() {
        let general:SectionData = (title: String.edLocalizedString(withKey: "title.General"),
                                   info:[["Request Url": self.model.requestLine.url?.absoluteString ?? "null"],
                                         ["Request Method": self.model.requestLine.httpMethod ?? "null"],
                                         ["HTTP Status": "\(self.model.responseStateLine.statusCode)"],
                                         ["Request Start Time": Date.dateToString(date: self.model.startDate, formatter: "yyyy-MM-dd HH:mm:ss") ],
                                         ["Request timeElapsed": "\(round(self.model.timeElapsed * 1000))"]])
        var _reh = [[String: Any]]()
        self.model.edRequestHeader.values?.forEach({ (key: String, value: String) in
            _reh.append([key:value as Any])
        })
        let requestHeaders:SectionData = (title: String.edLocalizedString(withKey: "title.Request Headers"),
                                          info: _reh)
        
        let queryStringParameters:SectionData = (title: String.edLocalizedString(withKey: "title.Query String Parameters"),
                                                 info:[["body": showJson(value: self.model.edRequestBodyInfo.values as Any)]])
        var _reph = [[String: Any]]()
        self.model.edReponseHeader.values?.forEach({ (key: String, value: String) in
            _reph.append([key:value as Any])
        })
        let responseHeaders:SectionData = (title: String.edLocalizedString(withKey: "title.Response Headers"),
                                           info: _reph)
        
        let responseBody:SectionData = (title: String.edLocalizedString(withKey: "title.Response Body"),
                                        info:[["body":showJson(value: self.model.edResponseBodyInfo.values as Any)]])
        dataSources = [
            general,
            requestHeaders,
            queryStringParameters,
            responseHeaders,
            responseBody
        ]
        
        self.tableView.reloadData()
    }
    
    func showJson(value: Any) -> String{
        
        guard let _value = value as? String,
              let jsonData = _value.data(using: .utf8) else {
            return ""
        }
        guard let prettyJSON = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers),
              let prettyData = try? JSONSerialization.data(withJSONObject: prettyJSON, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return _value
        }
        return prettyString

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
    
    let reuseIdentifier = "reuseIdentifierEdNetworkDetailCell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EDNetworkDetailCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EDNetworkDetailCell
        cell.configure(info: self.dataSources[indexPath.section].info)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
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
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .systemGray
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
        ])
        let button = UIButton.init(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.tag = section + 1000
        button.setTitle(String.edLocalizedString(withKey: "title.copy"), for: .normal)
        button.addTarget(self, action: #selector(sectionCopyAction(_ :)), for: .touchUpInside)
        headerView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //            button.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            button.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            button.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
        ])
        return headerView
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

