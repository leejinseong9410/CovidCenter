//
//  CenterCell.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/28.
//

import UIKit
import SnapKit


class CenterCell: UITableViewCell {
    
    static let identifier = "CenterCell"
    
    // MARK: - Cell - Properties
    private let centers = UILabel()
    
    private let facility = UILabel()
    
    private let address = UILabel()
    
    private let updateAt = UILabel()
    
    private lazy var stackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [centers, facility, address, updateAt])
        v.axis = .vertical
        v.spacing = 10
        v.distribution = .fillEqually
        
        return v
    }()
    
    // MARK: - Cell - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUp StackView
    private func setUpStackView() {
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.right.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(20)
        }
    }
    
    // MARK: - Configure Cell
    public func configureCell(centerList: List) {
        centers.attributedText = configureNSMutableString(category: "센터명",
                                                          appendText: "\t\(centerList.centerName)")
        facility.attributedText = configureNSMutableString(category: "건물명",
                                                           appendText: "\t\(centerList.facilityName)")
        address.attributedText = configureNSMutableString(category: "주소",
                                                          appendText: "\t\t\(centerList.address)")
        updateAt.attributedText = configureNSMutableString(category: "업데이트 시간",
                                                           appendText: "\t\(centerList.updatedAt)")
    }
    
}

    // MARK: - Extension
extension CenterCell {
    private func configureNSMutableString(category: String, appendText: String) -> NSMutableAttributedString {
        let mutableAttrString = NSMutableAttributedString(string: category,
                                                          attributes: [.font: UIFont.boldSystemFont(ofSize: 12),
                                                                       .foregroundColor: UIColor.lightGray])
        let attrString = NSAttributedString(string: appendText,
                                            attributes: [.font: UIFont.systemFont(ofSize: 12),
                                                         .foregroundColor: UIColor.black])
        mutableAttrString.append(attrString)
        
        return mutableAttrString
    }
    
}
