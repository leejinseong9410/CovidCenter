//
//  MapPostion.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/31.
//

import Foundation

struct MapPosition {
    var user: Position
    var center: Position
    
    init(userPostion: Position, centerPosition: Position) {
        user = userPostion
        center = centerPosition
    }
    
    mutating func setCenterPosition(centerPosition: Position) {
       user = .init()
       center = centerPosition
    }
}
