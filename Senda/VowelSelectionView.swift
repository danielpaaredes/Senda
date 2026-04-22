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
                
                // HOME BUTTON
                HStack {
                    Button(action: {
                        
                    }) {
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
                
                // SPEAKER BUTTON
                Button(action: {
                    playCurrentVowel()
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.typography)
                        .padding(30)
                        .background(Color.yellowa)
                        .clipShape(Rectangle())
                        .cornerRadius(18)
                }
                
                Spacer()
                
                // VOWEL BUTTONS
                HStack(spacing: 16) {
                    ForEach(vowels, id: \.self) { vowel in
                        Text(vowel)
                            .font(.largeTitle.weight(.medium))
                            .foregroundColor(.typography)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(buttonColor(for: vowel))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.yellowa, lineWidth: 4)
                            )
                            .cornerRadius(20)
                            .onTapGesture {
                                if !showNextButton {
                                    selectedVowel = vowel
                                    isCorrect = false
                                    speakLetter(vowel)
                                }
                            }
                            .onTapGesture(count: 2) {
                                if !showNextButton {
                                    confirmSelection()
                                }
                            }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            
            // FINAL NEXT BUTTON RIGHT CENTER
            if showNextButton {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
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
    
    func buttonColor(for vowel: String) -> Color {
        if selectedVowel == vowel {
            return isCorrect ? .green : Color.yellowa.opacity(0.5)
        }
        return .white
    }
    
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
            speak("Terminaste, selecciona la flecha para continuar.")
        }
    }
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}

#Preview {
    VowelSelectionView()
        .previewInterfaceOrientation(.landscapeLeft)
}
