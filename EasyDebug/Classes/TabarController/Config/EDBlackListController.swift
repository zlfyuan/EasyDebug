//
//  EDBlackListController.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/14.
//

import Foundation

class EDBlackListController: EDBaseController, UITableViewDataSource,UITableViewDelegate {
    
    var tableView = UITableView()
    var textField = UITextField()
    var changeIndex = -1
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDefaults.standard.set(EDNetWorkManger.shared.blacklist, forKey: EDNetWorkManger.shared.blacklistKey)
        UserDefaults.standard.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = String.edLocalizedString(withKey: "title.blacklist")
        
        let topView = UIView(frame: CGRect.init(x: 20, y: self.navigationController!.navigationBar.frame.maxY + 10, width: self.view.frame.width - 40, height: 40))
        topView.layer.cornerRadius = 6.0
        topView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        topView.layer.borderWidth = 1.0
        view.addSubview(topView)
        
        textField = UITextField(frame: CGRect.init(x: 10, y: 0, width: topView.frame.width - 20, height: 40))
        textField.placeholder = String.edLocalizedString(withKey: "title.add")
        textField.delegate = self
        topView.addSubview(textField)
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0)
        ])
        
        // 注册自定义的cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(addAction))
    }
    
    @objc func addAction(_ item: UIBarButtonItem) {
        if let _text = textField.text,
           !_text.isEmpty {
            textField.resignFirstResponder()
            if self.changeIndex >= 0 {
                EDNetWorkManger.shared.blacklist[self.changeIndex] = _text
            }else{
                EDNetWorkManger.shared.blacklist.insert(_text, at: 0)
            }
            tableView.reloadData()
            textField.text = nil
            item.title = nil
        }
    }
    
    // MARK: - UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EDNetWorkManger.shared.blacklist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = EDNetWorkManger.shared.blacklist[indexPath.row]
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: String.edLocalizedString(withKey: "title.edit")) { (action, indexPath) in
            let model = EDNetWorkManger.shared.blacklist[indexPath.row]
            self.textField.text = model
            self.changeIndex = indexPath.row
            self.textField.becomeFirstResponder()
        }
        editAction.backgroundColor = .systemBlue
        let deleteAction = UITableViewRowAction(style: .destructive, title: String.edLocalizedString(withKey: "title.delete")) { (action, indexPath) in
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            EDNetWorkManger.shared.blacklist.remove(at: indexPath.row)
            self.tableView.endUpdates()
        }
        return [deleteAction,editAction]
    }
}

extension EDBlackListController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let item = self.navigationItem.rightBarButtonItem {
            item.title = String.edLocalizedString(withKey: "title.complete")
        }
        return true
    }
}
