//
//  MapViewController.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/28.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation
import RxCocoa
import RxSwift

class MapViewController: UIViewController {
    
    // MARK: - Views
    private var mapView = MKMapView()
    
    private let centerLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("접종센터로", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private let myLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("현재위치로", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [myLocationButton, centerLocationButton])
        v.axis = .vertical
        v.distribution = .fillEqually
        v.spacing = 5
        
        return v
    }()
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    private var centerInfo: List
    private var mapModel: MapPosition = .init(userPostion: .init(),
                                              centerPosition: .init())
    
    // MARK: - CenterInfoData Init
    init(centerInfo: List) {
        self.centerInfo = centerInfo
        self.mapModel.setCenterPosition(centerPosition: .init(centerInfo: centerInfo,
                                                              type: .destination))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpToUI()
        setUpLocationManager()
        bindToButtons()
    }
    
    // MARK: - Setup UI
    private func setUpToUI() {
        navigationItem.title = "지도"
        
        view.addSubview(mapView)
        view.addSubview(stackView)

        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-60)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(100)
        }
    }
    
    // MARK: - Setup LocationManager
    /*
     @ LocationManager 설정하기
     @ desiredAccuracy = 정확도 설정, kCLLocationAccuracyBest: 최고 단위 설정
     @ requestWhenInUseAuthorization = 사용자 위치 데이터 승인 요구
     @ startUpdatingLocation = 업데이트 시작
     @ showsUserLocation = 위치 보기 설정
     */
    private func setUpLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Bind LocationButtons
    private func bindToButtons() {
        myLocationButton
            .rx
            .tap
            .bind(with: self, onNext: { owner, _ in
                owner.setAnnotation(mapType: owner.mapModel.user)
            })
            .disposed(by: disposeBag)
        
        centerLocationButton
            .rx
            .tap
            .bind(with: self, onNext: { owner, _ in
                owner.setAnnotation(mapType: owner.mapModel.center)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup Annotation
    private func setAnnotation(mapType: Position) {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = goLocation(latitudeValue: .init(mapType.latitude),
                                           longtudeValue: .init(mapType.longitude),
                                           delta: 0.1)
        
        switch mapType.type {
        case .current:
            annotation.title = ""
            annotation.subtitle = ""
        case .destination:
            annotation.title = centerInfo.centerName
            annotation.subtitle = centerInfo.address
        }
        
        mapView.addAnnotation(annotation)
    }

    // goLocation: 위도와 경도, 스팬(영역 폭)을 입력받아 지도에 표시
    private func goLocation(latitudeValue: CLLocationDegrees,
                            longtudeValue: CLLocationDegrees,
                            delta span: Double) -> CLLocationCoordinate2D {
        
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        mapView.setRegion(pRegion, animated: true)
        
        return pLocation
    }
    
    // MARK: - Error Handle
    private func locationManagerError(manager: CLLocationManager,
                                      didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription, terminator: "")
    }
}
