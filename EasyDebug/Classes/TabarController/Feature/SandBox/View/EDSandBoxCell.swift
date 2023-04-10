//
//  EDSandBoxCell.swift
//  EasyDebug
//
//  Created by zluof on 2023/4/8.
//

class EDSandBoxCell: UITableViewCell {
    
    fileprivate let pathLabel = UILabel()
    fileprivate let sizeLabel = UILabel()
    fileprivate let timeLabel = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(reuseIdentifier: String?) {
        self.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        
        pathLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pathLabel.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(pathLabel)
        
        sizeLabel.font = UIFont.systemFont(ofSize: 14)
        sizeLabel.textColor = .systemGray
        contentView.addSubview(sizeLabel)
        
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = .systemGray
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            pathLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            pathLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pathLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: pathLabel.bottomAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: pathLabel.leadingAnchor, constant: 0),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            sizeLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor, constant: 0),
            sizeLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 30),
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
            pathLabel.text = _model.name
           
            sizeLabel.text = _model.sizeStr
           
            timeLabel.text =  Date.dateToString(date: _model.modificationDate, formatter: "yyyy-MM-dd HH:mm:ss")
            
            self.accessoryType = _model.subFiles.count != 0 ? .disclosureIndicator : .none
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
