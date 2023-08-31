//
//  BaseTabBarController.swift
//  DesignKit
//
//  Created by Mushfiq Humayoon on 31/08/23.
//

import UIKit

open class BaseTabBarController: UITabBarController, Themeable {

    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    fileprivate var statusBarHeight = UIApplication.statusBarHeight()

    override open func viewDidLoad() {
        super.viewDidLoad()
        addGradientBackground()
        makeBackgroundIsTranslucent()
        updateDeviceSpecifiedTabBarLayout()
    }

    open func apply(theme: Theme) {
        tabBar.tintColor = UIColor.white
        tabBar.barStyle = theme.barStyle
        tabBar.tintColor = .blue
        tabBar.unselectedItemTintColor = .gray
    }
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("the selected index is : \(String(describing: tabBar.items?.firstIndex(of: item)))")
        UserDefaults.standard.set(tabBar.items?.firstIndex(of: item), forKey: "currentTabIndex")
    }
    private func makeBackgroundIsTranslucent() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .clear
        tabBar.barTintColor = .clear
    }
    private func addGradientBackground() {
        let bounds = tabBar.bounds
        let topPadding: CGFloat = UIApplication.statusBarHeight() > 20 ? 10 : 20
        let frame = CGRect(x: 0, y: bounds.minY - topPadding, width: bounds.width, height: bounds.height + 55)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.3)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = frame
        gradientLayer.cornerRadius = 25
        gradientLayer.shadowColor = UIColor.lightGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.opacity = 1.0
        gradientLayer.masksToBounds = false
        let shadowFrame = CGRect(x: 0, y: bounds.minY - 10, width: bounds.width, height: bounds.height + 55)
        gradientLayer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 25).cgPath
        tabBar.layer.insertSublayer(gradientLayer, at: 0)
    }
    private func updateDeviceSpecifiedTabBarLayout() {
        guard  statusBarHeight > 20 else {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
            if let items = tabBar.items {
                items.forEach { item in
                    item.imageInsets = UIEdgeInsets(top: -10, left: 0, bottom: 10, right: 0)
                }
            }
            return
        }
    }
}
