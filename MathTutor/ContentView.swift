//
//  ContentView.swift
//  MathTutor
//
//  Created by Paul Wagstaff on 2025-11-23.
//

import SwiftUI
import AVFAudio

struct ContentView: View {

    private let emojis: [String] = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    
    @State private var firstNumber: Int = 0
    @State private var secondNumber: Int = 0
    @State private var mathOperator = "+"
    @State private var answer: String = ""
    
    @State private var firstNumberEmojis: String = ""
    @State private var secondNumberEmojis: String = ""
    
    @State private var message: String = ""
    
    @State private var buttonIsDisabled = false
    @State private var textFieldIsDisbabled = false
    
    @FocusState private var textFieldIsFocused: Bool
    
    var body: some View {
        VStack {
            Group {
                Text(firstNumberEmojis)
                Text(mathOperator)
                Text(secondNumberEmojis)
            }
            .font(Font.system(size: 80))
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .animation(.default, value: message)
            
            Spacer()
            Text("\(firstNumber) \(mathOperator) \(secondNumber) =")
                .font(.largeTitle)
                .animation(.default, value: message)
            
            TextField("", text: $answer)
                .keyboardType(.numberPad)
                .font(.largeTitle)
                 .frame(width: 60)
                 .textFieldStyle(.roundedBorder)
                 .overlay {
                     RoundedRectangle(cornerRadius: 5)
                         .stroke(.gray, lineWidth: 2)
                 }
                 .multilineTextAlignment(.center)
                 .focused($textFieldIsFocused)
                 .disabled(textFieldIsDisbabled)
            
            Button("Guess") {
                guard let answerInt = Int(answer) else { return }
                if answerInt == firstNumber + secondNumber {
                    playSound(soundName: "correct")
                    message = "Correct!"
                } else {
                    playSound(soundName: "wrong")
                    message = "Sorry, The correct Answer is '\(firstNumber + secondNumber)'"
                }
                textFieldIsFocused = false
                textFieldIsDisbabled = true
                buttonIsDisabled = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty || buttonIsDisabled)
            
            Spacer()
            
            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .foregroundStyle(message == "Correct!" ? .green : .red)
                .animation(.default, value: message)

            if (!message.isEmpty) {
                Button("Play Again?") {
                    generateNumbers()
                    generateNumberEmojis()
                    textFieldIsDisbabled = false
                    buttonIsDisabled = false
                    answer = ""
                    message = ""
                }
            }
                
        }
        .padding()
        .onAppear() {
            generateNumbers()
            generateNumberEmojis()
        }
    }
    func generateNumbers() {
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)

    }
    func generateNumberEmojis() {
        firstNumberEmojis = String(repeating: emojis.randomElement() ?? "🤷‍♂️", count: firstNumber)
        secondNumberEmojis = String(repeating: emojis.randomElement() ?? "👾", count: secondNumber)
    }
    

    @State private var audioPlayer: AVAudioPlayer!
    func playSound(soundName: String) {
        if (audioPlayer != nil && audioPlayer.isPlaying) {
            audioPlayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer")
        }
    }
}

#Preview {
    ContentView()
}
