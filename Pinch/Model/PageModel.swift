//
//  PageModel.swift
//  Pinch
//
//  Created by Pham Nguyen Phu on 22/03/2023.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
    
}

extension Page {
    var thumbnailsName: String {
        return "thumb-" + imageName
    }
}
