//
//  CenterVM.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/28.
//

import RxSwift
import UIKit
import RxCocoa


class ListViewModel {
    
    // MARK: - Properties
    
    var input = Input()
    
    var output = Output()
    
    var dependency = Dependency()
    
    private let disposeBag = DisposeBag()
    
    private var savedList: [List] = [] {
        didSet {
            savedList.sort(by: { $0.updatedAt < $1.updatedAt })
            output.centerList.accept(savedList)
        }
    }
    
    // MARK: - Initializer
    init(dependency: Dependency) {
        self.dependency = dependency
        fetchCenterViewModels()
    }
    
    // MARK: - FetchService Function
    private func fetchCenterViewModels() {
        input.requestPage
            .subscribe(with: self, onNext: { owner, _page in
                owner.fetchRequestBind(page: _page)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchRequestBind(page: Int) {
        dependency
            .service
            .fetchCovidCenter(page)
            .map { $0.map { List(center: $0) } }
            .subscribe(with: self, onNext: { owner, list in
                owner.savedList.append(contentsOf: list)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Refresh Function
    func refreshCenterList() {
        savedList.removeAll()
        fetchCenterViewModels()
    }
}

extension ListViewModel {
    // 주입받은 값
    struct Input {
        let requestPage = BehaviorRelay<Int>(value: 0)
    }
    
    // 주입한 값을 가공해서 내보내는 값
    struct Output {
        let centerList = BehaviorRelay<[List]>(value: []) //vc 연결
    }
    
    // 의존성
    struct Dependency {
        let service = FetchCenterService()
    }
    
    // VC 와 VM 의 연결고리
    struct Bothways {
        
    }
}
