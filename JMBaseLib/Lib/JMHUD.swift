//
//  JMHUD.swift
//  JMBaseLib
//
//  Created by 梁建斌 on 2018/4/24.
//  Copyright © 2018年 SunlandGroup. All rights reserved.
//

import UIKit
import PKHUD

public class JMHUD: NSObject {
    public class func show(_ title: String?) {
        if title != nil {
            HUD.dimsBackground = false
            HUD.allowsInteraction = true
            HUD.show(.label(title))
            HUD.hide(afterDelay: 1)
        }
    }
    
    public class func showHud(_ title: String? = "", subtitle: String?, allowInteraction: Bool = false) {
        HUD.dimsBackground = !allowInteraction
        HUD.allowsInteraction = allowInteraction
        HUD.show(.labeledProgress(title: title, subtitle: subtitle))
    }
    
    public class func hideHud() {
        HUD.allowsInteraction = true
        HUD.hide()
    }
}
