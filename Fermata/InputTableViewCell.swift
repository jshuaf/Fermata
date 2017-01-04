//
//  InputTableViewCell.swift
//  Fermata
//
//  Created by jfang19 on 12/30/16.
//  Copyright © 2016 joshuafang. All rights reserved.
//

import UIKit
import Cartography

class InputTableViewCell: UITableViewCell {
  var textField: UITextField?
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    textLabel!.setLabelStyle(LabelStyle.Body.Primary)

    textField = contentView.addTextField(style: LabelStyle.Body.Primary, x: 1.1, y: 1)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(text: String, placeholder: String) {
    self.textLabel?.text = text
    self.textField?.placeholder = placeholder
  }

}
