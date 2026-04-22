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
    
    
    @State private var strokes: [[CGPoint]] = []
    @State private var currentStroke: [CGPoint] = []
    
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
                    
                    // 🔥 DIBUJO DE STROKES COMPLETOS
                    ForEach(0..<strokes.count, id: \.self) { index in
                        Path { path in
                            let stroke = strokes[index]
                            guard let first = stroke.first else { return }
                            
                            path.move(to: first)
                            
                            for point in stroke.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                        .stroke(Color.black, lineWidth: 8)
                    }
                    
                    // 🔥 TRAZO ACTUAL (EN TIEMPO REAL)
                    Path { path in
                        guard let first = currentStroke.first else { return }
                        
                        path.move(to: first)
                        
                        for point in currentStroke.dropFirst() {
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
                            currentStroke.append(value.location)
                        }
                        .onEnded { _ in
                            strokes.append(currentStroke)
                            currentStroke = []
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
    
    // MARK: - SPEECH
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
