//
//  EDLogCell.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/11.
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
class EDLogCell: UITableViewCell {
    
    fileprivate let dateLabel = UILabel()
    fileprivate let stateLabel = UILabel()
    fileprivate let messageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(reuseIdentifier: String?) {
        self.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(dateLabel)
        
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        stateLabel.textColor = .systemGray
        contentView.addSubview(stateLabel)
        
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.numberOfLines = 10
        messageLabel.textColor = .systemGray
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            stateLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 6),
            stateLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: 0),
            stateLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 6),
            messageLabel.leadingAnchor.constraint(equalTo: stateLabel.leadingAnchor, constant: 0),
            messageLabel.trailingAnchor.constraint(equalTo: stateLabel.trailingAnchor, constant: 0),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    var model: EDLogData? = nil {
        didSet{
            guard let _model = model else {
                return
            }
            dateLabel.text = "\(_model.level.rawValue)  \(_model.date.toString(format: "yyyy-MM-dd-HH:mm.ss.SSSS"))"
            var state = "\(_model.fileName)"
            state += "  line: \(_model.line)"
            stateLabel.text = state
            messageLabel.text = "\(_model.message)"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

