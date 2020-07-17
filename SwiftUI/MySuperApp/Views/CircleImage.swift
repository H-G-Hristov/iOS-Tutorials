//
//  CircleImage.swift
//  MySuperApp
//
//  Created by Hristo Hristov on 10.06.20.
//  Copyright © 2020 Hristo Hristov. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("Brushes")
            .clipShape(Circle())
            .overlay(Circle()
                .stroke(Color.white, lineWidth: 5))
            .shadow(radius: 15)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
