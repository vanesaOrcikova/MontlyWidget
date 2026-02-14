//
//  MonthlyWidgetBundle.swift
//  MonthlyWidget
//
//  Created by Vanesa Orcikova on 08/11/2025.
//

import WidgetKit
import SwiftUI

@main
struct MonthlyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MonthlyWidget()
        MonthlyWidgetControl()
        MonthlyWidgetLiveActivity()
    }
}
