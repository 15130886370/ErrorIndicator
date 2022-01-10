//
//  TestViewController.swift
//  RxSwift_Test
//
//  Created by 七环第一帅 on 2022/1/10.
//

import Foundation
import UIKit
import RxSwift

class TestViewController: UIViewController {
    
    private let bag = DisposeBag()
    
    private lazy var test1: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("handleError1", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        
        return button
    }()
    
    private lazy var test2: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("handleError2", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton()
        testError()
    }
    
    private func testError() {
        let vm = TestViewModel.init(input: test1.rx.tap.asSignal(), tap2: test2.rx.tap.asSignal())
                
        vm.testValue1.subscribe(onNext: { value in
            print(value)
        }).disposed(by: bag)
        
        vm.testValue2.emit(onNext: { value in
            print("test2.value = \(value)")
        }).disposed(by: bag)
        
        vm.error.drive(onNext: { error in
            if let e = error as? MyError {
                print(e.message)
            }
        }).disposed(by: bag)
    }

    private func addButton() {
        
        let stackView = UIStackView(arrangedSubviews: [test1, test2])
        stackView.axis = .horizontal
        stackView.spacing = 15
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
