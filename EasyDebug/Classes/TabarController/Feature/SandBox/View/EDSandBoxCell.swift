//
//  EDSandBoxCell.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/8.
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

class EDSandBoxCell: UITableViewCell {
    
    fileprivate let pathLabel = UILabel()
    fileprivate let sizeLabel = UILabel()
    fileprivate let timeLabel = UILabel()
    fileprivate let iconImageView = UIImageView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(reuseIdentifier: String?) {
        self.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        
        pathLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        pathLabel.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(pathLabel)
        
        sizeLabel.font = UIFont.systemFont(ofSize: 14)
        sizeLabel.textColor = .systemGray
        contentView.addSubview(sizeLabel)
        
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = .systemGray
        contentView.addSubview(timeLabel)
        
        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            pathLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: -10),
            pathLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            pathLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: pathLabel.leadingAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            sizeLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor, constant: 0),
            sizeLabel.trailingAnchor.constraint(equalTo: pathLabel.trailingAnchor, constant: 0),
        ])
        
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    var model: FileDataModel? = nil {
        didSet{
            guard let _model = model else {
                return
            }
            
            iconImageView.image = UIImage.getBundleImage(withName: _model.subFiles.count > 0 ? "folder" : "doc")
            
            pathLabel.text = _model.name
           
            sizeLabel.text = "\(_model.subFiles.count)项\t\t\(_model.sizeStr)"
           
            timeLabel.text =  Date.dateToString(date: _model.modificationDate, formatter: "yyyy-MM-dd HH:mm:ss")
            
            self.accessoryType = _model.subFiles.count != 0 ? .disclosureIndicator : .none
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
