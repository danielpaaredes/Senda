//
//  EjercicioPalaView.swift
//  Senda
//
//  Created by Citlalli Jaramar Lopez Medina on 22/04/26.
//
import SwiftUI
import AVFoundation

struct EjercicioPalaView: View {
    
    let imagenNombre: String = "pala"
    let wordText: String = "Pala"
    let wordSound: String = "Pala"
    
    let synthesizer = AVSpeechSynthesizer()
    
    @State private var goToSyllables = false
    
    var body: some View {
        ZStack {
            
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                
                // HOME
                HStack {
                    Button(action: { }) {
                        Image(systemName: "house.fill")
                            .font(.title3)
                            .padding(15)
                            .background(Color.yellowa)
                            .cornerRadius(15)
                    }
                    .foregroundColor(Color.typography)
                    
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
                                .foregroundColor(Color.typography)
                                .frame(width: 120, height: 120)
                                .background(Color.yellowa)
                                .cornerRadius(25)
                        }
                        
                        Text(wordText)
                            .font(.system(size: 80, weight: .medium))
                            .foregroundColor(Color.typography)
                    }
                    
                    Spacer()
                    
                   
                    Button {
                        goToSyllables = true
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(Color.typography)
                            .frame(width: 120, height: 80)
                            .background(Color.yellowa)
                            .cornerRadius(25)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $goToSyllables) {
            EjercicioPala()
        }
    }
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = 0.35
        synthesizer.speak(utterance)
    }
}
#Preview {
    EjercicioPalaView()
        .previewInterfaceOrientation(.landscapeLeft)
}
