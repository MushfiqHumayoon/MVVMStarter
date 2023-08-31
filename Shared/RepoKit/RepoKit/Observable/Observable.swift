//
//  Observable.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 31/08/23.
//

import Foundation
public class Observable<T>: NSObject {

    // MARK: - Vars & Lets
    public var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }
    private var valueChanged: ((T) -> Void)?

    // MARK: - Initialization
    public init(value: T) {
        self.value = value
    }

    // MARK: - Add closure as an observer
    public func addObserver(fireNow: Bool = true, _ onChange: ((T) -> Void)?) {
        valueChanged = onChange
        if fireNow {
            onChange?(value)
        }
    }

    // MARK: - Remove observer
    public func removeObserver() {
        valueChanged = nil
    }
}
