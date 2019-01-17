///**
/**
Created by: Hiep Nguyen Nghia on 1/17/19
Copyright (c) 2018 Vietinterview. All rights reserved.
*/

import UIKit

class ButtonWithImage: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            titleEdgeInsets = UIEdgeInsets(top: 25, left: -(bounds.width/7), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: -25, left: (bounds.width/3), bottom: 0, right: 0)
        }
    }
}
