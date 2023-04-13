//
//  EDLogDetailController.swift
//  EasyDebug
//
//  Created by zluof on 1623/4/13.
//  Copyright © 1623 zluof <https://github.com/zlfyuan/>
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

class EDLogDetailController: EDBaseController {
    let dateLabel = UILabel()
    let fileNameLabel = UILabel()
    let lineLabel = UILabel()
    let levelLabel = UILabel()
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.font = UIFont.systemFont(ofSize: 17)
        
        fileNameLabel.font = UIFont.systemFont(ofSize: 14)
        fileNameLabel.textColor = .systemGray
        
        lineLabel.font = UIFont.systemFont(ofSize: 13)
        lineLabel.textColor = .systemGray
        
        levelLabel.font = UIFont.systemFont(ofSize: 13)
        levelLabel.textColor = .systemGray
        
        textView.textColor = .systemGray
        
        self.view.addSubview(dateLabel)
        self.view.addSubview(fileNameLabel)
        self.view.addSubview(lineLabel)
        self.view.addSubview(levelLabel)
        self.view.addSubview(textView)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        fileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lineLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            fileNameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            fileNameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            fileNameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            lineLabel.topAnchor.constraint(equalTo: fileNameLabel.bottomAnchor, constant: 5),
            lineLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            lineLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            levelLabel.topAnchor.constraint(equalTo: lineLabel.bottomAnchor, constant: 5),
            levelLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            levelLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            textView.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 15),
            textView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: String.edLocalizedString(withKey: "title.share"), style: .plain, target: self, action: #selector(shareBarButtonItemAction))]
    }
    
    @objc func shareBarButtonItemAction() {
        if let text = self.logModel?.message {
            EDCommon.share(text, in: self)
        }
    }
    
    var logModel: EDLogData? = nil {
        didSet{
            guard let _model = logModel else { return }
            self.title = _model.fileName
            dateLabel.text = "date: \(_model.date.toString(format: "yyyy-MM-dd-HH:mm.ss.SSSS"))"
            fileNameLabel.text = "file: \(_model.fileName)"
            lineLabel.text = "line: \(_model.line)"
            levelLabel.text = "level: \(_model.level.rawValue)  \(_model.level.description)"
            textView.text = "content: \n\( _model.message)"
        }
    }
}
