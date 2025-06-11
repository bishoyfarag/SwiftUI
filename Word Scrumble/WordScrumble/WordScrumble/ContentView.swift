//
//  ContentView.swift
//  WordScramble
//
//  Created by Bishoy Farag on 3/1/24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
  
  
  var body: some View {
      NavigationStack {
          List {
              Section {
                  TextField("Enter your word", text: $newWord)
                      .textInputAutocapitalization(.never)
              }
              
              Section {
                  ForEach(usedWords, id: \.self) { word in
                      HStack {
                          Image(systemName: "\(word.count).circle")
                          Text(word)
                      }
                  }
              }
          }
          .navigationTitle(rootWord)
          .onSubmit(addNewWord)
          .onAppear(perform: startGame)
          .alert(errorTitle, isPresented: $showingError) {
              Button("Ok") { }
              
          } message: {
              Text(errorMessage)
          }
          
          
          .toolbar {
              ToolbarItem(placement: .navigationBarTrailing) {
                  Button("New Game") {
                      startGame()
                      score = 0
                      usedWords.removeAll()
                  }
              }
          }
          .safeAreaInset(edge: .bottom) {
              Text("Score: \(score)")
                  .font(.title)
                  .padding()
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
                  .padding()
                  .background(.blue)
          }
      }
  }
    
    func addNewWord() {
      let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
      
      guard answer.count > 0 else { return }
      
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You cant spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You cant just make them up, you know!")
            return
        }
        
        guard threeOrMore(word: answer) else {
            wordError(title: "Word is less than 3 letters", message: "Use a word that has more than 3 letters")
            return
        }
        
        guard isSameRootWord(word: answer) else {
            wordError(title: "Nice try...", message: "The answer cannot be the question")
            return
        }
        
        incScore(word: answer)
      
      withAnimation {
        usedWords.insert(answer, at: 0)
      }
      newWord = ""
    }
    
    func startGame() {
      if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
        if let startWords = try? String(contentsOf: startWordsURL) {
          let allWords = startWords.components(separatedBy: "\n")
          
          rootWord = allWords.randomElement() ?? "silkworm"
          
          return
        }
      }
      fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
      !usedWords.contains(word)
    }

    func isPossible(word: String) -> Bool {
      var tempWord = rootWord

      for letter in word {
        if let pos = tempWord.firstIndex(of: letter) {
          tempWord.remove(at: pos)
        } else {
          return false
        }
      }
        return true
    }
      
      func isReal(word: String) -> Bool {
          let checker = UITextChecker()
          let range = NSRange(location: 0, length: word.utf16.count)
          let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
          return misspelledRange.location == NSNotFound
      }
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func threeOrMore(word: String) -> Bool {
        var isAllowed = false
        if word.count >= 3 {
            isAllowed = true
        }
        else {
            isAllowed = false
        }
        return isAllowed
    }
    
    func isSameRootWord(word: String) -> Bool {
        return word != rootWord
    }
    
    func incScore(word: String) {
        score = score + word.count
    }
    
}

#Preview {
    ContentView()
}
