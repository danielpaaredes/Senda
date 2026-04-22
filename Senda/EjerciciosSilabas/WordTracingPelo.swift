//
//  WordTracingPelo.swift
//  Senda
//
//  Created by Daniel Paredes on 22/04/26.
//

import SwiftUI
import AVFoundation

struct WordTracingPelo: View {
    
    let word: String
    var onFinished: () -> Void
    
    @State private var points: [CGPoint] = []
    private let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        NavigationStack {   // 🔥 IMPORTANTE: SIN ESTO NO NAVEGA
            
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    ZStack {
                        
                        Text("Pelo")
                            .font(.system(size: 120, weight: .bold))
                            .foregroundColor(.gray.opacity(0.3))
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
                    
                    // 🔥 NAVEGACIÓN CORRECTA
                    NavigationLink {
                        WordMatchView(
                            exercise: WordMatchExercise(
                                topSyllables: ["PA", "PE", "PI", "PO", "PU"],
                                bottomSyllables: ["LA", "LE", "LI", "LO", "LU"],
                                validWords: [
                                    "PELO": "Mi pelo es café.",
                                    "PALO": "El palo es de madera.",
                                    "PILA": "La pila está cargada.",
                                    "LUPA": "La lupa es útil.",
                                    "POPO": "El bebé hizo popó.",
                                    "PAPA": "Mi papa sabe a ajo",
                                    "PIPI": "Quiero hacer pipí.",
                                    "LUPE": "Lupe es mi amiga.",
                                    "PELA": "Pela la manzana.",
                                    "POLO": "El polo es frío.",
                                    "POLI": "El poli llegó.",
                                    "PALA": "La pala es pesada."
                                ],
                                highlightWord: "pelo"
                            )
                        )
                    } label: {
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
                speak("Con tu dedo dibuja la palabra Pelo")
            }
        }
    }
    
    func speak(_ text: String) {
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: "es-MX")
        u.rate = 0.4
        synthesizer.speak(u)
    }
}
#Preview {
    WordTracingPelo(word: "Pelo") {
        
    }
}

