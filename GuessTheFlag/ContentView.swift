//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Maraj Hossain on 4/5/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gameCounter = 0

    @State private var isGameOver = false

    @State private var countries = [
        "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US",
    ].shuffled()

    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var correctAnswer = Int.random(in: 0 ... 2)

    @State private var rotationAmount = 0.0

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ],
            center: .top,
            startRadius: 200,
            endRadius: 700)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of: ")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0 ..< 3) { number in
                        Button {
                            withAnimation {
                                flagTapped(number)
                                rotationAmount += 360
                            }
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        }
                        .rotation3DEffect(
                            .degrees(rotationAmount),
                            axis: (x: 0, y: 1, z: 0))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }

        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is  \(score)")
        }
        .alert("Your final score is \(score)", isPresented: $isGameOver) {
            Button("Restart", action: reset)
        } message: {
            Text("Game over!")
        }
    }

    func reset() {
        score = 0
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 10
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])"
        }

        showingScore = true
        gameCounter += 1

        if gameCounter >= 10 {
            showingScore = false
            isGameOver = true
            gameCounter = 0
        }
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
