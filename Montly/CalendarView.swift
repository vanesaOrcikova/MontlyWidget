//
//  CalendarView.swift
//  Montly
//
//  Created by Vanesa Orcikova on 25/11/2025.
//

import SwiftUI
import Combine

// CalendarView = hlavná obrazovka kalendára.
// Ukazuje mesiac, dni, daily content (motivácia/challenge/reflection),
// umožňuje označiť dni ako splnené a ukladať zamyslenia.
struct CalendarView: View {

    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Date()  // selectedDate = deň, na ktorý používateľ klikol (zobrazuje sa jeho obsah)

    @State private var completedDays: Set<String> = [] // completedDays = zoznam dní, ktoré si používateľ označil ako splnené (uložené ako "yyyy-MM-dd")
    @State private var reflectionNotes: [String: String] = [:] // reflectionNotes = slovník poznámok k zamysleniam (key = dátum, value = text)

    @State private var showReflectionEditor = false // showReflectionEditor = otvorí/zavrie sheet editor pre reflection

    @State private var midnightTick: Int = 0 // midnightTick = pomocná premenná na refresh po polnoci (keď sa zmení deň, view sa prekreslí)
    private let midnightTimer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            backgroundColorForMonth(currentMonth)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.45), value: monthKey(currentMonth))
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    headerView() // horná časť: šípky + názov mesiaca + emoji
                    weekDaysView() // názvy dní v týždni (Mon - Sun)
                    calendarGrid() // grid s číslami dní (kalendár)
                    dailyContentCard() // karta s obsahom pre selectedDate (motivácia/challenge/reflection)
                    streakCard() // karta s streak (koľko dní po sebe bolo splnených v mesiaci)
                }
            }
            .padding(.bottom, 10)
        }
        .onAppear {
            loadCompleted() // načítanie splnených dní z UserDefaults
            loadNotes()
            midnightTick = Calendar.current.component(.day, from: Date())
        }
        .onReceive(midnightTimer) { _ in
            // každých 30 sekúnd kontrolujeme, či sa zmenil deň
            // keď sa zmení, midnightTick sa zmení a SwiftUI refreshne view
            midnightTick = Calendar.current.component(.day, from: Date())
        }
        .sheet(isPresented: $showReflectionEditor) {
            ReflectionEditorView(
                dateKey: dateKey(selectedDate),
                question: DailyContentStore.item(for: selectedDate).text,
                notes: $reflectionNotes
            )
        }
    }

    // MARK: - Header

    private func headerView() -> some View {
        HStack {
            // tlačidlo na predchádzajúci mesiac
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.pink)
            }

            Spacer()
            
            // emoji + názov mesiaca + rok
            HStack(spacing: 10) {
                Text(seasonalMonthEmoji(currentMonth))
                    .font(.system(size: 30))
                    .offset(y: -10)

                VStack(spacing: 2) {
                    Text(monthString(currentMonth))
                        .font(.title)
                        .fontWeight(.bold)

                    Text(yearString(currentMonth))
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }

            Spacer()
            // tlačidlo na ďalší mesiac
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.pink)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    // weekDaysView = riadok s názvami dní v týždni
    private func weekDaysView() -> some View {
        HStack {
            ForEach(["Mon","Tue","Wed","Thu","Fri","Sat","Sun"], id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Grid
    // calendarGrid = vytvorí kalendárnu mriežku pre aktuálny mesiac
    private func calendarGrid() -> some View {
        let values = monthGridValues(currentMonth)
        let rows = values.count / 7

        // výška jednej bunky + spacing
        let cellSize: CGFloat = 50
        let spacing: CGFloat = 12

        // vždy držíme miesto pre 6 riadkov (aj keď mesiac má 5)
        let gridHeight = (cellSize * 6) + (spacing * 5)

        return LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: 7),
            spacing: spacing
        ) {
            ForEach(values.indices, id: \.self) { index in
                let value = values[index]

                if value == 0 {
                    Color.clear
                        .frame(width: cellSize, height: cellSize)
                } else {
                    let date = makeDate(day: value, monthDate: currentMonth)
                    let key = dateKey(date)

                    dayCell(
                        text: "\(value)",
                        isSelected: isSameDay(date, selectedDate),
                        isCompleted: completedDays.contains(key)
                    ) {
                        selectedDate = date
                    }
                }
            }
        }
        .frame(height: gridHeight)
        .padding(.horizontal)
    }

    // MARK: - Daily card (LOCK future + BUTTON for reflection)
    // dailyContentCard = karta s obsahom pre vybraný deň
    private func dailyContentCard() -> some View {
        if isDateInFuture(selectedDate) {
            return AnyView(
                VStack(alignment: .leading, spacing: 10) {
                    Text("🔒 Odomkne sa o polnoci")
                        .font(.system(size: 16, weight: .bold))

                    Text("Obsah pre tento deň sa zobrazí až keď začne nový deň.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.85)))
                .padding(.horizontal)
            )
        }

        let item = DailyContentStore.item(for: selectedDate) // item = motivácia/challenge/reflection podľa selectedDate
        let key = dateKey(selectedDate)
        let isDone = completedDays.contains(key) // isDone = či je deň splnený

        return AnyView(
            VStack(alignment: .leading, spacing: 12) {

                HStack {
                    Text(item.title)
                        .font(.system(size: 16, weight: .bold))

                    Spacer()

                    Text(isDone ? "✅ splnené" : "⏳ neoznačené")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(isDone ? .green : .gray)
                }
                
                // text obsahu (motivácia/challenge/reflection otázka)
                Text(item.text)
                    .font(.system(size: 15))
                    .foregroundColor(.black)

                // namiesto rámiku: BUTTON -> otvorí bielu stránku
                if item.type == .reflection {
                    Button {
                        showReflectionEditor = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.pencil")
                            Text("Otvoriť zamyslenie")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(.pink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.95))
                        )
                    }
                    .buttonStyle(.plain)
                }
                
                // Button na označenie alebo odznačenie splneného dňa
                Button {
                    toggleCompleted(for: selectedDate)
                } label: {
                    Text(isDone ? "Odznačiť" : "Označiť ako splnené")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isDone ? Color.gray.opacity(0.7) : Color.pink)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.85)))
            .padding(.horizontal)
        )
    }

    // MARK: - Streak
    // streakCard = karta ktorá ukazuje najdlhší streak (po sebe splnené dni) v aktuálnom mesiaci
    private func streakCard() -> some View {
        let streak = currentMonthStreak()

        return HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Streak v mesiaci")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray)

                Text("\(streak) dní 🔥")
                    .font(.system(size: 18, weight: .bold))
            }

            Spacer()

            Text(streak == 0 ? "Začni dnes ✨" : "Ideš skvelo 💗")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.pink)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.white.opacity(0.75)))
        .padding(.horizontal)
    }

    // MARK: - Day cell
    // dayCell = jedno políčko v kalendári (button s číslom dňa)
    // zelená bodka = splnené
    // ružový rámik = selectedDate
    private func dayCell(text: String, isSelected: Bool, isCompleted: Bool, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            Text(text)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(width: 50, height: 50)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.95)))
                .overlay(
                    Circle()
                        .fill(isCompleted ? Color.green : Color.clear)
                        .frame(width: 8, height: 8)
                        .offset(y: 18)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.pink : Color.clear, lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Completed persistence

    private func toggleCompleted(for date: Date) {
        let key = dateKey(date)
        if completedDays.contains(key) { completedDays.remove(key) }
        else { completedDays.insert(key) }
        UserDefaults.standard.set(Array(completedDays), forKey: "completed_days")
    }

    private func loadCompleted() {
        let array = UserDefaults.standard.stringArray(forKey: "completed_days") ?? []
        completedDays = Set(array)
    }

    // MARK: - Notes persistence (načítanie pre editor)

    private func loadNotes() {
        guard let data = UserDefaults.standard.data(forKey: "reflection_notes"),
              let obj = try? JSONSerialization.jsonObject(with: data, options: []),
              let dict = obj as? [String: String] else { return }
        reflectionNotes = dict
    }

    // MARK: - Future lock

    private func isDateInFuture(_ date: Date) -> Bool {
        let cal = Calendar.current
        return cal.startOfDay(for: date) > cal.startOfDay(for: Date())
    }

    // MARK: - Streak logic (max streak v mesiaci)
    // currentMonthStreak = prejde všetky dni mesiaca a zistí najdlhší streak splnených dní za sebou
    private func currentMonthStreak() -> Int {
        let days = daysInMonthCount(currentMonth)
        var current = 0
        var maxStreak = 0

        for day in 1...days {
            let date = makeDate(day: day, monthDate: currentMonth)
            if completedDays.contains(dateKey(date)) {
                current += 1
                maxStreak = max(maxStreak, current)
            } else {
                current = 0
            }
        }
        return maxStreak
    }

    // MARK: - Date helpers

    private func dateKey(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    private func monthString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMM"
        return f.string(from: date)
    }
    // yearString = vráti rok ako text (napr. 2026)
    private func yearString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy"
        return f.string(from: date)
    }

    // daysInMonthCount = počet dní v mesiaci (28/29/30/31)
    private func daysInMonthCount(_ date: Date) -> Int {
        Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }

    private func makeDate(day: Int, monthDate: Date) -> Date {
        Calendar.current.date(from: DateComponents(
            year: Calendar.current.component(.year, from: monthDate),
            month: Calendar.current.component(.month, from: monthDate),
            day: day
        )) ?? Date()
    }
    
    // firstWeekdayOffset = vypočíta koľko prázdnych políčok má byť pred 1. dňom mesiaca
    // cal.firstWeekday = 2 znamená že týždeň začína pondelkom
    private func firstWeekdayOffset(_ date: Date) -> Int {
        var cal = Calendar.current
        cal.firstWeekday = 2
        let first = cal.date(from: cal.dateComponents([.year, .month], from: date))!
        return (cal.component(.weekday, from: first) - 2 + 7) % 7
    }
    
    // monthGridValues = vráti pole čísel dní + 0 pre prázdne miesta v grid layout-e
    private func monthGridValues(_ date: Date) -> [Int] {
        let offset = firstWeekdayOffset(date)
        let days = daysInMonthCount(date)

        var result = Array(repeating: 0, count: offset)
        result += Array(1...days)

        while result.count % 7 != 0 { result.append(0) }
        return result
    }

    private func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        Calendar.current.isDate(d1, inSameDayAs: d2)
    }

    private func monthKey(_ date: Date) -> Int {
        Calendar.current.component(.year, from: date) * 100 +
        Calendar.current.component(.month, from: date)
    }

    // MARK: - Emoji + background

    private func seasonalMonthEmoji(_ date: Date) -> String {
        let list = emojisForSeason(date)
        let seed = monthKey(date)
        return list[abs(seed * 73 + 19) % list.count]
    }

    private func emojisForSeason(_ date: Date) -> [String] {
        let m = Calendar.current.component(.month, from: date)
        if m == 12 || m <= 2 { return ["❄️","☕️","🧣","⛄️","🌙","⭐️"] }
        if m <= 5 { return ["🌸","🌷","🌱","🦋","🌈","💐"] }
        if m <= 8 { return ["☀️","🍉","🏖️","🌊","😎","🍦"] }
        return ["🍂","🎃","☕️","📚","🧡","🌙"]
    }

    // backgroundColorForMonth = nastaví pozadie podľa mesiaca (zimné modré, jarné ružové, jesenné oranžové...)
    private func backgroundColorForMonth(_ date: Date) -> Color {
        let m = Calendar.current.component(.month, from: date)

        if m == 12 { return Color(.systemTeal).opacity(0.14) }
        if m == 1  { return Color(.systemBlue).opacity(0.14) }
        if m == 2  { return Color(.systemIndigo).opacity(0.12) }

        if m == 3  { return Color.pink.opacity(0.12) }
        if m == 4  { return Color(.systemGreen).opacity(0.12) }
        if m == 5  { return Color(.systemMint).opacity(0.12) }

        if m == 6  { return Color.yellow.opacity(0.14) }
        if m == 7  { return Color.orange.opacity(0.12) }
        if m == 8  { return Color.yellow.opacity(0.16) }

        if m == 9  { return Color.orange.opacity(0.10) }
        if m == 10 { return Color.brown.opacity(0.12) }
        return Color.red.opacity(0.10)
    }
}
