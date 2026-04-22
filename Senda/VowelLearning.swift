import SwiftUI
import AVFoundation

struct VowelLearning: View {
    
    @State private var selectedVowel: String? = nil
    let synthesizer = AVSpeechSynthesizer()
    
    let vowels = ["A", "E", "I", "O", "U"]
    
    let vowelSounds = [
        "A": "a",
        "E": "e",
        "I": "i",
        "O": "o",
        "U": "u"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                VStack {
                    
                  
                    HStack {
                        Button(action: {
                            
                        }) {
                            Image(systemName: "house.fill")
                                .font(.title)
                                .foregroundColor(Color.typography)
                                .padding()
                                .background(Color.yellowa)
                                .cornerRadius(15)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                    
            
                    HStack(spacing: 16) {
                        ForEach(vowels, id: \.self) { vowel in
                            Button(action: {
                                selectedVowel = vowel
                                speak(vowelSounds[vowel] ?? vowel)
                            }) {
                                Text(vowel)
                                    .font(.largeTitle.weight(.medium))
                                    .foregroundColor(.black)
                                    .minimumScaleFactor(0.5)
                                    .padding(.horizontal, 25)
                                    .padding(.vertical, 20)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        selectedVowel == vowel
                                        ? Color.yellowa.opacity(0.5)
                                        : Color.white
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.yellowa, lineWidth: 4)
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
         
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.title)
                            .foregroundColor(Color.typography)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                            .background(Color.yellowa)
                            .cornerRadius(20)
                    }
                    
                    Spacer()
                }
            }
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
    VowelLearning()
        .previewInterfaceOrientation(.landscapeLeft)
}
