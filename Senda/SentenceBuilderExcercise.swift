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
    
    @State private var goToLecciones = false

    let synthesizer = AVSpeechSynthesizer()
    let yellowa = Color(red: 1.0, green: 0.749, blue: 0.0)

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
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Color(red: 0.96, green: 0.96, blue: 0.96)
                    .ignoresSafeArea()

                // HOME
                Button(action: { onFinish() }) {
                    Image(systemName: "house.fill")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(15)
                        .background(yellowa)
                        .cornerRadius(15)
                }
                .padding(20)
                .zIndex(1)

                VStack(spacing: 0) {
                    // SPEAKER
                    HStack {
                        Spacer()
                        Button(action: { speakSentence() }) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                                .padding(30)
                                .background(yellowa)
                                .cornerRadius(25)
                        }
                        Spacer()
                    }
                    .padding(.top, 40)

                    Spacer()

                    // SLOTS ROW
                    HStack(alignment: .bottom, spacing: 40) {
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

                    // WORD BANK
                    HStack(spacing: 20) {
                        ForEach(availableWords, id: \.self) { word in
                            WordBankButton(
                                text: word,
                                isSelected: selectedWord == word,
                                yellowa: yellowa
                            )
                            .onTapGesture {
                                handleSingleTap(word)
                            }
                            .onTapGesture(count: 2) {
                                handleDoubleTap(word)
                            }
                        }
                    }
                    .padding(.bottom, 50)
                }

                // NEXT ARROW
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Button(action: {
                            goToLecciones = true
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 25)
                                .background(yellowa)
                                .cornerRadius(20)
                                .shadow(radius: 5)
                        }
                        Spacer()
                    }
                }
                .padding(.trailing, 30)
            }
            .navigationDestination(isPresented: $goToLecciones) {
                LeccionesSimuladasView()
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    speakSentence()
                }
            }
        }
    }

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
            if let wrongIndex = zip(formed, exercise.correctOrder).enumerated().first(where: { $0.element.0 != $0.element.1 })?.offset {
                triggerShake(at: wrongIndex)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                availableWords = exercise.words
                slots = Array(repeating: nil, count: exercise.correctOrder.count)
            }
        }
    }

    func triggerShake(at index: Int) {
        shakeSlotIndex = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { shakeSlotIndex = index }
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

struct SlotView: View {
    let word: String?
    let isShaking: Bool
    let isComplete: Bool
    var body: some View {
        VStack(spacing: 12) {
            Text(word ?? " ")
                .font(.system(size: 35, weight: .bold)) // Fuente de sistema
                .foregroundColor(isComplete ? .green : .black)
                .frame(minWidth: 120)
            Rectangle()
                .frame(width: 150, height: 4)
                .foregroundColor(isComplete ? .green : .black)
        }
        .modifier(SlotShakeModifier(trigger: isShaking))
    }
}

struct WordBankButton: View {
    let text: String
    let isSelected: Bool
    let yellowa: Color
    var body: some View {
        Text(text)
            .font(.system(size: 30, weight: .bold)) // Fuente de sistema
            .foregroundColor(.black)
            .padding(.horizontal, 25)
            .padding(.vertical, 15)
            .background(isSelected ? yellowa : Color.white)
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(yellowa, lineWidth: 4))
    }
}

struct SlotShakeModifier: ViewModifier {
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
