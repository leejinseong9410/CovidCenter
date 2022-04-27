//
//  Center.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/28.
//

import Foundation

struct Covid: Decodable {
    let page: Int?
    let perPage: Int?
    let totalCount: Int?
    let currentCount: Int?
    let data: [Center]?
}



