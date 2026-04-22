//
//  EjercicioLupaView.swift
//  Senda
//
//  Created by Citlalli Jaramar Lopez Medina on 22/04/26.
//
import SwiftUI
import AVFoundation

struct EjercicioLupaView: View {
    
    let imagenNombre: String = "lupa"
    let wordText: String = "Lupa"
    let wordSound: String = "Lupa"
    
    let synthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background").ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                        Button { } label: {
                            Image(systemName: "house.fill")
                                .padding(15)
                                .background(Color.yellowa)
                                .cornerRadius(15)
                        }
                        .foregroundColor(.typography)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        
                        Image(imagenNombre)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280, height: 280)
                            .background(Color.white)
                            .cornerRadius(35)
                        
                        Spacer(minLength: 50)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            
                            Button {
                                speak(wordSound)
                            } label: {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.typography)
                                    .frame(width: 120, height: 120)
                                    .background(Color.yellowa)
                                    .cornerRadius(25)
                            }
                            
                            Text(wordText)
                                .font(.system(size: 80, weight: .medium))
                                .foregroundColor(.typography)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            EjercicioLupa()
                        } label: {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 35, weight: .bold))
                                .foregroundColor(.typography)
                                .frame(width: 120, height: 80)
                                .background(Color.yellowa)
                                .cornerRadius(25)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    func speak(_ text: String) {
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: "es-MX")
        u.rate = 0.35
        synthesizer.speak(u)
    }
}
#Preview {
    EjercicioLupaView()
        .previewInterfaceOrientation(.landscapeLeft)
}
