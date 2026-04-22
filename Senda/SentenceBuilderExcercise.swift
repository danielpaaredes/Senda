//
//  SentenceBuilderExcercise.swift
//  Senda
//
//  Created by Daniel Paredes on 22/04/26.
//
import SwiftUI
import AVFoundation

// MARK: - Model

struct SentenceBuilderExercise {
    let sentence: String
    let words: [String]
    let correctOrder: [String]
}

// MARK: - View

struct SentenceBuilderView: View {

    let exercise: SentenceBuilderExercise
    let onFinish: () -> Void

    @State private var selectedWord: String? = nil
    @State private var slots: [String?]
    @State private var availableWords: [String]
    @State private var isComplete: Bool = false
    @State private var shakeSlotIndex: Int? = nil

    let synthesizer = AVSpeechSynthesizer()

    init(exercise: SentenceBuilderExercise, onFinish: @escaping () -> Void) {
        self.exercise = exercise
        self.onFinish = onFinish
        _slots = State(initialValue: Array(repeating: nil, count: exercise.correctOrder.count))
        _availableWords = State(initialValue: exercise.words)
    }

    var firstEmptySlot: Int? {
        slots.firstIndex(where: { $0 == nil })
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.background
                .ignoresSafeArea()

            // HOME — esquina superior izquierda flotando
            Button(action: {}) {
                Image(systemName: "house.fill")
                    .font(.callout)
                    .foregroundColor(.typography)
                    .padding(10)
                    .background(Color.yellowa)
                    .cornerRadius(10)
            }
            .padding(16)
            .zIndex(1)

            // MAIN CONTENT
            VStack(spacing: 0) {

                // SPEAKER — centrado arriba
                HStack {
                    Spacer()
                    Button(action: { speakSentence() }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.typography)
                            .padding(22)
                            .background(Color.yellowa)
                            .cornerRadius(20)
                    }
                    Spacer()
                }
                .padding(.top, 28)

                Spacer()

                // SLOTS ROW — líneas largas con texto encima
                HStack(alignment: .bottom, spacing: 32) {
                    ForEach(0..<slots.count, id: \.self) { index in
                        SlotView(
                            word: slots[index],
                            isShaking: shakeSlotIndex == index,
                            isComplete: isComplete
                        )
                        .onTapGesture {
                            returnWordFromSlot(at: index)
                        }
                    }
                }
                .padding(.horizontal, 40)

                Spacer()

                // WORD BANK — centrado abajo
                HStack(spacing: 12) {
                    ForEach(availableWords, id: \.self) { word in
                        WordBankButton(
                            text: word,
                            isSelected: selectedWord == word
                        )
                        .onTapGesture {
                            handleSingleTap(word)
                        }
                        .onTapGesture(count: 2) {
                            handleDoubleTap(word)
                        }
                    }
                }
                .padding(.bottom, 36)
            }

            // NEXT ARROW — derecha centrada verticalmente
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Button(action: {
                        // TODO: conectar navegación
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .foregroundColor(.typography)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 20)
                            .background(Color.yellowa)
                            .cornerRadius(16)
                    }
                    Spacer()
                }
            }
            .padding(.trailing, 16)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                speakSentence()
            }
        }
    }

    // MARK: - Logic

    func handleSingleTap(_ word: String) {
        guard !isComplete else { return }
        selectedWord = selectedWord == word ? nil : word
        speak(word)
    }

    func handleDoubleTap(_ word: String) {
        guard !isComplete else { return }
        guard let slotIndex = firstEmptySlot else { return }
        availableWords.removeAll { $0 == word }
        selectedWord = nil
        slots[slotIndex] = word
        if !slots.contains(where: { $0 == nil }) {
            validateSentence()
        }
    }

    func returnWordFromSlot(at index: Int) {
        guard !isComplete else { return }
        guard let word = slots[index] else { return }
        slots[index] = nil
        availableWords.append(word)
    }

    func validateSentence() {
        let formed = slots.compactMap { $0 }
        if formed == exercise.correctOrder {
            isComplete = true
            speak("¡Muy bien!")
        } else {
            speak("Inténtalo de nuevo")
            if let wrongIndex = zip(formed, exercise.correctOrder)
                .enumerated()
                .first(where: { $0.element.0 != $0.element.1 })?.offset {
                triggerShake(at: wrongIndex)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                availableWords = exercise.words
                slots = Array(repeating: nil, count: exercise.correctOrder.count)
            }
        }
    }

    func triggerShake(at index: Int) {
        shakeSlotIndex = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            shakeSlotIndex = index
        }
    }

    func speakSentence() { speak(exercise.sentence) }

    func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}

// MARK: - Slot View

struct SlotView: View {
    let word: String?
    let isShaking: Bool
    let isComplete: Bool

    var body: some View {
        VStack(spacing: 8) {
            // Texto encima de la línea
            Text(word ?? " ")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(isComplete ? .green : .typography)
                .opacity(word == nil ? 0 : 1)
                .frame(minWidth: 90)
                .animation(.easeInOut(duration: 0.15), value: word)

            // Línea larga debajo
            Rectangle()
                .frame(width: 120, height: 3)
                .foregroundColor(isComplete ? .green : .typography)
        }
        .modifier(SlotShakeModifier(trigger: isShaking))
        .animation(.easeInOut(duration: 0.2), value: isComplete)
    }
}

// MARK: - Word Bank Button

struct WordBankButton: View {
    let text: String
    let isSelected: Bool

    var body: some View {
        Text(text)
            .font(.system(size: 22, weight: .medium))
            .foregroundColor(.typography)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(isSelected ? Color.yellowa : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.yellowa, lineWidth: 3)
            )
            .cornerRadius(14)
            .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Slot Shake Modifier

struct SlotShakeModifier: ViewModifier {
    let trigger: Bool
    @State private var xOffset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(x: xOffset)
            .onChange(of: trigger) { newValue in
                if newValue {
                    withAnimation(.linear(duration: 0.06).repeatCount(5, autoreverses: true)) {
                        xOffset = 10
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        xOffset = 0
                    }
                }
            }
    }
}

// MARK: - Preview

#Preview {
    SentenceBuilderView(
        exercise: SentenceBuilderExercise(
            sentence: "Lupe pela la papa",
            words: ["pela", "papa", "Lupe", "la"],
            correctOrder: ["Lupe", "pela", "la", "papa"]
        ),
        onFinish: {}
    )
    .previewInterfaceOrientation(.landscapeLeft)
}
