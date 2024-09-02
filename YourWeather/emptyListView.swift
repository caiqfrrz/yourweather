//
//  emptyListView.swift
//  YourWeather
//
//  Created by Caique Ferraz on 02/09/24.
//

import Foundation
import SwiftUI

struct emptyListView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "location.magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 70)
                .padding()
            
            Text("Add locations to your list!")
            
            Spacer()
            Spacer()
        }
        .foregroundStyle(.secondary)
    }
}
