//
//  ReflectionEditorView.swift
//  Montly
//
//  Created by Vanesa Orcikova on 07/02/2026.
//

import SwiftUI

// ReflectionEditorView = obrazovka kde si user píše poznámku / zamyslenie k nejakému dňu
struct ReflectionEditorView: View {

    let dateKey: String // dateKey = kľúč pod ktorým sa tá poznámka ukladá (napr. "2026-02-08")
    let question: String // question = otázka, ktorú user vidí hore (napr. "Čo sa ti dnes podarilo?")

    @Binding var notes: [String: String]

    @Environment(\.dismiss) private var dismiss // dismiss = zavretie obrazovky (napr. keď je otvorená ako sheet)
    @State private var text: String = ""  // text = lokálny text, ktorý sa píše v TextEditore

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 14) {

                    // CARD = tá biela “kartička” s otázkou a text editorom
                    VStack(alignment: .leading, spacing: 10) {
                        Text(question)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)

                        Text("Napíš si sem pár viet. Aj 1 veta stačí ✨")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        // mini podtext aby user nemal stres že musí písať veľa
                        ZStack(alignment: .topLeading) {
                            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text("Začni písať…")
                                    .foregroundColor(.gray.opacity(0.6))
                                    .padding(.top, 14)
                                    .padding(.leading, 12)
                            }

                            // tu user reálne píše
                            TextEditor(text: $text)
                                .padding(8)
                                .frame(minHeight: 260)
                                .scrollContentBackground(.hidden)
                                .background(Color.white)
                                .cornerRadius(18)
                        }
                        // jemný rámik okolo editoru
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.white.opacity(0.92))
                            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
                    )
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top, 12)
            }
            .navigationTitle("Zamyslenie ✍️")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušiť") {
                        dismiss()
                    }
                    .foregroundColor(.pink)
                }
                // pravé tlačidlo = uloží a zavrie
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        notes[dateKey] = text
                        saveNotes()
                        dismiss()
                    } label: {
                        Text("Uložiť")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(canSave ? .pink : .gray)
                    .disabled(!canSave)
                }
            }
        }
        .onAppear {
            // keď sa view otvorí, načítame existujúcu poznámku (ak už bola uložená)
            text = notes[dateKey] ?? ""
        }
    }

    private var canSave: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func saveNotes() {
        if let data = try? JSONSerialization.data(withJSONObject: notes, options: []) {
            UserDefaults.standard.set(data, forKey: "reflection_notes")
        }
    }
}

// Celkovo: táto view slúži len ako “editor” pre poznámku ku konkrétnemu dňu. Text sa píše do @State text, a až keď dá user Uložiť, tak sa to prenesie do notes[dateKey] (cez @Binding) a zároveň sa to uloží do UserDefaults, aby sa to nestratilo po vypnutí appky. canSave len kontroluje, aby user neuložil prázdnu poznámku.
