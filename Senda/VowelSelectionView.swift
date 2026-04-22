//
//  VowelSelectionView.swift
//  Senda
//
//  Created by Daniel Paredes on 22/04/26.
//
import SwiftUI
import AVFoundation

struct VowelSelectionView: View {
    
    @State private var selectedVowel: String? = nil
    @State private var isCorrect: Bool = false
    @State private var showNextButton = false
    @State private var showTracingView = false
    @State private var vowelSequence = ["Aa", "Ee", "Ii", "Oo", "Uu"].shuffled()
    @State private var currentIndex = 0
    
    let synthesizer = AVSpeechSynthesizer()
    
    let vowels = ["Aa", "Ee", "Ii", "Oo", "Uu"]
    
    let vowelSounds = [
        "Aa": "a",
        "Ee": "e",
        "Ii": "i",
        "Oo": "o",
        "Uu": "u"
    ]
    
    var currentVowel: String {
        vowelSequence[currentIndex]
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                
                // HOME
                HStack {
                    Button(action: {}) {
                        Image(systemName: "house.fill")
                            .font(.title)
                            .foregroundColor(.typography)
                            .padding()
                            .background(Color.yellowa)
                            .cornerRadius(15)
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                // SPEAKER
                Button(action: {
                    playCurrentVowel()
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.typography)
                        .padding(30)
                        .background(Color.yellowa)
                        .cornerRadius(18)
                }
                
                Spacer()
                
                // VOCAL BUTTONS (MEJORADOS)
                HStack(spacing: 16) {
                    ForEach(vowels, id: \.self) { vowel in
                        VowelButton(
                            text: vowel,
                            isSelected: selectedVowel == vowel,
                            isCorrect: isCorrect && selectedVowel == vowel
                        )
                        .onTapGesture {
                            guard !showNextButton else { return }
                            selectedVowel = vowel
                            isCorrect = false
                            speakLetter(vowel)
                        }
                        .onTapGesture(count: 2) {
                            guard !showNextButton else { return }
                            confirmSelection()
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            
            // NEXT BUTTON
            if showNextButton {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // aquí puedes seguir a otra pantalla si quieres
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.title)
                            .foregroundColor(.typography)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                            .background(Color.yellowa)
                            .cornerRadius(20)
                    }
                    .padding(.trailing, 30)
                }
            }
        }
        .onAppear {
            playCurrentVowel()
        }
        .sheet(isPresented: $showTracingView) {
            VowelTracingView(vowel: currentVowel) {
                showTracingView = false
                nextVowel()
            }
        }
    }
    
    // MARK: - LOGIC
    
    func playCurrentVowel() {
        if let sound = vowelSounds[currentVowel] {
            speak(sound)
        }
    }
    
    func speakLetter(_ letter: String) {
        if let sound = vowelSounds[letter] {
            speak(sound)
        }
    }
    
    func confirmSelection() {
        if selectedVowel == currentVowel {
            isCorrect = true
            speak("Correcto.")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                showTracingView = true
            }
        } else {
            speak("Inténtalo de nuevo")
        }
    }
    
    func nextVowel() {
        if currentIndex < vowelSequence.count - 1 {
            currentIndex += 1
            selectedVowel = nil
            isCorrect = false
            playCurrentVowel()
        } else {
            showNextButton = true
            speak("Terminaste")
        }
    }
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}
struct VowelButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    
    var backgroundColor: Color {
        if isCorrect { return Color.green.opacity(0.2) }
        if isSelected { return Color.yellowa }
        return Color.white
    }
    
    var borderColor: Color {
        isCorrect ? Color.green : Color.yellowa
    }
    
    var textColor: Color {
        isCorrect ? Color.green : Color.typography
    }
    
    var body: some View {
        Text(text)
            .font(.largeTitle.weight(.medium))
            .foregroundColor(textColor)
            .padding(.horizontal, 25)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(borderColor, lineWidth: 4)
            )
            .cornerRadius(20)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
            .animation(.easeInOut(duration: 0.2), value: isCorrect)
    }
}

#Preview {
    VowelSelectionView()
        .previewInterfaceOrientation(.landscapeLeft)
}
