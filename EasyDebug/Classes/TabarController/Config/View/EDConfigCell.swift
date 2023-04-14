//
//  EDConfigCell.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/14.
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

class EDConfigCell: UITableViewCell {
    
    
    fileprivate let titleLabel = UILabel()
    fileprivate let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(titleLabel)
        
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = .systemGray
        valueLabel.numberOfLines = 0
        valueLabel.textAlignment = .right
        valueLabel.text = "     "
        contentView.addSubview(valueLabel)
        
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            valueLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width / 2),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
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
            accessoryType = .disclosureIndicator
            titleLabel.text = _model.key
            valueLabel.text = "\(_model.value)"
        }
    }
    
    var checkmarkModel: ConfigRow? = nil {
        didSet{
            guard let _model = checkmarkModel else {
                return
            }
            accessoryType = .checkmark
            titleLabel.text = _model.key
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

