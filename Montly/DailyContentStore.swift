//
//  DailyContentStore.swift
//  Montly
//
//  Created by Vanesa Orcikova on 07/02/2026.
//

import Foundation

// DailyContentStore = “sklad” textov na každý deň
// Vie ti vygenerovať jednu vec na deň: motiváciu / mini challenge / zamyslenie.
struct DailyContentStore {
    
    // ItemType = aký typ obsahu dnes vyberieme
    enum ItemType { case motivation, challenge, reflection }

    // Item = jedna “kartička” ktorú potom ukážeš v appke (typ + title + text)
    struct Item {
        let type: ItemType
        let title: String
        let text: String
    }

    static let motivations: [String] = [
        "Stačí urobiť malý krok. Aj ten sa počíta.",
        "Nemusíš byť perfektná, stačí byť konzistentná.",
        "Tvoje tempo je v poriadku.",
        "Aj pomalý progres je progres.",
        "To, že sa snažíš, už znamená veľa.",
        "Dnes robíš viac, než si myslíš.",
        "Buď na seba jemná.",
        "Každý deň má nový začiatok.",
        "Aj oddych je súčasť cesty.",
        "Nie si pozadu.",
        "Si presne tam, kde máš byť.",
        "Aj malé víťazstvá sa rátajú.",
        "Nie všetko musíš zvládnuť dnes.",
        "Dovoľ si ísť krok za krokom.",
        "To, že pokračuješ, je dôležité.",
        "Máš právo robiť veci po svojom.",
        "Nie je slabosť spomaliť.",
        "Každý deň sa niečo učíš.",
        "Nemusíš sa porovnávať.",
        "Aj ticho má hodnotu.",
        "To, že sa staráš o seba, má zmysel.",
        "Nemusíš mať odpovede na všetko.",
        "Si dosť taká, aká si.",
        "Aj dnes si spravila, čo si vedela.",
        "Je v poriadku zmeniť plán.",
        "Nie každý deň musí byť produktívny.",
        "Tvoje úsilie sa raz vráti.",
        "Aj malé zlepšenie je zlepšenie.",
        "Máš viac sily, než si myslíš.",
        "Nie si sama.",
        "Dnes môžeš začať znova.",
        "Stačí byť prítomná.",
        "Tvoje pocity sú platné.",
        "Môžeš si dovoliť oddych.",
        "To, že sa snažíš, stačí.",
        "Nemusíš ísť rýchlo.",
        "Každý deň má hodnotu.",
        "Aj chaos je súčasť rastu.",
        "Nie si povinná byť silná stále.",
        "To, čo robíš, má význam.",
        "Môžeš si veriť.",
        "Aj dnes si urobila maximum.",
        "Nemusíš sa ponáhľať.",
        "Aj malé kroky vedú ďaleko.",
        "Tvoje snaženie sa počíta.",
        "Je v poriadku povedať nie.",
        "Každý deň je šanca.",
        "Si viac než dosť.",
        "Dnes to stačí takto."
    ]

    static let challenges: [String] = [
        "10 minút prechádzka bez mobilu.",
        "Vypi pohár vody hneď teraz.",
        "Urob 5 hlbokých nádychov.",
        "Napíš si 3 veci, za ktoré si vďačná.",
        "Uprac jednu malú vec okolo seba.",
        "Natiahni sa aspoň 5 minút.",
        "Vypni notifikácie na 30 minút.",
        "Urob jednu vec, ktorú odkladáš.",
        "Napíš niekomu milú správu.",
        "Choď dnes spať o 30 minút skôr.",
        "Prejdi sa aspoň 5 minút.",
        "Daj si krátku pauzu bez obrazovky.",
        "Usmej sa – aj nasilu 🙂",
        "Vypi čaj alebo kávu vedome.",
        "Urob 10 drepov alebo streč.",
        "Vyvetraj miestnosť.",
        "Zapíš si jednu myšlienku.",
        "Pusti si obľúbenú pesničku.",
        "Urob si malý self-care moment.",
        "Dnes sa pochváľ za niečo.",
        "Na 10 minút sa sústreď len na jednu vec.",
        "Odlož mobil aspoň na 15 minút.",
        "Urob niečo len pre seba.",
        "Napíš si, čo ti dnes urobilo radosť.",
        "Daj si krátky oddych.",
        "Zhlboka sa nadýchni a vydýchni 3×.",
        "Urob si poriadok v jednej zásuvke.",
        "Prečítaj si pár strán knihy.",
        "Daj si pohár vody pred kávou.",
        "Urob niečo pomaly a vedome.",
        "Vyjdi na čerstvý vzduch.",
        "Na chvíľu sa ponaťahuj.",
        "Napíš si dnešnú prioritu.",
        "Urob si krátku prestávku.",
        "Uprac si pracovný stôl.",
        "Zastav sa a všimni si okolie.",
        "Urob niečo bez tlaku na výkon.",
        "Vypni hudbu a uži si ticho.",
        "Napíš si, čo ťa dnes potešilo.",
        "Urob jednu láskavosť pre seba.",
        "Venuj 5 minút dýchaniu.",
        "Zjedz niečo pomaly.",
        "Urob jednu vec vedome.",
        "Zavri oči na minútu.",
        "Napíš si krátku poznámku.",
        "Urob niečo len pre radosť.",
        "Daj si pauzu od porovnávania.",
        "Vypni hlavu aspoň na chvíľu.",
        "Urob si pohodlie.",
        "Zastav sa a buď tu."
    ]

    static let reflections: [String] = [
        "Ako sa dnes naozaj cítim?",
        "Na čo som dnes hrdá?",
        "Čo mi dnes prinieslo pokoj?",
        "Čo môžem pustiť a neriešiť?",
        "Za čo som dnes vďačná?",
        "Čo mi dnes urobilo radosť?",
        "Čo ma dnes najviac unavilo?",
        "Čo mi dnes dodalo energiu?",
        "Čo som dnes zvládla, aj keď to bolo ťažké?",
        "Čo by som dnes urobila inak?",
        "Ako by som opísala dnešný deň jednou vetou?",
        "Čo mi dnes pomohlo cítiť sa lepšie?",
        "Čo mi dnes chýbalo?",
        "Čo som sa dnes naučila?",
        "Čo mi dnes išlo dobre?",
        "Ako sa cítim práve teraz?",
        "Čo ma dnes stresovalo?",
        "Čo by som odkázala samej sebe?",
        "Čo ma dnes prekvapilo?",
        "Čo si dnes zaslúži pochvalu?",
        "Čo mi dnes urobilo úsmev?",
        "Čo mi dnes prinieslo úľavu?",
        "Čo by som chcela zajtra spraviť inak?",
        "Čo mi dnes pomohlo zvládnuť deň?",
        "Čo mi dnes urobilo dobre?",
        "Čo mi dnes vzalo energiu?",
        "Ako by som dnes opísala svoje pocity?",
        "Čo som dnes pre seba urobila?",
        "Čo dnes môžem nechať tak?",
        "Čo ma dnes potešilo?",
        "Čo som dnes zvládla lepšie než včera?",
        "Čo mi dnes prinieslo pokoj?",
        "Čo by som dnes chcela viac?",
        "Čo mi dnes dalo zmysel?",
        "Čo mi dnes pomohlo spomaliť?",
        "Čo ma dnes rozladilo?",
        "Čo ma dnes upokojilo?",
        "Čo si dnes cením?",
        "Čo mi dnes pomohlo vydržať?",
        "Čo by som dnes ocenila viac?",
        "Čo mi dnes pomohlo cítiť sa bezpečne?",
        "Čo by som dnes chcela zmeniť?",
        "Čo mi dnes urobilo deň lepším?",
        "Ako sa dnes ku mne správal svet?",
        "Ako som sa dnes správala k sebe?",
        "Čo mi dnes dalo nádej?",
        "Čo by som si dnes priala?",
        "Čo mi dnes stálo za pozornosť?",
        "Čo mi dnes pomohlo byť prítomná?",
        "Ako by som si chcela pamätať dnešok?"
    ]

    // item(for:) = hlavná funkcia: pre konkrétny dátum vyberie čo sa zobrazí
    static func item(for date: Date) -> Item {
        if motivations.isEmpty || challenges.isEmpty || reflections.isEmpty {
            return Item(type: .motivation, title: "Motivácia ✨", text: "Dnes je nový začiatok. Sprav malý krok. 🤍")
        }

        let daySeed = seedForDay(date)
        let monthSeed = seedForMonth(date)

        let weights = monthlyWeights(seed: monthSeed) // weights = v každom mesiaci máš trošku iné percentá, či bude skôr challenge/reflection/motivation

        let r = random01(seed: mix(daySeed, salt: monthSeed))  // r je “náhodné” číslo 0...1, ale stabilné pre daný deň+mesiac

        if r < weights.challenge {
            let i = abs(mix(daySeed, salt: 11)) % challenges.count
            return Item(type: .challenge, title: "Mini challenge 💪", text: challenges[i])
        }

        if r < weights.challenge + weights.reflection {
            let i = abs(mix(daySeed, salt: 13)) % reflections.count
            return Item(type: .reflection, title: "Zamyslenie ✍️", text: reflections[i])
        }

        let i = abs(mix(daySeed, salt: 7)) % motivations.count
        return Item(type: .motivation, title: "Motivácia ✨", text: motivations[i])
    }

    // MARK: - Monthly weights

    private struct Weights {
        let motivation: Double
        let challenge: Double
        let reflection: Double
    }

    private static func monthlyWeights(seed: Int) -> Weights {
        let a = 0.3 + random01(seed: mix(seed, salt: 101)) * 0.9
        let b = 0.3 + random01(seed: mix(seed, salt: 202)) * 0.9
        let c = 0.3 + random01(seed: mix(seed, salt: 303)) * 0.9

        let sum = a + b + c
        var m = a / sum
        var ch = b / sum
        var r = c / sum

        m = max(0.15, min(0.70, m))
        ch = max(0.10, min(0.60, ch))
        r = max(0.10, min(0.60, r))

        let sum2 = m + ch + r
        return Weights(motivation: m / sum2, challenge: ch / sum2, reflection: r / sum2)
    }
// Weights je štruktúra, ktorá obsahuje 3 čísla (pravdepodobnosti) pre motiváciu, challenge a reflection.
// Funkcia monthlyWeights(seed:) vypočíta tieto váhy podľa mesiaca (seed), aby sa každý mesiac mierne menil pomer typov obsahu.
// Najprv sa vytvoria 3 “random” hodnoty a, b, c, ktoré však nikdy nie sú príliš malé (začínajú od 0.3).
// Potom sa tieto hodnoty normalizujú (vydelia súčtom), aby spolu dávali 1 (čiže 100%).
// Následne sa použije clamp (min/max), aby sa nestalo, že jeden typ bude extrémne dominantný.
// Nakoniec sa to ešte raz prepočíta, aby výsledné váhy opäť spolu dávali presne 1.
// Výsledok určuje, aká veľká šanca je v danom mesiaci na motiváciu, challenge alebo reflection.

// MARK: - Seeds

// seedForDay vytvorí z dátumu jedno unikátne číslo pre každý deň.
// Zoberie rok, mesiac a deň a spojí ich do formátu YYYYMMDD (napr. 2026-02-08 -> 20260208).
// Toto sa používa ako seed, aby bol výber obsahu vždy rovnaký pre ten istý dátum.
    private static func seedForDay(_ date: Date) -> Int {
        let c = Calendar.current
        let y = c.component(.year, from: date)
        let m = c.component(.month, from: date)
        let d = c.component(.day, from: date)
        return y * 10_000 + m * 100 + d
    }

// seedForMonth vytvorí z dátumu číslo unikátne pre celý mesiac.
// Zoberie rok a mesiac a spojí ich do formátu YYYYMM (napr. február 2026 -> 202602).
// Toto sa používa na to, aby sa napríklad váhy (weights) menili podľa mesiaca.
    private static func seedForMonth(_ date: Date) -> Int {
        let c = Calendar.current
        let y = c.component(.year, from: date)
        let m = c.component(.month, from: date)
        return y * 100 + m
    }

// MARK: - Stable random
    
// random01(seed:) vytvorí “fake random” číslo medzi 0 a 1.
// Je to stabilné, čiže pre rovnaký seed vždy vráti rovnaký výsledok.
// Používa sa to na to, aby appka vyzerala random, ale zároveň sa obsah nemenil pri každom otvorení.
    private static func random01(seed: Int) -> Double {
        var x = UInt64(abs(seed))
        x = x &* 6364136223846793005 &+ 1442695040888963407
        let v = Double((x >> 11) & 0x1FFFFFFFFFFFFF)
        return v / Double(0x1FFFFFFFFFFFFF)
    }

// mix(seed, salt) “zamieša” seed so salt číslom.
// Salt je len ďalšie číslo, ktoré zabezpečí, že z jedného seed vieš vytvoriť viac rôznych výsledkov.
// Používa sa to napríklad tak, že pre challenge/reflection/motivation dáš iný salt,
// aby každá kategória mala inú random hodnotu aj keď je dátum rovnaký.
    private static func mix(_ seed: Int, salt: Int) -> Int {
        var x = UInt64(abs(seed) &+ salt &* 101)
        x ^= (x >> 33)
        x &*= 0xff51afd7ed558ccd
        x ^= (x >> 33)
        x &*= 0xc4ceb9fe1a85ec53
        x ^= (x >> 33)
        return Int(truncatingIfNeeded: x)
    }
}
