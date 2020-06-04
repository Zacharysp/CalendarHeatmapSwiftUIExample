//
//  ColorData.swift
//  CalendarHeatmapSwiftUI
//
//  Created by Dongjie Zhang on 6/3/20.
//  Copyright © 2020 Zachary. All rights reserved.
//

import SwiftUI

final class ColorData: ObservableObject {
    @Published var data: [String: UIColor]? = nil
    
    init() {
        guard let fileData = readHeatmap() else { return }
        data = fileData.mapValues { (colorIndex) -> UIColor in
            switch colorIndex {
            case 0:
                return UIColor(named: "color1")!
            case 1:
                return UIColor(named: "color2")!
            case 2:
                return UIColor(named: "color3")!
            case 3:
                return UIColor(named: "color4")!
            default:
                return UIColor(named: "color5")!
            }
        }
    }
    
    private func readHeatmap() -> [String: Int]? {
        guard let url = Bundle.main.url(forResource: "heatmap", withExtension: "plist") else { return nil }
        return NSDictionary(contentsOf: url) as? [String: Int]
    }
}
