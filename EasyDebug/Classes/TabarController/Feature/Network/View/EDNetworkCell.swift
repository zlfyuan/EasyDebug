//
//  EDNetworkCell.swift
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

class EDNetworkCell: UITableViewCell {
    
    fileprivate let pathLabel = UILabel()
    fileprivate let stateLabel = UILabel()
    fileprivate let timeLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(reuseIdentifier: String?) {
        self.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        pathLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pathLabel.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(pathLabel)
        
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        stateLabel.textColor = .systemGray
        contentView.addSubview(stateLabel)
        
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = .systemGray
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            pathLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            pathLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pathLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            //            pathLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        
        NSLayoutConstraint.activate([
            stateLabel.topAnchor.constraint(equalTo: pathLabel.bottomAnchor, constant: 6),
            stateLabel.leadingAnchor.constraint(equalTo: pathLabel.leadingAnchor, constant: 0),
            stateLabel.trailingAnchor.constraint(equalTo: pathLabel.trailingAnchor, constant: 0),
        ])
        
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 6),
            timeLabel.leadingAnchor.constraint(equalTo: stateLabel.leadingAnchor, constant: 0),
            timeLabel.trailingAnchor.constraint(equalTo: stateLabel.trailingAnchor, constant: 0),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
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
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    var model: EDNetWorkStructure? = nil {
        didSet{
            guard let _model = model else {
                return
            }
            pathLabel.text = _model.requestLine.url?.path
            var state = "\(_model.responseStateLine.httpMethod ?? "")"
            state += "  \(_model.responseStateLine.statusCode)"
            state += "  \(_model.responseStateLine.protocolVersion?.uppercased() ?? "")"
            stateLabel.text = state
            let date = Date.dateToString(date: _model.startDate, formatter: "yyyy-MM-dd HH:mm:ss")
            timeLabel.text = "\(date)" + "\t\(round(_model.timeElapsed * 1000))"
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
