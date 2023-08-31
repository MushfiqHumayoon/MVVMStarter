//
//  BaseViewController.swift
//  DesignKit
//
//  Created by Mushfiq Humayoon on 31/08/23.
//

import Foundation
open class BaseViewController: UIViewController, Themeable {
    //MARK: - Properties
    open var objectHandler: Any?
    open var fromView: String?
    open var dismissHandler: DismissTapHandler?

    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            indicator.widthAnchor.constraint(equalToConstant: 50),
            indicator.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1)
        ])
        return indicator
    }()
    //MARK: - View Did Load
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    open func apply(theme: Theme) {
        self.view.backgroundColor = theme.primary
    }
    //MARK: - Additional Methods
    open func hyperLinkedAttribute(string: String, with color: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: [.foregroundColor: color] )
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        let url = string.checkForUrls()
        url.forEach {
            guard let host = URLComponents(url: $0, resolvingAgainstBaseURL: false)?.host else { return }
            guard let range = string.range(of: host) else { return }
            let convertedRange = NSRange(range, in: string)
            attributedString.addAttributes([.link: $0, .foregroundColor: color], range: convertedRange)
        }
        return attributedString
    }
    open func contentSize(of textView: UITextView) -> CGSize {
        return textView.sizeThatFits(textView.bounds.size)
    }
    public func hideNavigationItems() {
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.leftBarButtonItem = nil
    }
    public func addDoneButtonOnKeyboard(for textField: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        done.tintColor = .blue
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        doneToolbar.tintColor = .blue
        textField.inputAccessoryView = doneToolbar
    }
    @objc fileprivate func doneButtonAction() {
        view.endEditing(true)
    }
    public func animateTabBar(hidden: Bool) {
        let tabBar = self.tabBarController?.tabBar
        var tabBarFrame = tabBar?.frame
        let operation: (CGFloat, CGFloat) -> CGFloat = hidden ? (+) : (-)
        let toggle = operation(self.view.frame.size.height, tabBarFrame?.size.height ?? 0)
        tabBarFrame?.origin.y = toggle
        tabBar?.layer.zPosition = 0
       UIView.animate(withDuration: 0.3, animations: {
           self.tabBarController?.tabBar.frame = tabBarFrame!
        })
    }
    public func imageWithGradient(gradientcolors: [UIColor], with frame: CGRect) -> UIImage? {
            let layer = CAGradientLayer()
            layer.frame = frame
        var gradientCgColor: [CGColor] = []
        for data in gradientcolors {
            gradientCgColor.append(data.cgColor)
        }
        layer.colors = gradientCgColor
            UIGraphicsBeginImageContext(CGSize(width: frame.width, height: frame.height))
        layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        return image
    }
}


