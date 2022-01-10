//
//  TestViewModel.swift
//  RxSwift_Test
//
//  Created by 七环第一帅 on 2021/6/21.
//

import Foundation
import RxSwift
import RxCocoa

enum MyError: Error {
    case test
    case test2
    case test1
    
    var message: String {
        switch self {
        case.test:
            return "❌❌❌"
        case .test2:
            return "❌❌❌❌❌❌"
        case .test1:
            return "❌❌❌❌"
        }
    }
}

class TestViewModel {
    
    let testValue: Signal<Int>
    let testValue1: Observable<String>
    let testValue2: Signal<Int>
    let error: Driver<Error>
    
    init(input tap: Signal<()>, tap2: Signal<()>) {
        
        let errorTracker = ErrorIndicator()
        
        error = errorTracker.compactMap { $0 }.asDriver()
        
        testValue = tap.flatMapLatest { _ -> SharedSequence<SignalSharingStrategy, Int> in
            return Observable<Int?>.create { observer in

                print("网络请求1")
                observer.onNext(1)
                
                delay(1) {
                    observer.onError(MyError.test)
                }

                return Disposables.create()
            }.trackError(errorTracker)
            .asSignal(onErrorJustReturn: nil)
            .compactMap { $0 }
        }
        
        testValue1 = testValue.asObservable()
            .flatMapLatest({ value in
                return Observable<String>.create { observer in
                    observer.onNext("value = \(value)")
                    
                    delay(1) {
                        observer.onError(MyError.test1)
                    }
                    
                    return Disposables.create()
                }
                .trackError(errorTracker, justReturn: "遇到error，空了")
            })
        
        testValue2 = tap2.flatMapLatest { _ -> SharedSequence<SignalSharingStrategy, Int> in
            return Observable<Int?>.create { observer in

                print("网络请求2")
                observer.onNext(1)

                delay(1) {
                    observer.onError(MyError.test2)
                }
                return Disposables.create()
            }
            .trackError(errorTracker)
            .asSignal(onErrorJustReturn: nil)
            .compactMap { $0 }
        }
        
    }
}
