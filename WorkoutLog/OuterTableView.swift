//
//  OuterTableView.swift
//  WorkoutLog
//
//  Created by Nathan Lanza on 8/23/16.
//  Copyright © 2016 Nathan Lanza. All rights reserved.
//

import UIKit

class OuterTableView: UITableView {


    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        tableFooterView = UIView()
        backgroundColor = Theme.Colors.outerTableViewBackground

//        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
