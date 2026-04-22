//
//  LaunchView.swift
//  Senda
//
//  Created by Citlalli Jaramar Lopez Medina on 22/04/26.
//

import SwiftUI
import AVFoundation

struct LaunchView: View {
    // 1. Synthesizer para la bienvenida
    let synthesizer = AVSpeechSynthesizer()
    
    // 2. Estado para controlar la animación de pulsación del botón
    @State private var isPulsing = false
    
    // 3. Estado para controlar la navegación al Onboarding
    @State private var navigateToOnboarding = false
    
    var body: some View {
        NavigationStack { // Necesario para la navegación
            ZStack {
                // Fondo de la App
                Color("Background").ignoresSafeArea()
                
                VStack(spacing: 50) {
                    Spacer()
                    
                    // --- EL LOGO/ICONO DE LA APP ---
                    // Usamos la variante del App Icon que elegimos para el Pitch: la "S" como camino.
                    // Asegúrense de tener el asset "app_logo" en su proyecto.
                    Image("IconoSenda") // El asset con fondo negro y "S" amarilla
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400) // Grande y digno
                        .cornerRadius(60) // Bordes muy redondeados
                        .shadow(color: .black.opacity(0.15), radius: 15)
                    
                    Spacer()
                    
                    // --- EL BOTÓN GIGANTE CON LA MANITA Y ANIMACIÓN ---
                    Button(action: {
                        // Al presionar, paramos la voz y navegamos
                        synthesizer.stopSpeaking(at: .immediate)
                        navigateToOnboarding = true
                    }) {
                        // Icono de mano apuntando, universalmente intuitivo
                        Image(systemName: "hand.point.up.fill")
                            .font(.system(size: 65, weight: .bold)) // Icono gigante
                            .foregroundColor(Color.typography) // Negro/Oscuro
                            .frame(width: 250, height: 130) // Área de contacto masiva
                            .background(Color.yellowa) // Amarillo vibrante
                            .cornerRadius(45)
                            .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                            
                            // --- APLICACIÓN DE LA ANIMACIÓN DE PULSACIÓN ---
                            // Opacidad y Escala suave para llamar la atención
                            .opacity(isPulsing ? 0.6 : 1.0)
                            .scaleEffect(isPulsing ? 0.96 : 1.0)
                            
                            // Animación implícita que se repite para siempre
                            .animation(
                                Animation.easeInOut(duration: 1.1)
                                    .repeatForever(autoreverses: true),
                                value: isPulsing
                            )
                    }
                    // Destino de la navegación
                    .navigationDestination(isPresented: $navigateToOnboarding) {
                        OnboardingInclusivoView() // Tu onboarding animado y narrado
                    }
                    .padding(.bottom, 80)
                }
            }
            .onAppear {
                // Saludamos al usuario al abrir la app para confirmar que el audio funciona
                speak("¡Hola! Bienvenido a Senda. Presiona el botón amarillo con la manita negra para comenzar.")
                
                // Iniciamos la animación con un pequeño delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        isPulsing = true
                    }
                }
            }
        }
    }
    
    // Función de voz (español de México)
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.38 // Velocidad pausada y clara
        utterance.volume = 1.0 // Volumen máximo
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
}
