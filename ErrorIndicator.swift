//
//  ErrorTest.swift
//  RxSwift_Test
//
//  Created by 七环第一帅 on 2021/12/20.
//

import Foundation
import RxSwift
import RxCocoa

public class ErrorIndicator: SharedSequenceConvertibleType {
    
    public typealias Element = Swift.Error?
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _relay = PublishRelay<Element>()
    private let _error: SharedSequence<SharingStrategy, Element>
    
    public init() {
        _error = _relay.asDriver(onErrorJustReturn: nil)
    }
        
    fileprivate func trackErrorOfObservable<Source: ObservableConvertibleType>(_ source: Source, justReture element: Source.Element?) -> Observable<Source.Element> {
        return source.asObservable().catch { error in
            self._lock.lock()
            self._relay.accept(error)
            self._lock.unlock()
            if let e = element {
                return Observable<Source.Element>.just(e)
            } else {
                return Observable<Source.Element>.empty()
            }
        }
    }
    
    public func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Element> {
        return _error
    }
}

extension ObservableConvertibleType {
    
    public func trackError(_ errorIndicator: ErrorIndicator, justReturn element: Element? = nil)
        -> Observable<Element> {
            return errorIndicator.trackErrorOfObservable(self, justReture: element)
    }
}
