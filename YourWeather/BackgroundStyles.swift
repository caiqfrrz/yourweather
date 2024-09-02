//
//  BackgroundStyles.swift
//  YourWeather
//
//  Created by Caique Ferraz on 02/09/24.
//

import Foundation
import SwiftUI

extension LinearGradient {
    static func sunny() -> LinearGradient {
        LinearGradient(stops: [.init(color: Color(red: 0.7, green: 0.6, blue: 0), location: 0),
                                      .init(color: Color(red: 0.1, green: 0.5, blue: 0.9), location: 0.5)], startPoint: .top, endPoint: .bottom)
    }
    static func clearNight() -> LinearGradient {
        LinearGradient(stops: [.init(color: Color(red: 0, green: 0, blue: 0.4), location: 0.1),
                                      .init(color: Color(red: 0.3, green: 0.3, blue: 0.3), location: 1)], startPoint: .top, endPoint: .bottom)
    }
    static func cloudy() -> LinearGradient {
        LinearGradient(stops: [.init(color: Color(red: 0.2, green: 0.2, blue: 0.2), location: 0.1),
                                      .init(color: Color(red: 0.1, green: 0.1, blue: 0.3), location: 1)], startPoint: .top, endPoint: .bottom)
    }
}
