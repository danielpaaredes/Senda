import SwiftUI
import AVFoundation

struct LeccionesSimuladasView: View {
    let synthesizer = AVSpeechSynthesizer()
    
    // Color FFBF00
    let yellowa = Color(red: 1.0, green: 0.749, blue: 0.0)
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.96).ignoresSafeArea()
            
            HStack(spacing: 60) {
                
                // --- TARJETA 1: PALA (TERMINADA) ---
                VStack(spacing: 0) {
                    ZStack {
                        Image("pala")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 320, height: 280)
                            .clipped()
                        
                        yellowa.opacity(0.8)
                            .frame(width: 320, height: 280)
                        
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.75))
                                .frame(width: 130, height: 130)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 65, weight: .black))
                                .foregroundColor(yellowa)
                        }
                    }
                    .frame(height: 280)
                    
                    Text("Pala")
                        .font(.system(size: 45, weight: .bold)) // Fuente de sistema
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 90)
                        .background(Color.white)
                }
                .frame(width: 320)
                .cornerRadius(35)
                .overlay(RoundedRectangle(cornerRadius: 35).stroke(yellowa, lineWidth: 6))
                .shadow(color: .black.opacity(0.1), radius: 15)

                // --- TARJETA 2: PIÑATA (ACTIVA) ---
                VStack(spacing: 0) {
                    ZStack {
                        Image("pinata")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 320, height: 280)
                            .clipped()
                    }
                    .frame(height: 280)
                    
                    Text("Piñata")
                        .font(.system(size: 45, weight: .bold)) // Fuente de sistema
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 90)
                        .background(Color.white)
                }
                .frame(width: 320)
                .cornerRadius(35)
                .overlay(RoundedRectangle(cornerRadius: 35).stroke(yellowa, lineWidth: 6))
                .shadow(color: .black.opacity(0.1), radius: 15)
            }
            .padding(40)
        }
        .navigationBarBackButtonHidden(false)
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
