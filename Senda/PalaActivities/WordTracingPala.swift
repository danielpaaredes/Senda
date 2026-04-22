//
//  WordTracingLupa.swift
//  Senda
//
//  Created by Daniel Paredes on 22/04/26.
//

import SwiftUI
import AVFoundation

struct WordTracingPala: View {
    
    let word: String
    var onFinished: () -> Void
    
    // 🔥 Cambiamos a un arreglo de arreglos para permitir múltiples trazos
    @State private var strokes: [[CGPoint]] = []
    private let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack {
                    // Texto guía de fondo
                    Text(word)
                        .font(.system(size: 120, weight: .bold))
                        .foregroundColor(.gray.opacity(0.3))
                    
                    // 🔥 Canvas para dibujar trazos independientes
                    Canvas { context, size in
                        for stroke in strokes {
                            var path = Path()
                            if let first = stroke.first {
                                path.move(to: first)
                                for point in stroke.dropFirst() {
                                    path.addLine(to: point)
                                }
                            }
                            context.stroke(path, with: .color(.black), lineWidth: 8)
                        }
                    }
                }
                .frame(width: 450, height: 300)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // Si el movimiento es nuevo (inicio del toque), creamos nuevo arreglo
                            if value.translation == .zero {
                                strokes.append([value.location])
                            } else {
                                // Añadimos puntos al último trazo existente
                                if let lastIndex = strokes.indices.last {
                                    strokes[lastIndex].append(value.location)
                                }
                            }
                        }
                )
                
                Spacer()
                
                // Botón de continuar
                NavigationLink {
                    EjercicioLupaView()
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
            speak("Con tu dedo dibuja la palabra \(word)")
        }
    }
    
    func speak(_ text: String) {
        // Detener cualquier audio previo
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: "es-MX")
        u.rate = 0.4
        synthesizer.speak(u)
    }
}

#Preview {
    // Usamos el inicializador correcto para el preview
    WordTracingPala(word: "Pala") {
        print("Finalizado")
    }
}

