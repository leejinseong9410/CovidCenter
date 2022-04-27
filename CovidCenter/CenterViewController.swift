//
//  ViewController.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/28.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CenterViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(CenterCell.self, forCellReuseIdentifier: CenterCell.identifier)
        tv.estimatedRowHeight = 44
        tv.refreshControl = refreshControl
        tv.rx.setDelegate(self).disposed(by: disposeBag)
        
        return tv
    }()
    
    private let scrollToTopButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "top-alignment"), for: .normal)
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 1.0
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 6
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        return refreshControl
    }()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = ListViewModel(dependency: .init())
    
    private var pagination = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setUpToUI()
        bindToUI()
    }
    
    //MARK: - Input FetchData
    private func fetchData() {
        viewModel.input.requestPage.accept(pagination)
    }
    
    // MARK: - Setup UI
    private func setUpToUI() {
        navigationItem.title = "예방접종센터 리스트"
        
        view.addSubview(tableView)
        view.addSubview(scrollToTopButton)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollToTopButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-100)
            $0.right.equalToSuperview().offset(-20)
            $0.height.width.equalTo(50)
        }
    }
    
    // MARK: - Bind UI
    private func bindToUI() {
        viewModel.output.centerList
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(cellIdentifier: CenterCell.identifier,
                                         cellType: CenterCell.self)) { _, centerList, cell in
                cell.configureCell(centerList: centerList)
            }
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(List.self)
            .bind(with: self, onNext: { owner , centerInfo in
                let detail = DetailViewController(centerInfo: centerInfo)
                owner.navigationController?.pushViewController(detail, animated: false)
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .didScroll
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner , _ in
                let tableViewOffset = owner.tableView.contentOffset.y
                let tableViewContentHeight = owner.tableView.contentSize.height
                if tableViewOffset > (tableViewContentHeight - owner.tableView.frame.size.height - 100) {
                    owner.pagination += 1
                    // input 인자값 길어지면 struct 로 만들어서 보내기.
                    owner.viewModel.input.requestPage.accept(owner.pagination)
                }
            })
            .disposed(by: disposeBag)
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .debounce(.seconds(2), scheduler: MainScheduler.asyncInstance)
            .bind(with: self, onNext: { owner, _ in
                owner.pagination = 0
                owner.viewModel.refreshCenterList()
                owner.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        scrollToTopButton
            .rx
            .tap
            .bind(with: self, onNext: { owner, _ in
                owner.tableViewToTopHandle()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Handle ScrollToTopButton
    private func tableViewToTopHandle() {
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}

    // MARK: - Extension
extension CenterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

