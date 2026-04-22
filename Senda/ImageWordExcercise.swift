//
//  ImageWordExcercise.swift
//  Senda
//
//  Created by Daniel Paredes on 22/04/26.
//
import SwiftUI
import AVFoundation

// MARK: - Model
struct ImageWordExercise {
    let imageName: String
    let correctWord: String
    let options: [String]
    let nextExercise: SentenceBuilderExercise
}

// MARK: - View
struct ImageWordSelectionView: View {
    let exercise: ImageWordExercise
    let onFinish: () -> Void

    @State private var selectedWord: String? = nil
    @State private var confirmedWord: String? = nil
    @State private var shakeOptions: Bool = false
    @State private var navigateToSentence: Bool = false

    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            // NavigationLink invisible hacia el constructor de oraciones
            NavigationLink(
                destination: SentenceBuilderView(
                    exercise: exercise.nextExercise,
                    onFinish: onFinish
                ),
                isActive: $navigateToSentence
            ) {
                EmptyView()
            }

            HStack(spacing: 0) {
                // LEFT: Home
                VStack {
                    Button(action: {}) {
                        Image(systemName: "house.fill")
                            .font(.callout).foregroundColor(.typography)
                            .padding(10).background(Color.yellowa).cornerRadius(10)
                    }
                    Spacer()
                }.padding(12)

                // CENTER: Imagen
                VStack {
                    Spacer()
                    Image(exercise.imageName)
                        .resizable().scaledToFit()
                        .frame(maxWidth: 420, maxHeight: 340).cornerRadius(24)
                    Spacer()
                }.frame(maxWidth: .infinity)

                // RIGHT: Opciones
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                    ForEach(exercise.options, id: \.self) { word in
                        WordOptionButton(
                            text: word,
                            isSelected: selectedWord == word,
                            isConfirmed: confirmedWord == word
                        )
                        .onTapGesture { handleSingleTap(word) }
                        .onTapGesture(count: 2) { handleDoubleTap(word) }
                    }
                    Spacer()
                }.padding(.leading, 8).modifier(ShakeOffsetModifier(trigger: shakeOptions))

                // NEXT BUTTON
                VStack {
                    Spacer()
                    Button(action: { navigateToSentence = true }) {
                        Image(systemName: "arrow.right").font(.title2).foregroundColor(.typography)
                            .padding(.horizontal, 28).padding(.vertical, 20)
                            .background(Color.yellowa).cornerRadius(16)
                    }
                    Spacer()
                }.padding(12)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { speak(exercise.correctWord) }
        }
    }

    func handleSingleTap(_ word: String) {
        guard confirmedWord == nil else { return }
        selectedWord = selectedWord == word ? nil : word
        speak(word)
    }

    func handleDoubleTap(_ word: String) {
        guard confirmedWord == nil else { return }
        if word.lowercased() == exercise.correctWord.lowercased() {
            confirmedWord = word
            selectedWord = nil
            speak("¡Correcto!")
        } else {
            speak("Inténtalo de nuevo")
            triggerShake()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { selectedWord = nil }
        }
    }

    func triggerShake() {
        shakeOptions = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { shakeOptions = true }
    }

    func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}

// MARK: - Word Option Button
struct WordOptionButton: View {
    let text: String
    let isSelected: Bool
    let isConfirmed: Bool

    var backgroundColor: Color {
        if isConfirmed { return Color.green.opacity(0.2) }
        if isSelected  { return Color.yellowa }
        return Color.white
    }

    var body: some View {
        Text(text).font(.title.weight(.medium)).foregroundColor(isConfirmed ? .green : .typography)
            .frame(width: 220, height: 72).background(backgroundColor)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(isConfirmed ? Color.green : Color.yellowa, lineWidth: 4))
            .cornerRadius(20)
    }
}
// MARK: - Preview

#Preview {
    NavigationStack {
        ImageWordSelectionView(
            exercise: ImageWordExercise(
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
