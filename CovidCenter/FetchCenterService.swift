//
//  FetchCenterService.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/28.
//

import RxSwift

protocol CenterServiceProtocol {
    func fetchCovidCenter(_ page: Int) -> Observable<[Center]>
}

class FetchCenterService: CenterServiceProtocol {
    // MARK: - Properties
    private let header = "https://api.odcloud.kr/api/15077586/v1/centers?page="
    
    private let tail = "&perPage=8&serviceKey=\(PrefixManager.covidKey)"
    
    // MARK: - FetchData Function
    public func fetchCovidCenter(_ page: Int) -> Observable<[Center]> {
        return Observable.create { [weak self] observer -> Disposable in
            if let _self = self,
               let sendURL = URL(string: _self.header + "\(page)" + _self.tail) {
                let task = URLSession.shared.dataTask(with: sendURL) { data, _, _ in
                    guard let _data = data else {
                        observer.onError(ApiError.dataIsEmpty)
                        return
                    }
                    do {
                        let covid = try JSONDecoder().decode(Covid.self, from: _data)
                        guard let covidData = covid.data else { return }
                        observer.onNext(covidData)
                    } catch {
                        observer.onError(ApiError.parsingFail)
                    }
                }
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
            return Disposables.create()
        }
    }
    
}

    // MARK: - Error
enum ApiError: Error {
    case dataIsEmpty
    case parsingFail
}
