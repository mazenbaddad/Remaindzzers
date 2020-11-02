//
//  String-extension.swift
//  AwkwardChat
//
//  Created by mazen baddad on 2/29/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit

extension String {
    
    /// - returns: The size that will fit Self
    func size(withMaximumWidth width : CGFloat , font : UIFont) -> CGSize{
        let constraintRect = CGSize(width: width , height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return boundingBox.size
    }
}
