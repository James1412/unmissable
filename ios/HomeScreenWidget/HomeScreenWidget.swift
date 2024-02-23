//
//  HomeScreenWidget.swift
//  HomeScreenWidget
//
//  Created by 이지강 on 2024-02-23.
//

import WidgetKit
import SwiftUI

private let widgetGroupId = "group.unmissable_app_group"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date:.now,title:"Placeholder Title", description: "Placeholder Message")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = UserDefaults.init(suiteName: widgetGroupId)
        
        let entry = SimpleEntry(date: .now, title: data?.string(forKey:"title") ?? "No Title Set", description: data?.string(forKey: "description") ?? "No Message Set")
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context){(entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    
    let title: String
    let description: String
}

struct HomeScreenWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.title)
            Text(entry.description)
        }
    }
}

struct HomeScreenWidget: Widget {
    let kind: String = "HomeScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HomeScreenWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HomeScreenWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    HomeScreenWidget()
} timeline: {
    SimpleEntry(date: .now, title: "Example Title", description: "Example Message")
    SimpleEntry(date: .now, title: "Example Title", description: "Example description")
}
