//
//  MonthlyWidgetControl.swift
//  MonthlyWidget
//
//  Created by Vanesa Orcikova on 08/11/2025.
//

import AppIntents
import SwiftUI
import WidgetKit

// ControlWidget = typ widgetu, ktorý vie mať priamo ovládací prvok (napr. toggle / button)
struct MonthlyWidgetControl: ControlWidget {
    // kind = unikátny identifikátor widgetu (ako ID)
    // väčšinou sa dáva BundleID + názov
    static let kind: String = "VanesaOrcikova.Montly.MonthlyWidget"

    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: Self.kind,
            provider: Provider()
        ) { value in
        // AppIntentControlConfiguration = tu povieš:
            // 1) aký widget to je (kind)
            // 2) odkiaľ berie hodnoty (provider)
            // 3) ako sa vykreslí UI podľa aktuálneho stavu (closure { value in ... })
            
            ControlWidgetToggle(
                "Start Timer",
                isOn: value.isRunning,
                action: StartTimerIntent(value.name)
            ) { isRunning in
                Label(isRunning ? "On" : "Off", systemImage: "timer")
            }
        }
        .displayName("Timer")
        .description("A an example control that runs a timer.")
    }
}

extension MonthlyWidgetControl {
    struct Value {
        var isRunning: Bool
        var name: String
    }

    struct Provider: AppIntentControlValueProvider {
        func previewValue(configuration: TimerConfiguration) -> Value {
            MonthlyWidgetControl.Value(isRunning: false, name: configuration.timerName)
        }

        func currentValue(configuration: TimerConfiguration) async throws -> Value {
            let isRunning = true // Check if the timer is running
            return MonthlyWidgetControl.Value(isRunning: isRunning, name: configuration.timerName)
        }
    }
}

// Value = to je dátový model pre widget, čo provider vracia; obsahuje všetko čo UI potrebuje vedieť
// Provider = trieda ktorá dodáva hodnoty pre widget; teda hovorí widgetu, čo má momentálne zobrazovať

struct TimerConfiguration: ControlConfigurationIntent {
    static let title: LocalizedStringResource = "Timer Name Configuration"

    @Parameter(title: "Timer Name", default: "Timer")
    var timerName: String
}

struct StartTimerIntent: SetValueIntent {
    static let title: LocalizedStringResource = "Start a timer"

    @Parameter(title: "Timer Name")
    var name: String

    @Parameter(title: "Timer is running")
    var value: Bool

    init() {}

    init(_ name: String) {
        self.name = name
    }

    func perform() async throws -> some IntentResult {
        // Start the timer…
        return .result()
    }
}

//Toto je ovládací widget s toggle prepínačom, ktorý vie zapnúť alebo vypnúť timer.
//Provider dodáva widgetu aktuálny stav (či timer beží) a podľa toho sa toggle zobrazuje ako ON/OFF.
//Keď používateľ prepne toggle, spustí sa StartTimerIntent, a to je miesto, kde reálne spravíš logiku (spustiť timer / zastaviť timer).
//TimerConfiguration je to, čo si user vie nastaviť – napríklad názov timeru.
