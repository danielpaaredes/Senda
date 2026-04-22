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
    
    // Ahora guardamos un arreglo de "líneas", donde cada línea es un arreglo de puntos
    @State private var strokes: [[CGPoint]] = []
    private let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack {
                    // Quitamos el botón de borrador como pediste
                    Spacer()
                    
                    // ÁREA DE TRAZO
                    ZStack {
                        // 1. Texto de guía (Fondo gris)
                        Text(word)
                            .font(.system(size: 150, weight: .bold))
                            .foregroundColor(.gray.opacity(0.2))
                        
                        // 2. El "Lápiz" Multi-trazo
                        Canvas { context, size in
                            for stroke in strokes {
                                var path = Path()
                                if let firstPoint = stroke.first {
                                    path.move(to: firstPoint)
                                    path.addLines(stroke)
                                }
                                context.stroke(path, with: .color(.black), style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                // Si es el inicio de un toque, creamos un nuevo trazo
                                if value.translation == .zero || strokes.isEmpty {
                                    strokes.append([value.location])
                                } else {
                                    // Si ya estamos arrastrando, añadimos el punto al último trazo creado
                                    let lastIndex = strokes.count - 1
                                    strokes[lastIndex].append(value.location)
                                }
                            }
                            .onEnded { _ in
                                // Al soltar el dedo, podrías añadir lógica aquí si quisieras
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

