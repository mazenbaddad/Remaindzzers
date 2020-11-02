//
//  RemainderTableViewCell.swift
//  Remaindzzers
//
//  Created by mazen baddad on 10/31/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit

class RemainderTableViewCell : UITableViewCell {
    
    static var cellID : String = "RemainderTableViewCell"
    
    var timestampLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var lineView : UIView = {
        let view = UIView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default
        setupViews()
        setupTheme()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.layoutIfNeeded()
        var size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        if let textLabel = self.textLabel, let detailTextLabel = self.detailTextLabel{
            size.height += textLabel.frame.height + detailTextLabel.frame.height + 20
        }
        

        return size
    }
    
    fileprivate func setupViews() {
        self.addSubview(lineView)
        self.addSubview(timestampLabel)
        
        
        timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        timestampLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        
        lineView.setConstraints(leadingAnchor, 50, nil, 0.5 , trailingAnchor , 0 , bottomAnchor , 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

//MARK:- Themed

extension RemainderTableViewCell : Themed {
    func applyTheme(_ theme: Theme) {
        self.backgroundColor = theme.secondaryBackgroundColor
        self.lineView.backgroundColor = theme.tertiaryLabelColor
        self.detailTextLabel?.textColor = theme.secondaryLabelColor
        self.timestampLabel.textColor = theme.secondaryLabelColor
    }
}
