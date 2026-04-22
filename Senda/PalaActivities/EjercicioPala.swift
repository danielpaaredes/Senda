//
//  EjercicioPala.swift
//  Senda
//
//  Created by Daniel Paredes on 22/04/26.
//
import SwiftUI
import AVFoundation

struct EjercicioPala: View {
    
    let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Button {} label: {
                        Image(systemName: "house.fill")
                            .padding(12)
                            .background(Color.yellowa)
                            .cornerRadius(12)
                    }
                    .foregroundColor(.typography)
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)

                Spacer()
                
                HStack(spacing: 30) {
                    
                    BotonPala(texto: "Pa", colorBase: .yellowa) {
                        speak("pa")
                    }
                    
                    BotonPala(texto: "la", colorBase: .yellowa) {
                        speak("la")
                    }
                    
                    NavigationLink {
                        WordTracingPala(word: "Pala") {
                            
                        }
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 35, weight: .bold))
                            .frame(width: 120, height: 75)
                            .background(Color.yellowa)
                            .cornerRadius(25)
                            .foregroundColor(.typography)
                    }
                }
                
                Spacer()
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

struct BotonPala: View {
    
    let texto: String
    let colorBase: Color
    let accion: () -> Void
    
    var body: some View {
        Button(action: accion) {
            VStack(spacing: 15) {
                
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 35))
                
                Text(texto)
                    .font(.custom("Lexend-Light", size: 90))
            }
            .foregroundColor(.typography)
            .frame(width: 260, height: 260)
            .background(colorBase.opacity(0.5))
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(colorBase, lineWidth: 3)
            )
        }
    }
}

#Preview {
    EjercicioPala()
}
