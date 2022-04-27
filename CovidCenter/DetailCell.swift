//
//  DetailCell.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/28.
//

import UIKit
import SnapKit

class DetailCell: UICollectionViewCell {
    
    static let identifier = "DetailCollectionViewCell"
    
    // MARK: - Cell - Properties
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 25
        
        return iv
    }()
    
    private let label: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.numberOfLines = 0
        
        return lb
    }()
    
    // MARK: - Cell - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpContentView()
        setUpCellConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowOffset = CGSize(width: 5, height: 5)
        contentView.layer.shadowRadius = 6
    }
    
    // MARK: - SetUp Cell Properties
    private func setUpCellConfigure() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.size.equalTo(50)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.left.right.equalToSuperview()
        }
    }
    
    // MARK: - Configure Cell
    public func configureCell(centerInfo: List, centerInfoType: CenterInfoType) {
        if let _image = UIImage(named: centerInfoType.imageName) {
            
            imageView.image = _image
            let mutableAttrString = NSMutableAttributedString(string: centerInfoType.categoryName,
                                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 12),
                                                                           .foregroundColor: UIColor.black])
            var displayText: String
            
            switch centerInfoType {
            case .centerName:
                displayText = centerInfo.centerName
            case .facilityName:
                displayText = centerInfo.facilityName
            case .phoneNumber:
                displayText = centerInfo.phoneNumber
            case .updatedAt:
                displayText = centerInfo.updatedAt
            case .address:
                displayText = centerInfo.address
            }
            
            let attributedString = NSAttributedString().setUpAttrString(string: displayText)
            mutableAttrString.append(attributedString)
            label.attributedText = mutableAttrString
        }
    }
}
