//
//  ListModel.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/30.
//

import Foundation

struct List {
    let centerName: String
    let facilityName: String
    let phoneNumber: String
    let lat: String
    let lng: String
    let updatedAt: String
    let address: String
    
    init(center: Center) {
        self.centerName = center.centerName ?? "정보없음"
        self.facilityName = center.facilityName ?? "정보없음"
        self.phoneNumber = center.phoneNumber ?? "정보없음"
        self.lat = center.lat ?? "정보없음"
        self.lng = center.lng ?? "정보없음"
        self.updatedAt = center.updatedAt ?? "정보없음"
        self.address = center.address ?? "정보없음"
    }
}
