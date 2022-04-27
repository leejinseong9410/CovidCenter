//
//  Map.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/31.
//

import Foundation

struct Position {
    let latitude: Float
    let longitude: Float
    let type: MapType
    
    init() {
        self.latitude = 37.543286
        self.longitude = 126.727715
        self.type = .current
    }
    
    init(centerInfo: List, type: MapType) {
        self.latitude = Float(centerInfo.lat) ?? 0.0
        self.longitude = Float(centerInfo.lng) ?? 0.0
        self.type = type
    }
}
