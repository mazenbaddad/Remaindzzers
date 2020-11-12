//
//  CategoryTableHeaderView.swift
//  Remaindzzers
//
//  Created by mazen baddad on 11/11/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit

class CategoryTableHeaderView : UITableViewHeaderFooterView {
    
    var catagoryImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(catagoryImageView)
        catagoryImageView.setConstraints(leadingAnchor, 10, topAnchor, 5 , nil , 20 , bottomAnchor , -5)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
