//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by csuftitan on 2/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var i = 1
    @State private var msg = ""
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.3), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) {number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if i < 9 {
                Button(msg, action: askQuestion)
            } else {
                Button("Restart Game") {
                    i = 0
                    score = 0
                    askQuestion()
                }
            }
        }
        
    message: {
        if i < 9 {
            Text("Your score is \(score)")
        }
        else {
            Text("Your final score is \(score)")
        }
        }
    }
    
    func flagTapped(_ number:Int){
        if number == correctAnswer {
            msg = "Continue"
            scoreTitle = "Correct"
            score += 1
        } else {
            msg = "Continue"
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
        }
        
        showingScore = true
        i += 1
    }

    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
