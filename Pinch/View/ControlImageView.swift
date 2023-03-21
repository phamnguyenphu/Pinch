//
//  ControlImageView.swift
//  Pinch
//
//  Created by Pham Nguyen Phu on 21/03/2023.
//

import SwiftUI

struct ControlImageView: View {
    let icon: String
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 36))
    }
}

struct ControlImageView_Previews: PreviewProvider {
    static var previews: some View {
        ControlImageView(icon: "minus.magnifyingglass")
    }
}
