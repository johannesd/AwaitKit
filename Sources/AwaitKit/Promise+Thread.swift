//
//  Promise+Thread.swift
//  Alamofire
//
//  Created by Johannes Dörr on 22.05.18.
//

import Foundation
import PromiseKit

extension Promise {
    
    /**
     Asynchronously executes the provided closure on a thread.
     
     - Parameter body: The closure that resolves this promise.
     - Returns: A new `Promise` resolved by the result of the provided closure.
     - Note: There is no Promise/Thenable version of this due to Swift compiler ambiguity issues.
     */
    @available(macOS 10.10, iOS 10.0, tvOS 9.0, watchOS 2.0, *)
    public static func async<T>(execute body: @escaping () throws -> T) -> Promise<T> {
        let (promise, resolver) = Promise<T>.pending()
        let thread = Thread {
            do {
                let value = try body()
                resolver.fulfill(value)
            } catch let error {
                resolver.reject(error)
            }
        }
        thread.start()
        return promise
    }
    
}
