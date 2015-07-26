//
//  DemoButton.swift
//  AlertSheetDemo
//
//  Created by JQ@Onbeep on 7/17/15.
//  Copyright (c) 2015 jimqin. All rights reserved.
//

import UIKit

class DemoButton: UIButton {

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
        setTitle("Display Alert Sheet", forState: UIControlState.Normal)
        backgroundColor = UIColor(red: 112/255.0, green: 206/255.0, blue: 216/255.0, alpha: 1.0)
        layer.cornerRadius = DemoButtonAppearance.cornerRadius
        opaque = true
        showsTouchWhenHighlighted = true
    }
}
