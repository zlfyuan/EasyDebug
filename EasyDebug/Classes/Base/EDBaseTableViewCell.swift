//
//  EDBaseTableViewCell.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/6.
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


class EDBaseTableViewCell: UITableViewCell {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundView?.layer.cornerRadius = 10
        self.backgroundView?.layer.masksToBounds = true
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        self.subviews.forEach { view in
            if let cl = NSClassFromString("_UISystemBackgroundView") {
                if view.isKind(of: cl.class()){
                    view.layer.cornerRadius = 10
                    view.layer.masksToBounds = true
                }
            }
        }
    }
    
    func configure(info: [[String: Any]]) {
        stackView.subviews.forEach({$0.removeFromSuperview()})
        info.forEach { dic in
            dic.forEach { (key: String, value: Any) in
                let keyLabel = UILabel()
                keyLabel.text = key
                keyLabel.font = UIFont.systemFont(ofSize: 15)
                keyLabel.numberOfLines = 0
                keyLabel.translatesAutoresizingMaskIntoConstraints = false
                let valueLabel = UILabel()
                valueLabel.text = "\(value)"
                valueLabel.font = UIFont.systemFont(ofSize: 12)
                valueLabel.textColor = .systemGray
                valueLabel.numberOfLines = 0
                keyLabel.translatesAutoresizingMaskIntoConstraints = false
                
                stackView.addArrangedSubview(keyLabel)
                stackView.addArrangedSubview(valueLabel)
                valueLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
                valueLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
                keyLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
                keyLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
            }
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

