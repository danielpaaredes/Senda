//
//  EjercicioPeloView.swift
//  Senda
//
//  Created by Citlalli Jaramar Lopez Medina on 22/04/26.
//

import SwiftUI
import AVFoundation

struct EjercicioPeloView: View {
    // 1. Datos del ejercicio (haz que tu asset se llame "lupa_img" en blanco y negro)
    let imagenNombre: String = "pelo"
    let wordText: String = "Pelo"
    let wordSound: String = "Pelo"
    
    let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        ZStack {
            // Fondo usando tu color personalizado
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                // Barra Superior: Home
                HStack {
                    Button(action: {
                        // Acción para volver (dismiss o navigation)
                    }) {
                        Image(systemName: "house.fill")
                            .font(.title3) // Tamaño más controlado
                            .padding(15)
                            .background(Color.yellowa)
                            .cornerRadius(15)
                    }
                    .foregroundColor(Color.typography)
                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                Spacer() // Empuja el contenido principal al centro
                
                // --- CONTENIDO PRINCIPAL ---
                // Usamos Spacers estratégicos para un layout balanceado
                HStack {
                    
                    Spacer() // Margen izquierdo
                    
                    // Lado Izquierdo: La Ilustración (con corner radius limpio, sin fondo)
                    Image(imagenNombre)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280) // Tamaño unificado y digno
                        .background(Color.white) // Fondo blanco para la ilustración
                        .cornerRadius(35) // Bordes redondeados directos a la imagen
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    
                    Spacer(minLength: 50) // Espacio entre imagen y controles
                    
                    // Lado Derecho: Controles y Texto (con layout controlado)
                    VStack(alignment: .leading, spacing: 15) {
                        
                        // Botón de Bocina (Grande pero proporcional)
                        Button(action: {
                            speak(wordSound)
                        }) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 50)) // Icono más legible
                                .foregroundColor(Color.typography)
                                .frame(width: 120, height: 120) // Frame fijo para control
                                .background(Color.yellowa)
                                .cornerRadius(25)
                        }
                        
                        // Texto de la palabra (Digno, grande y legible)
                        Text(wordText)
                            // Reduje el tamaño y agregué controles de legibilidad
                            .font(.system(size: 80, weight: .medium, design: .rounded))
                            .foregroundColor(Color.typography)
                            .lineLimit(1) // No se corta en varias líneas
                            .minimumScaleFactor(0.5) // Se escala si es muy larga la palabra
                            .padding(.leading, 10)
                    }
                    
                    Spacer() // Empuja el botón siguiente a la derecha
                    
                    // Botón Siguiente (Flecha lateral)
                    NavigationLink(destination: EjercicioLupa()) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(Color.typography)
                            .frame(width: 120, height: 80) // Frame controlado
                            .background(Color.yellowa)
                            .cornerRadius(25)
                    }
                    
                    Spacer() // Margen derecho
                }
                // .padding(.horizontal, 60) // Eliminamos este padding fijo, los Spacers lo resuelven mejor
                
                Spacer() // Empuja el contenido principal al centro
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // Función de voz consistente con tus otros archivos
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.35 // Un poquito más lento para mayor claridad
        synthesizer.speak(utterance)
    }
}

// Preview para asegurarnos que se ve bien en horizontal
#Preview {
    EjercicioPeloView()
        .previewInterfaceOrientation(.landscapeLeft)
}
