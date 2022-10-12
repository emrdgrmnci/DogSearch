//
//  UIViewController+Ext.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//

import UIKit.UIViewController

extension UIViewController {
  func createActivityIndicator() -> UIActivityIndicatorView {
    let activityView = UIActivityIndicatorView(style: .large)
    activityView.tintColor = .blue
    activityView.center = view.center
    activityView.hidesWhenStopped = true
    view.addSubview(activityView)
    return activityView
  }
}
