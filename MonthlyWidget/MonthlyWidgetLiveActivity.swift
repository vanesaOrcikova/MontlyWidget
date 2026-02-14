//
//  MonthlyWidgetLiveActivity.swift
//  MonthlyWidget
//
//  Created by Vanesa Orcikova on 08/11/2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

// ActivityAttributes = definícia "modelu" Live Activity
// Sem patrí všetko čo potrebuje Live Activity vedieť.
struct MonthlyWidgetAttributes: ActivityAttributes {
    // ContentState = dynamické údaje, ktoré sa môžu meniť počas behu Live Activity; (napr. emoji, čas,stav objednávky ...)
    public struct ContentState: Codable, Hashable {
        var emoji: String
    }

    // Toto sú "fixné" údaje - nemenia sa počas behu aktivity
    var name: String
}

// Widget = komponent, ktorý zobrazuje Live Activity na lockscreen a Dynamic Islande
struct MonthlyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MonthlyWidgetAttributes.self) { context in
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MonthlyWidgetAttributes {
    fileprivate static var preview: MonthlyWidgetAttributes {
        MonthlyWidgetAttributes(name: "World")
    }
}

extension MonthlyWidgetAttributes.ContentState {
    fileprivate static var smiley: MonthlyWidgetAttributes.ContentState {
        MonthlyWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MonthlyWidgetAttributes.ContentState {
         MonthlyWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MonthlyWidgetAttributes.preview) {
   MonthlyWidgetLiveActivity()
} contentStates: {
    MonthlyWidgetAttributes.ContentState.smiley
    MonthlyWidgetAttributes.ContentState.starEyes
}

//Tento kód je Live Activity widget, ktorý sa zobrazuje na lockscreen a aj v Dynamic Islande.
//MonthlyWidgetAttributes obsahuje údaje, ktoré widget potrebuje. Fixné údaje sú napríklad name, a dynamické sú v ContentState, napríklad emoji.
//ActivityConfiguration určuje ako bude vyzerať widget na lockscreen a dynamicIsland určuje ako bude vyzerať v Dynamic Islande v rôznych režimoch (expanded, compact, minimal).
//Preview na konci slúži len na testovanie v Xcode, aby si nemusela stále spúšťať aplikáciu.
