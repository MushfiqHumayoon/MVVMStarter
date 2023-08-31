//
//  ApiManager.swift
//  RepoKit
//
//  Created by Mushfiq Humayoon on 04/07/23.
//

import UIKit
import Alamofire

public class `ApiManager` {

    // MARK: - Vars & Lets
    private let sessionManager: Session
    private let reachability: NetworkReachabilityManager
    private static var sharedInstance: ApiManager = {
        let manager = ApiManager(sessionManager: Session(), reachability: NetworkReachabilityManager()!)
        return manager
    }()
    private let queue = DispatchQueue(label: "io.gemstud.service", attributes: .concurrent)
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var dataTask: DataRequest?

    // MARK: - Accessor
    public static func shared() -> ApiManager {
        return sharedInstance
    }

    // MARK: - Initialization
    private init(sessionManager: Session, reachability: NetworkReachabilityManager) {
        self.sessionManager = sessionManager
        self.reachability = reachability
        self.reachability.startListening { status in
            switch status {
            case .notReachable: print("The network is not reachable.")
            case .unknown : print("It is unknown whether the network is reachable.")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection.")
            case .reachable(.cellular):
                print("The network is reachable over the WWAN connection.")
            }
        }
    }

    // MARK: - Api Request
    public func request<T: Decodable>(endPoint: ApiEndPoint, params: Parameters? = nil, cacheOn: Bool = false, handler: @escaping ((T?, Error?) -> Void)) {
        startBackgroundTask()
        let policy: NSURLRequest.CachePolicy = cacheOn ? .returnCacheDataElseLoad : .reloadIgnoringCacheData
        var request = URLRequest(url: endPoint.url, cachePolicy: policy, timeoutInterval: 1440)
        request.httpMethod = endPoint.httpMethod.rawValue
        request.allHTTPHeaderFields = endPoint.headers?.dictionary
        do {
            request = try endPoint.encoding.encode(request, with: params)
        } catch {
            self.endBackgroundTask()
            handler(nil, error)
        }
        dataTask = self.sessionManager.request(request).responseData(queue: queue) { (response) in
            if let error = response.error {
                self.endBackgroundTask()
                handler(nil, error)
                return
            }
            if let data = response.data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    self.endBackgroundTask()
                    handler(result, nil)
                } catch {
                    print("ParseError: \(error.localizedDescription)")
                    self.endBackgroundTask()
                    handler(nil, error)
                }
            }
        }
    }

    // MARK: - Network available or not
    public func isNetworkReachable() -> Bool {
        return reachability.isReachable
    }

    public func reachabilityObserver(reachable: @escaping (_ status: Bool) -> Void) {
        reachability.startListening { status in
            status == .notReachable ? reachable(false) : reachable(true)
        }
    }
}

extension ApiManager {
    // MARK: - Begin and end background task
    fileprivate func startBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }

    fileprivate func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
}
