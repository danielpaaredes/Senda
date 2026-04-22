//
//  WordTracingLupa.swift
//  Senda
//
//  Created by Daniel Paredes on 22/04/26.
//

import SwiftUI
import AVFoundation

struct WordTracingLupa: View {
    
    // 🔥 Cambiamos a un arreglo de arreglos de puntos para permitir varios trazos
    @State private var strokes: [[CGPoint]] = []
    private let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack {
                    Text("Lupa")
                        .font(.system(size: 120, weight: .bold))
                        .foregroundColor(.gray.opacity(0.3))
                    
                    // 🔥 Dibujamos cada trazo por separado
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
                .frame(width: 450, height: 300) // Un poco más ancho para la palabra completa
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // Si es el inicio de un toque, creamos un nuevo trazo
                            if value.translation == .zero {
                                strokes.append([value.location])
                            } else {
                                // Si ya se está moviendo, añadimos al último trazo creado
                                if let lastIndex = strokes.indices.last {
                                    strokes[lastIndex].append(value.location)
                                }
                            }
                        }
                )
                
                Spacer()
                
                NavigationLink {
                    EjercicioPeloView()
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
            speak("Con tu dedo dibuja la palabra Lupa")
        }
    }
    
    func speak(_ text: String) {
        // Limpiar audio previo para que no se encime
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}

#Preview {
    WordTracingLupa()
}
