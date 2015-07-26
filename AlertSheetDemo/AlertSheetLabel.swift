//
//  AlertSheetMessageLabel.swift
//  OnBeep
//
//  Created by JQ@Onbeep on 2/27/15.
//  Copyright (c) 2015 OnBeep, Inc. All rights reserved.
//

import UIKit

class AlertSheetLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureAppearance()
    }

    convenience init() {
        self.init(frame: CGRect.zeroRect)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAppearance() {
        numberOfLines = 0
        textAlignment = NSTextAlignment.Center
        lineBreakMode = NSLineBreakMode.ByWordWrapping
        font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
        textColor = UIColor.whiteColor()
        backgroundColor = UIColor(red: 112/255.0, green: 206/255.0, blue: 216/255.0, alpha: 1.0)
        opaque = true
    }
}
