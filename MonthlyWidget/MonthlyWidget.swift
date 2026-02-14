//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by Vanesa Orcikova on 08/11/2025.
//

import WidgetKit
import SwiftUI

// MARK: - COLOR BRIGHTNESS EXTENSION
extension Color {
    // Toto zistí, či je farba "skôr svetlá" alebo "skôr tmavá".
    // Používame to na to, aby sa text pekne čítal (tmavý text na svetlom pozadí, biely na tmavom).
    func isLight() -> Bool {
        let uiColor = UIColor(self)

        // Tu si vytiahneme R, G, B, A hodnoty z farby (0...1)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)

        // Jednoduchý výpočet "brightness" (ako veľmi je farba svetlá)
        // Tieto koeficienty (0.299/0.587/0.114) sú bežný spôsob ako sa počíta vnímaná svetlosť
        let brightness = sqrt(
            0.299 * r * r +
            0.587 * g * g +
            0.114 * b * b
        )

        // Ak je brightness viac než 0.70, povieme že farba je svetlá
        return brightness > 0.70
    }
}


// MARK: - PROVIDER
// Provider = “mozog” widgetu.
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), color: .gray, emoji: "📅", weekday: "Monday")
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        createEntry(for: Date())
    }
    
    // timeline = tu vytváraš zoznam entries do budúcnosti
    // Ty tu robíš 31 dní dopredu, takže widget má dopredu pripravené hodnoty pre každý deň
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        
        // Vytvoríme entry pre dnes + ďalších 30 dní (spolu 31)
        for offset in 0..<31 {
            if let entryDate = calendar.date(byAdding: .day, value: offset, to: startOfToday) {
                let entry = createEntry(for: entryDate)
                entries.append(entry)
            }
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    private func createEntry(for date: Date) -> SimpleEntry {
        let month = Calendar.current.component(.month, from: date)
        
        // GIRLY DREAMY SEASON PALETTE (rovnaké ako appka)
        let (emojis, colors): ([String], [Color]) = switch month {
            
            // ❄️ WINTER — icy blush aesthetic
        case 12, 1, 2:
            ([
                "❄️","☃️","🩵","🕊️","✨","🪽",
                "🤍","🧸","💎","🧁","🌙","🕯️"
            ],
             [
                Color(red: 0.92, green: 0.95, blue: 1.0),
                Color(red: 0.88, green: 0.90, blue: 0.98),
                Color(red: 0.85, green: 0.88, blue: 0.97),
                Color(red: 0.90, green: 0.93, blue: 1.0),
                Color(red: 0.95, green: 0.96, blue: 1.0)
             ])
            
            // 🌸 SPRING — cherry blossom cloud
        case 3, 4, 5:
            ([
                "🌸","🩷","💐","🦋","🪻","✨",
                "🍓","🐇","💖","🌷","☁️","🤍"
            ],
             [
                Color(red: 1.0, green: 0.92, blue: 0.97),
                Color(red: 1.0, green: 0.88, blue: 0.94),
                Color(red: 0.98, green: 0.88, blue: 0.96),
                Color(red: 0.97, green: 0.90, blue: 0.98),
                Color(red: 0.96, green: 0.93, blue: 0.99)
             ])
            
            // ☀️ SUMMER — strawberry peach aesthetic
        case 6, 7, 8:
            ([
                "🌞","🍓","🍉","🩷","🫶","✨",
                "🌴","🍑","🪸","🦩","🌊","🤍"
            ],
             [
                Color(red: 1.0, green: 0.95, blue: 0.88),
                Color(red: 1.0, green: 0.90, blue: 0.92),
                Color(red: 1.0, green: 0.88, blue: 0.94),
                Color(red: 1.0, green: 0.92, blue: 0.85),
                Color(red: 1.0, green: 0.89, blue: 0.80)
             ])
            
            // 🍁 AUTUMN — caramel vanilla latte
        case 9, 10, 11:
            ([
                "🍂","🎃","🧡","🫶","☕️","✨",
                "🤎","🍁","🧣","🔥","🌰","🫖"
            ],
             [
                Color(red: 1.0, green: 0.90, blue: 0.82),
                Color(red: 1.0, green: 0.85, blue: 0.74),
                Color(red: 0.98, green: 0.78, blue: 0.65),
                Color(red: 0.95, green: 0.82, blue: 0.72),
                Color(red: 0.90, green: 0.75, blue: 0.65)
             ])
            
        default:
            (["✨"], [Color.pink.opacity(0.3)])
        }
        
        let day = Calendar.current.component(.day, from: date)
        var generator = SeededRandomNumberGenerator(seed: UInt64(month * 100 + day))
        let randomEmoji = emojis.randomElement(using: &generator) ?? "💗"
        let randomColor = colors.randomElement(using: &generator) ?? Color.pink.opacity(0.3)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE"
        let weekday = formatter.string(from: date)
        
        return SimpleEntry(
            date: date,
            color: randomColor,
            emoji: randomEmoji,
            weekday: weekday
        )
    }
}
    
// MARK: - RNG
// SeededRandomNumberGenerator = vlastný random generátor, ktorý vie byť “rovnako náhodný” pre rovnaký seed.
// Čiže: rovnaký dátum -> rovnaké emoji + farba. (Stabilné UI)
    struct SeededRandomNumberGenerator: RandomNumberGenerator {
        private var state: UInt64
        init(seed: UInt64) { state = seed == 0 ? 0x4d595df4d0f33173 : seed }
        mutating func next() -> UInt64 {
            state ^= state >> 12
            state ^= state << 25
            state ^= state >> 27
            return state &* 2685821657736338717
        }
    }
    
// MARK: - ENTRY
// SimpleEntry = “balík dát” čo jeden moment v timeline obsahuje.
    struct SimpleEntry: TimelineEntry {
        let date: Date
        let color: Color
        let emoji: String
        let weekday: String
    }
    
// MARK: - CALENDAR GRID
// MonthGridBackground = toto ti kreslí čísla dní do takého mini kalendára na pozadí.
    struct MonthGridBackground: View {
        let date: Date
        let backgroundColor: Color
        
        var body: some View {
            let calendar = Calendar.current
            
            // range = zistí koľko dní má mesiac (28/29/30/31)
            let range = calendar.range(of: .day, in: .month, for: date) ?? 1..<29
            let days = Array(range)
            
            // Zistíme prvý deň mesiaca, aby sme vedeli posun (offset) v mriežke
            let comps = calendar.dateComponents([.year, .month], from: date)
            let firstDay = calendar.date(from: DateComponents(year: comps.year, month: comps.month, day: 1)) ?? date
            
            // weekday = deň v týždni (1..7), podľa toho sa posunie mriežka
            let weekday = calendar.component(.weekday, from: firstDay)
            
            // offset = koľko prázdnych políčok dať pred 1. deň mesiaca
            let offset = (weekday + 5) % 7
            
            // padded = najprv nil (prázdne), potom reálne dni
            let padded = Array(repeating: nil as Int?, count: offset) + days.map { Optional($0) }
            
            let isLight = backgroundColor.isLight()
            let textColor = isLight
            ? Color.black.opacity(0.12)
            : Color.white.opacity(0.19)
            
            GeometryReader { geo in
                // 7 stĺpcov = 7 dní v týždni
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                VStack {
                    Spacer(minLength: 18)
                    
                    LazyVGrid(columns: columns, spacing: 6) {
                        ForEach(Array(padded.enumerated()), id: \.offset) { _, value in
                            if let number = value {
                                Text("\(number)")
                                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                    .foregroundColor(textColor)
                                    .frame(minWidth: 22, maxWidth: .infinity)
                            } else {
                                // prázdne miesto (pred prvým dňom mesiaca)
                                Color.clear.frame(minWidth: 22, maxWidth: .infinity)
                            }
                        }
                    }
                    .frame(height: geo.size.height * 0.80)
                    
                    Spacer(minLength: 6)
                }
            }
        }
    }
    
// MARK: - WIDGET VIEW
// MonthlyWidgetEntryView = UI ktoré sa reálne ukáže používateľovi.
    struct MonthlyWidgetEntryView: View {
        var entry: Provider.Entry
        
        var body: some View {
            ZStack {
                MonthGridBackground(
                    date: entry.date,
                    backgroundColor: entry.color
                )
                
                VStack(spacing: 0) {
                    HStack(spacing: 6) {
                        // emoji z entry (vybrané podľa dátumu)
                        Text(entry.emoji)
                            .font(.system(size: 22))
                        // weekday (Monday, Tuesday...)
                        Text(entry.weekday)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.black.opacity(0.75))
                    }
                    .padding(.top, -6)
                    
                    Spacer()
                    
                    Text(entry.date, format: Date.FormatStyle().day())
                        .font(.system(size: 70, weight: .heavy))
                        .foregroundStyle(.black.opacity(0.75))
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .containerBackground(entry.color, for: .widget)
        }
    }
    
    // MARK: - CONFIG
    struct MonthlyWidget: Widget {
        let kind: String = "MonthlyWidget"
        
        var body: some WidgetConfiguration {
            AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
                MonthlyWidgetEntryView(entry: entry)
            }
        }
    }
    
    // MARK: - PREVIEW
    #Preview(as: .systemSmall) {
        MonthlyWidget()
    } timeline: {
        SimpleEntry(
            date: .now,
            color: Color(.sRGB, red: 0.7, green: 0.8, blue: 0.9),
            emoji: "❄️",
            weekday: "Friday"
        )
    }

//Tento widget si dopredu pripraví entries na 31 dní, aby každý deň mal svoje emoji a farbu podľa sezóny. Potom v MonthlyWidgetEntryView z týchto dát len spraví UI: na pozadí je mini kalendár a vpredu je emoji, názov dňa a veľké číslo dňa. Seedovaný random je tam preto, aby sa emoji/farba pre daný dátum nemenili pri každom refreshi, ale boli stále rovnaké pre ten deň.
