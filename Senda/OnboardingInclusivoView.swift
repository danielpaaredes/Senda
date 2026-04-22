//
//  OnboardingInclusivoView.swift
//  Senda
//
//  Created by Daniel Paredes on 22/04/26.
//

import SwiftUI
import AVFoundation

struct OnboardingInclusivoView: View {
    let synthesizer = AVSpeechSynthesizer()
    @State private var step = 0
    
    // --- ESTADO PARA LA ANIMACIÓN ---
    @State private var isPulsing = false
    
    let instrucciones = [
        "Escucha mis instrucciones con atención.",
        "Mira el botón amarillo con la casita negra. Úsalo para ver tu menú de lecciones.",
        "Tus lecciones terminadas tendrán una palomita negra. ¡Así sabrás cuánto has avanzado!",
        "Cuando hayas terminado tu ejercicio, deberás presionar el botón con la flecha negra para pasar a la siguiente seccion. ¡Empecemos!"
    ]
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("Bienvenido a Senda")
                    .font(.system(size: 45, weight: .bold, design: .rounded))
                    .foregroundColor(Color.typography)
                    .padding(.top, 40)
                
                Spacer()
                
                HStack(spacing: 60) {
                    
                    ExplicacionIconoView(
                        imageName: "house.fill",
                        isHighlighted: step >= 1,
                        color: Color.yellowa
                    )
                    
                    ExplicacionIconoView(
                        imageName: "checkmark.circle.fill",
                        isHighlighted: step >= 2,
                        color: Color.yellowa
                    )
                    
                    ExplicacionIconoView(
                        imageName: "arrow.right",
                        isHighlighted: step >= 3,
                        color: Color.yellowa
                    )
                }
                
                Spacer()
                
                // --- BOTÓN DE AVANCE CON ANIMACIÓN DE PULSACIÓN ---
                Button(action: {
                    // Al presionar, detenemos la animación para dar feedback visual de 'toque'
                    withAnimation(.easeOut(duration: 0.2)) {
                        isPulsing = false
                    }
                    
                    if step < instrucciones.count - 1 {
                        step += 1
                        speak(instrucciones[step])
                    } else {
                        // Navegación al ejercicio
                    }
                }) {
                    Image(systemName: "hand.point.up.fill")
                        .font(.system(size: 55, weight: .bold))
                        .foregroundColor(Color.typography)
                        .frame(width: 220, height: 110)
                        .background(Color.yellowa)
                        .cornerRadius(40)
                        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                        
                        // --- APLICACIÓN DE LA ANIMACIÓN ---
                        // Cambiamos la opacidad y la escala suavemente
                        .opacity(isPulsing ? 0.6 : 1.0)
                        .scaleEffect(isPulsing ? 0.95 : 1.0)
                        
                        // Animación implícita que se repite para siempre
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: isPulsing
                        )
                }
                .padding(.bottom, 70)
            }
        }
        .onAppear {
            speak(instrucciones[0])
            
            // --- INICIAMOS LA ANIMACIÓN AL APARECER LA VISTA ---
            // Usamos un pequeño delay para que no empiece de golpe
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    isPulsing = true
                }
            }
        }
    }
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.35
        utterance.volume = 1.0
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
}

// Subvista para los iconos explicativos (sin cambios)
struct ExplicacionIconoView: View {
    let imageName: String
    let isHighlighted: Bool
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: 70, weight: .bold))
                .foregroundColor(isHighlighted ? Color.typography : Color.typography.opacity(0.2))
                .frame(width: 170, height: 170)
                .background(isHighlighted ? color : Color.gray.opacity(0.1))
                .cornerRadius(45)
                .shadow(color: .black.opacity(isHighlighted ? 0.1 : 0), radius: 10)
        }
    }
}
#Preview {
    OnboardingInclusivoView()
}
