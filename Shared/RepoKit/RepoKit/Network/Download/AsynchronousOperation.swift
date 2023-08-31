//
//  AsynchronousOperation.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

import Foundation
public class AsynchronousOperation: Operation {

    @objc private enum OperationState: Int {
        case ready
        case executing
        case finished
    }
    private let stateQueue = DispatchQueue(label: "io.gemstud.asyncoperation", attributes: .concurrent)

    private var rawState: OperationState = .ready

    @objc private dynamic var state: OperationState {
        get { return stateQueue.sync { rawState } }
        set { stateQueue.sync(flags: .barrier) { rawState = newValue } }
    }

    open override var isReady: Bool {
        return state == .ready && super.isReady
    }

    public final override var isExecuting: Bool {
        return state == .executing
    }

    public final override var isFinished: Bool {
        return state == .finished
    }

    public final override var isAsynchronous: Bool {
        return true
    }

    open override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if ["isReady", "isFinished", "isExecuting"].contains(key) {
            return [#keyPath(state)]
        }
        return super.keyPathsForValuesAffectingValue(forKey: key)
    }

    public final override func start() {
        if isCancelled {
            state = .finished
            return
        }
        state = .executing
        main()
    }

    open override func main() {
        fatalError("Async Error: Subclasses must implement main method.")
    }

    public final func finish() {
        if isExecuting { state = .finished }
    }
}
