//
//  WordMatchView.swift
//  Senda
//
//  Created by Daniel Paredes on 22/04/26.
//

import SwiftUI
import AVFoundation

// MARK: - Pronunciation Dictionary
let syllablePronunciations: [String: String] = [
    "PA": "pa", "PE": "pe", "PI": "pi", "PO": "po", "PU": "pu",
    "LA": "la", "LE": "le", "LI": "li", "LO": "lo", "LU": "luh",
]

// MARK: - Model
struct WordMatchExercise {
    let topSyllables: [String]
    let bottomSyllables: [String]
    let validWords: [String: String]
    let highlightWord: String
}

// MARK: - Main View
struct WordMatchView: View {
    let exercise: WordMatchExercise
    let nextExercise: ImageWordExercise
    let onFinish: () -> Void

    @State private var selectedSyllable: String? = nil
    @State private var slot1: String? = nil
    @State private var slot2: String? = nil
    @State private var isComplete: Bool = false
    @State private var shakeSlot2: Bool = false
    @State private var wordsFound: [String] = []
    @State private var showPhraseSheet: Bool = false
    @State private var currentPhrase: String = ""
    @State private var currentFoundWord: String = ""
    
    @State private var navigateToImageExercise: Bool = false

    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            NavigationLink(
                destination: ImageWordSelectionView(
                    exercise: nextExercise,
                    onFinish: onFinish
                ),
                isActive: $navigateToImageExercise
            ) {
                EmptyView()
            }

            HStack(spacing: 0) {
                // LEFT: Home button
                VStack {
                    Button(action: {}) {
                        Image(systemName: "house.fill")
                            .font(.callout)
                            .foregroundColor(.typography)
                            .padding(10)
                            .background(Color.yellowa)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(12)

                // CENTER
                VStack(spacing: 0) {
                    Spacer()
                    SyllableRow(
                        syllables: exercise.topSyllables,
                        selectedSyllable: selectedSyllable,
                        onSingleTap: handleSingleTap,
                        onDoubleTap: handleDoubleTap
                    )
                    Spacer()
                    HStack(spacing: 40) {
                        WordSlot(text: slot1 ?? "", isComplete: isComplete)
                        WordSlot(text: slot2 ?? "", isComplete: isComplete)
                            .modifier(ShakeOffsetModifier(trigger: shakeSlot2))
                    }
                    Spacer()
                    SyllableRow(
                        syllables: exercise.bottomSyllables,
                        selectedSyllable: selectedSyllable,
                        onSingleTap: handleSingleTap,
                        onDoubleTap: handleDoubleTap
                    )
                    Spacer()
                }

                // RIGHT: Next arrow
                VStack {
                    Spacer()
                    Button(action: {
                        navigateToImageExercise = true
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .foregroundColor(.typography)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 18)
                            .background(Color.yellowa)
                            .cornerRadius(16)
                    }
                    Spacer()
                }
                .padding(12)
            }

            if showPhraseSheet {
                WordPhraseSheet(
                    word: currentFoundWord,
                    phrase: currentPhrase,
                    onDismiss: {
                        showPhraseSheet = false
                        resetSlots()
                    }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showPhraseSheet)
        .toolbar(.hidden, for: .navigationBar)
        // AGREGADO: Instrucciones al iniciar la vista
        .onAppear {
            let instrucciones = "Con las sílabas que ves en pantalla, trata de formar palabras. Al presionar una vez puedes escuchar el sonido, y al presionar dos veces seleccionas la sílaba para que sea parte de tu palabra."
            speak(instrucciones)
        }
    }

    // MARK: - Logic
    func handleSingleTap(_ syllable: String) {
        guard !showPhraseSheet else { return }
        selectedSyllable = selectedSyllable == syllable ? nil : syllable
        speakSyllable(syllable)
    }

    func handleDoubleTap(_ syllable: String) {
        guard !showPhraseSheet else { return }
        selectedSyllable = nil

        if slot1 == nil {
            slot1 = syllable
        } else if slot2 == nil {
            slot2 = syllable
            let formed = (slot1 ?? "") + syllable

            let key = formed.uppercased()
            if let phrase = exercise.validWords[key] {
                isComplete = true
                wordsFound.append(formed)
                currentFoundWord = formed
                currentPhrase = phrase

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    showPhraseSheet = true
                }
            } else {
                speak("Inténtalo de nuevo")
                triggerShake()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    resetSlots()
                }
            }
        }
    }

    func resetSlots() {
        withAnimation(.easeInOut(duration: 0.2)) {
            slot1 = nil
            slot2 = nil
            isComplete = false
        }
    }

    func triggerShake() {
        shakeSlot2 = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            shakeSlot2 = true
        }
    }

    func speakSyllable(_ syllable: String) {
        let text = syllablePronunciations[syllable.uppercased()] ?? syllable.lowercased()
        speak(text)
    }

    func speak(_ text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}

// MARK: - Componentes de apoyo (Sin cambios de UI)

struct WordPhraseSheet: View {
    let word: String
    let phrase: String
    let onDismiss: () -> Void
    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea().onTapGesture { onDismiss() }
            ZStack {
                RoundedRectangle(cornerRadius: 28).fill(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.yellowa, lineWidth: 4))
                VStack(spacing: 24) {
                    Button(action: { speakPhrase() }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 44)).foregroundColor(.typography)
                            .padding(24).background(Color.yellowa).cornerRadius(20)
                    }
                    PhraseText(phrase: phrase, highlight: word.lowercased())
                        .font(.system(size: 32, weight: .medium)).multilineTextAlignment(.center)
                }
                .padding(40)
            }
            .frame(width: 680, height: 320)
            .overlay(alignment: .trailing) {
                Button(action: { onDismiss() }) {
                    Image(systemName: "arrow.right").font(.title2).foregroundColor(.typography)
                        .padding(.horizontal, 28).padding(.vertical, 20).background(Color.yellowa).cornerRadius(16)
                }
                .offset(x: 36)
            }
        }
        .onAppear { speakPhrase() }
    }
    func speakPhrase() {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}

struct PhraseText: View {
    let phrase: String
    let highlight: String
    var body: some View {
        let words = phrase.components(separatedBy: " ")
        HStack(spacing: 6) {
            ForEach(Array(words.enumerated()), id: \.offset) { _, word in
                let clean = word.trimmingCharacters(in: .punctuationCharacters).lowercased()
                if clean == highlight.lowercased() {
                    Text(word).foregroundColor(Color.yellowa).underline(color: Color.yellowa)
                } else {
                    Text(word).foregroundColor(.typography)
                }
            }
        }
    }
}

struct SyllableRow: View {
    let syllables: [String]
    let selectedSyllable: String?
    let onSingleTap: (String) -> Void
    let onDoubleTap: (String) -> Void
    var body: some View {
        HStack(spacing: 12) {
            ForEach(syllables, id: \.self) { syllable in
                SyllableButton(text: syllable, isSelected: selectedSyllable == syllable)
                    .onTapGesture { onSingleTap(syllable) }
                    .onTapGesture(count: 2) { onDoubleTap(syllable) }
            }
        }
    }
}

struct SyllableButton: View {
    let text: String
    let isSelected: Bool
    var body: some View {
        Text(text).font(.title.weight(.medium)).foregroundColor(.typography)
            .frame(width: 90, height: 70).background(isSelected ? Color.yellowa : Color.white)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.yellowa, lineWidth: 4))
            .cornerRadius(20)
    }
}

struct WordSlot: View {
    let text: String
    let isComplete: Bool
    var body: some View {
        VStack(spacing: 4) {
            Text(text.isEmpty ? " " : text).font(.system(size: 42, weight: .medium))
                .foregroundColor(isComplete ? .green : .typography).frame(minWidth: 100)
            Rectangle().frame(width: 100, height: 3).foregroundColor(.typography)
        }
    }
}

struct ShakeOffsetModifier: ViewModifier {
    let trigger: Bool
    @State private var xOffset: CGFloat = 0
    func body(content: Content) -> some View {
        content.offset(x: xOffset).onChange(of: trigger) { newValue in
            if newValue {
                withAnimation(.linear(duration: 0.06).repeatCount(5, autoreverses: true)) { xOffset = 10 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { xOffset = 0 }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        WordMatchView(
            exercise: WordMatchExercise(
                topSyllables: ["PA", "PE", "PI", "PO", "PU"],
                bottomSyllables: ["LA", "LE", "LI", "LO", "LU"],
                validWords: ["PELO": "Mi pelo es café."],
                highlightWord: "pelo"
            ),
            nextExercise: ImageWordExercise(
                imageName: "palo",
                correctWord: "Palo",
                options: ["Pepe", "Palo", "Popo"],
                nextExercise: SentenceBuilderExercise(
                    sentence: "Lupe pela la papa",
                    words: ["pela", "papa", "Lupe", "la"],
                    correctOrder: ["Lupe", "pela", "la", "papa"]
                )
            ),
            onFinish: {}
        )
    }
    .previewInterfaceOrientation(.landscapeLeft)
}
