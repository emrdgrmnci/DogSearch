//
//  AppRouter.swift
//  DogSearch
//
//  Created by TextalkMedia-Emre on 2022-10-07.
//
import UIKit.UIWindow

final class AppRouter {
  let window: UIWindow?
  let status = Reach().connectionStatus()

  init(window: UIWindow?) {
    self.window = window
  }

  private func networkStatusChanged() {
    NotificationCenter.default.addObserver(self, selector: #selector(AppRouter.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
    Reach().monitorReachabilityChanges()
  }

  func checkNetworkStatusTypes() {
    switch status {
    case .offline:
      start()
    case .online(_):
      start()
    case .unknown:
      break
    }
  }

  @objc func networkStatusChanged(_ notification: Notification) {
    if let userInfo = notification.userInfo {
      let status = userInfo["Status"] as! String
      print(status)
    }
  }

  func start() {
    let rootViewController = MainViewControllerBuilder.make()
    let navigationController = UINavigationController(rootViewController: rootViewController)

    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
}
