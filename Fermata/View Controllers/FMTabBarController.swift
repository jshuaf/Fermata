//
//  FMTabBarController.swift
//  Fermata
//
//  Created by jfang19 on 11/18/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit

class FMTabBarController: UITabBarController {

  @IBInspectable var defaultIndex: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    selectedIndex = defaultIndex
  }

}
