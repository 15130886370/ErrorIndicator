# ErrorIndicator
使用 RxSwift 优雅的处理网络错误

# 用法
``` 
// viewModel
let errorTracker = ErrorIndicator()
error = errorTracker.compactMap { $0 }.asDriver()

info = tap.flatMapLatest { _ -> SharedSequence<SignalSharingStrategy, Int> in
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
        
// viewController
vm.error.drive(onNext: { error in
    if let e = error as? MyError {
        // 展示错误
    }
}).disposed(by: bag)

```
