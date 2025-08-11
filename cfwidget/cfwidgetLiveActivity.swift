//
//  cfwidgetLiveActivity.swift
//  cfwidget
//
//  Created by Jack Howard on 8/10/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct cfwidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct cfwidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: cfwidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
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

extension cfwidgetAttributes {
    fileprivate static var preview: cfwidgetAttributes {
        cfwidgetAttributes(name: "World")
    }
}

extension cfwidgetAttributes.ContentState {
    fileprivate static var smiley: cfwidgetAttributes.ContentState {
        cfwidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: cfwidgetAttributes.ContentState {
         cfwidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: cfwidgetAttributes.preview) {
   cfwidgetLiveActivity()
} contentStates: {
    cfwidgetAttributes.ContentState.smiley
    cfwidgetAttributes.ContentState.starEyes
}
