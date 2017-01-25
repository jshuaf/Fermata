//
//  DetailTableViewCell.swift
//  Fermata
//
//  Created by jfang19 on 1/16/17.
//  Copyright © 2017 joshuafang. All rights reserved.
//

import UIKit

enum DetailTableViewCellAccent {
  case Small
  case Medium
  case Large
}

class DetailTableViewCell: UITableViewCell {
  var badgeView: UIView?

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    accessoryType = .disclosureIndicator
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  internal func setupTextLabels(titleText: String, firstDetailText: String, secondDetailText: String?) {
    let labelsView = contentView.addView(x: 0.87, y: 1.05, w: 0.36, h: 0.72)
    labelsView.addLabel(style: LabelStyle.Body.Primary(), alignLeft: labelsView, y: 0.32, text: titleText)
    labelsView.addLabel(style: LabelStyle.Detail.Light(), alignLeft: labelsView, y: 1.21, text: firstDetailText)
    if secondDetailText != nil {
      labelsView.addLabel(style: LabelStyle.Detail.Light(), alignLeft: labelsView, y: 1.76, text: secondDetailText!)
    }
  }

  internal func setupLeftBadge(accent: DetailTableViewCellAccent, mainText: String, detailText: String) {
    badgeView = contentView.addView(x: 0.25, y: 1.03, w: 0.15, whRatio: 1)
    let borderColor: UIColor
    let backgroundColor: UIColor

    switch accent {
    case .Small:
      backgroundColor = .lime
      borderColor = .lemonlime
    case .Medium:
      backgroundColor = .tangerine
      borderColor = .clementine
    case .Large:
      backgroundColor = .grapefruit
      borderColor = .watermelon
    }
    badgeView?.layer.borderColor = borderColor.cgColor
    badgeView?.layer.borderWidth = 5
    badgeView?.layer.backgroundColor = backgroundColor.cgColor

    badgeView?.addLabel(style: LabelStyle.HeaderTwo.Primary(), x: 1, y: 0.75, text: mainText)
    badgeView?.addLabel(style: LabelStyle.Detail.Light(), x: 1, y: 1.36, text: detailText)
  }

  override internal func layoutSubviews() {
    super.layoutSubviews()
    badgeView?.layer.cornerRadius = badgeView!.superview!.frame.width * 0.15 / 2
  }

}
