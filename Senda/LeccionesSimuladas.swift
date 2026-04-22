//
//  LeccionesSimuladas.swift
//  Senda
//
//  Created by Daniel Paredes on 22/04/26.
//

import SwiftUI
import AVFoundation

struct LeccionesSimuladasView: View {
    let synthesizer = AVSpeechSynthesizer()
    
    // --- DEFINICIÓN DEL COLOR HEXADECIMAL FFBF00 ---
    let yellowa = Color(red: 1.0, green: 0.749, blue: 0.0) // Esto es #FFBF00
    
    var body: some View {
        ZStack {
            // Fondo gris claro de la App
            Color(red: 0.96, green: 0.96, blue: 0.96).ignoresSafeArea()
            
            HStack(spacing: 60) {
                
                // --- TARJETA 1: PALA (CON CAPAS Y PALOMITA) ---
                VStack(spacing: 0) {
                    ZStack {
                        // Imagen de fondo que llena el recuadro
                        Image("pala")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 320, height: 280)
                            .clipped()
                        
                        // Capa yellowa con opacidad sobre la imagen
                        yellowa
                            .opacity(0.8)
                            .frame(width: 320, height: 280)
                        
                        // Círculo negro con opacidad y palomita yellowa
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.75))
                                .frame(width: 130, height: 130)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 65, weight: .black))
                                .foregroundColor(yellowa) // Usando la constante
                        }
                    }
                    .frame(height: 280)
                    
                    Text("Pala")
                        .font(.custom("Lexend-Bold", size: 45))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 90)
                        .background(Color.white)
                }
                .frame(width: 320)
                .cornerRadius(35)
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(yellowa, lineWidth: 6) // Borde con el color exacto
                )
                .shadow(color: .black.opacity(0.1), radius: 15)

                // --- TARJETA 2: PIÑATA (LIMPIA) ---
                VStack(spacing: 0) {
                    ZStack {
                        // Imagen de fondo que llena el recuadro
                        Image("pinata")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 320, height: 280)
                            .clipped()
                    }
                    .frame(height: 280)
                    
                    Text("Piñata")
                        .font(.custom("Lexend-Bold", size: 45))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 90)
                        .background(Color.white)
                }
                .frame(width: 320)
                .cornerRadius(35)
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(yellowa, lineWidth: 6) // Borde con el color exacto
                )
                .shadow(color: .black.opacity(0.1), radius: 15)
            }
            .padding(40)
        }
        .onAppear {
            speakInstrucciones()
        }
    }
    
    func speakInstrucciones() {
        let texto = "Este es tu camino de lecciones. Las que tienen una palomita negra son las que ya terminaste. Pulsa en la siguiente para continuar aprendiendo."
        let utterance = AVSpeechUtterance(string: texto)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.38
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
}
#Preview {
    LeccionesSimuladasView()
}
