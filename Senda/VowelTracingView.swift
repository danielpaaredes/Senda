//
//  VowelTracingView.swift
//  Senda
//
//  Created by Daniel Paredes on 22/04/26.
//

import SwiftUI
import AVFoundation

struct VowelTracingView: View {
    
    let vowel: String
    var onFinished: () -> Void
    
    @State private var points: [CGPoint] = []
    
    let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                ZStack {
                    
                    Text(vowel)
                        .font(.system(size: 250, weight: .bold))
                        .foregroundColor(.gray.opacity(0.3))
                    
                    Path { path in
                        guard let first = points.first else { return }
                        path.move(to: first)
                        
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(Color.black, lineWidth: 8)
                    
                }
                .frame(width: 350, height: 300)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            points.append(value.location)
                        }
                )
                
                Spacer()
                
                Button(action: {
                    onFinished()
                }) {
                    Image(systemName: "arrow.right")
                        .font(.title)
                        .foregroundColor(.typography)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.yellowa)
                        .cornerRadius(20)
                }
                
                Spacer()
            }
        }
        .onAppear {
            speak("Con tu dedo dibuja la silueta de la letra \(String(vowel.prefix(1)))")
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
    VowelTracingView(vowel: "Aa") {
        
    }
    .previewInterfaceOrientation(.landscapeLeft)
}
