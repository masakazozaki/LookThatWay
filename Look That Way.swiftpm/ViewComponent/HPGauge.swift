//
//  HPGauge.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2/16/24.
//

import SwiftUI

struct HPGauge: View {
    var hp: Int
    var body: some View {
        HStack {
            ForEach(0..<hp, id: \.self) { _ in
                Image(systemName: "heart.fill")
                    .foregroundStyle(.pink)
                    .symbolEffect(.bounce, value: hp)
            }
        }
    }
}
