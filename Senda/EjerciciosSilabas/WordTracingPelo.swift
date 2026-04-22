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
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    // Botón para borrar el trazo
                    HStack {
                        Button(action: { points.removeAll() }) {
                            Label("Borrar", systemImage: "eraser.fill")
                                .font(.headline)
                                .foregroundColor(.typography)
                                .padding()
                                .background(Color.yellowa.opacity(0.3))
                                .cornerRadius(15)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // ÁREA DE TRAZO
                    ZStack {
                        // 1. Texto de guía (Fondo gris)
                        Text(word)
                            .font(.system(size: 150, weight: .bold)) // Un poco más grande para facilitar el trazo
                            .foregroundColor(.gray.opacity(0.2))
                        
                        // 2. El "Lápiz" (Dibuja el camino de puntos)
                        Path { path in
                            guard let firstPoint = points.first else { return }
                            path.move(to: firstPoint)
                            for point in points {
                                path.addLine(to: point)
                            }
                        }
                        .stroke(Color.black, style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
                    .contentShape(Rectangle()) // Hace que toda el área sea sensible al toque
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                points.append(value.location)
                            }
                    )
                    
                    Spacer()
                    
                    // NAVEGACIÓN
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
                            onFinish: onFinished
                        )
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.typography)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .background(Color.yellowa)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                }
            }
            .onAppear {
                speak("Con tu dedo, dibuja la palabra \(word)")
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

