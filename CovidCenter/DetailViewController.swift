//
//  DetailViewController.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/28.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit

class DetailViewController: UIViewController {

    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 50,
                                               left: 20,
                                               bottom: 20,
                                               right: 20)
        flowLayout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
        collectionView.register(DetailCell.self,
                                forCellWithReuseIdentifier: DetailCell.identifier)
        collectionView.backgroundColor = .lightGray.withAlphaComponent(0.6)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private var centerInfo: List
    
    // MARK: - CenterInfoData Init
    init(centerInfo: List) {
        self.centerInfo = centerInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpToUI()
        setUpNavigationBar()
        bindToUI()
    }
    
    // MARK: - Setup UI
    private func setUpToUI() {
        view.backgroundColor = .white
        navigationItem.title = centerInfo.centerName
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setUpNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .done,
                                                           target: self,
                                                           action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                                           style: .done,
                                                           target: self,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "지도",
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
    }
    
    // MARK: - Bind UI
    private func bindToUI() {
        navigationItem.leftBarButtonItem?
            .rx
            .tap
            .bind(with: self, onNext: { owner , _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?
            .rx
            .tap
            .bind(with: self, onNext: { owner , _ in
                let mapViewController = MapViewController(centerInfo: owner.centerInfo)
                owner.navigationController?.pushViewController(mapViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}

    // MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CenterInfoType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCell.identifier,
                                                            for: indexPath) as? DetailCell else {
            return UICollectionViewCell()
        }
        
        if let centerInfoType = CenterInfoType(rawValue: indexPath.row) {
            
            cell.configureCell(centerInfo: centerInfo, centerInfoType: centerInfoType)
        }
        
        return cell
    }
    
}

    // MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch CenterInfoType(rawValue: indexPath.item) {
        case .address:
            return CGSize(width: view.frame.width - 40, height: 180)
        default:
            return CGSize(width: view.frame.width / 2.5, height: 180)
        }
    }
    
}
