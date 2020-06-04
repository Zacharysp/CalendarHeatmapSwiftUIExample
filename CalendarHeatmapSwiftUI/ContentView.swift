//
//  ContentView.swift
//  CalendarHeatmapSwiftUI
//
//  Created by Dongjie Zhang on 6/2/20.
//  Copyright © 2020 Zachary. All rights reserved.
//

import SwiftUI
import CalendarHeatmap

struct ContentView: View {
    
    @ObservedObject var colorData = ColorData()
    
    var body: some View {
        CalendarHeatmapWrapper(colorData: colorData).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
    
    private func readHeatmap() -> [String: Int]? {
        guard let url = Bundle.main.url(forResource: "heatmap", withExtension: "plist") else { return nil }
        return NSDictionary(contentsOf: url) as? [String: Int]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CalendarHeatmapWrapper: UIViewRepresentable {
    
    @ObservedObject var colorData: ColorData
    
    typealias UIViewType = UIView
    
    let calendarHeatmap: CalendarHeatmap = {
        var config = CalendarHeatmapConfig()
        config.backgroundColor = UIColor(named: "background")!
        // config item
        config.selectedItemBorderColor = .white
        config.allowItemSelection = true
        // config month header
        config.monthHeight = 30
        config.monthStrings = DateFormatter().shortMonthSymbols
        config.monthFont = UIFont.systemFont(ofSize: 18)
        config.monthColor = UIColor(named: "text")!
        // config weekday label on left
        config.weekDayFont = UIFont.systemFont(ofSize: 12)
        config.weekDayWidth = 30
        config.weekDayColor = UIColor(named: "text")!
        
        let calendar = CalendarHeatmap(config: config, startDate: Date(2019, 5, 1), endDate: Date(2020, 3, 23))
        return calendar
    }()
    
    func makeUIView(context: Context) -> UIView {
        calendarHeatmap.delegate = self
        return calendarHeatmap
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

extension CalendarHeatmapWrapper: CalendarHeatmapDelegate {
    
    func colorFor(dateComponents: DateComponents) -> UIColor {
        guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else { return .clear}
        let dateString = "\(year).\(month).\(day)"
        return colorData.data?[dateString] ?? UIColor(named: "color6")!
    }
    
    func finishLoadCalendar() {}
}


extension Date {
    init(_ year:Int, _ month: Int, _ day: Int) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        self.init(timeInterval:0, since: Calendar.current.date(from: dateComponents)!)
    }
}
