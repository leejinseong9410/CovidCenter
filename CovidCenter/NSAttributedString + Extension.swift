//
//  NSAttributedString.swift
//  CovidCenter
//
//  Created by Lee jinseong on 2022/03/31.
//

import UIKit

extension NSAttributedString {
    func setUpAttrString(string: String) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        
        return (NSAttributedString(string: string, attributes: attributes))
    }
}
