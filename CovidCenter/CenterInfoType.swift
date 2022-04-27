//
//  CenterInfoType.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/31.
//

import Foundation

// MARK: - Enum
enum CenterInfoType: Int, CaseIterable {
    case centerName
    case facilityName
    case phoneNumber
    case updatedAt
    case address
}

//MARK: - Extension Enum(CenterInfoType)
extension CenterInfoType {
    var imageName: String {
        switch self {
        case .centerName:
            return "hospital"
        case .facilityName:
            return "building"
        case .phoneNumber:
            return "telephone"
        case .updatedAt:
            return "chat"
        case .address:
            return "placeholder"
        }
    }
    
    var categoryName: String {
        switch self {
        case .centerName:
            return "센터명\n"
        case .facilityName:
            return "건물명\n"
        case .phoneNumber:
            return "전화번호\n"
        case .updatedAt:
            return "업데이트 시간\n"
        case .address:
            return "주소\n"
        }
    }
}
