//
//  DependencyManager.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

open class DependencyManager {

    fileprivate var factories = [String: Any]()

    // MARK: - Init
    public init() {}

    fileprivate func key<T>(_ type: T.Type) -> String {
        return String(reflecting: type)
    }

    public func register<T>(_ type: T.Type, module: T) {
        factories[key(type)] = module
    }

    public func resolve<T>(_ type: T.Type) -> T? {
        guard let factory = factories[key(type)] as? T else {
            return nil
        }
        return factory
    }

    public func unregister<T>(_ type: T.Type) {
        factories[key(type)] = nil
    }
}
