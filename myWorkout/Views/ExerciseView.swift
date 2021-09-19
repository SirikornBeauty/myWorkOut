//
//  ExerciseView.swift
//  myWorkout
//
//  Created by Smart on 19/9/2564 BE.
//

import SwiftUI
import AVKit

struct ExerciseView: View {
    @AppStorage("rating") private var rating = 0
    @AppStorage("checkExercise") private var checkExercise = String(repeating: "0", count: Exercise.exercises.count)
    @State private var showHistory = false
    @State private var showSuccess = false
    
    @Binding var selectedTab: Int
    
    let index: Int
    
    @State private var timerDone = false
    @State private var showTimer = false
    
    @EnvironmentObject var history: HistoryStore
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HeaderView(selectedTab: $selectedTab, titleText:  Exercise.exercises[index].exerciseName)
                if let url = Bundle.main.url(forResource: Exercise.exercises[index].videoName, withExtension: "mp4") {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(height: geometry.size.height * 0.45)
                        .padding()
                } else {
                    Text("Couldn't find \(Exercise.exercises[index].videoName).mp4")
                        .foregroundColor(.red)
                }
                
                HStack(spacing: 150) {
                    Button(NSLocalizedString("Start", comment: "begin exercise")) { showTimer.toggle() }
                    
                    Button(NSLocalizedString("Done", comment: "mark as finished")) {
                        history.addDoneExercise(Exercise.exercises[index].exerciseName)
                        timerDone = false
                        showTimer.toggle()
                        done(selectedTab: selectedTab)
                        if lastExercise {
                            checkExercise = String(repeating: "0", count: Exercise.exercises.count)
                            showSuccess.toggle()
                        } else {
                            selectedTab = recursiveFind()
                        }
                    }
                    .disabled(!timerDone)
                    .sheet(isPresented: $showSuccess, content: {
                        SuccessView(selectedTab: $selectedTab)
                    })
                }
                .font(.title3)
                .padding(.top)
                
                
                if showTimer {
                    TimerView(timerDone: $timerDone)
                }
                
                Spacer()
                
                RatingView(exerciseIndex: index)
                    .padding()
                
                Button(NSLocalizedString("History", comment: "view user activity")) { showHistory.toggle() }
                    .padding(.bottom)
                    .sheet(isPresented: $showHistory, content: {
                        HistoryView(showHistory: $showHistory)
                    })
            }
        }
    }
    
    var lastExercise: Bool {
        checkExercise == String(repeating: "1", count: Exercise.exercises.count)
    }
    
    private func done(selectedTab: Int) {
        let index = checkExercise.index(
            checkExercise.startIndex,
            offsetBy: selectedTab
        )
        checkExercise.replaceSubrange(index...index, with: String(1))
    }
    
    private func recursiveFind() -> Int {
        if selectedTab + 1 > Exercise.exercises.count {
            selectedTab = 0
        }
        
        let index = checkExercise.index(
            checkExercise.startIndex,
            offsetBy: selectedTab
        )
        
        let character = checkExercise[index]
        
        if "\(character.wholeNumberValue ?? 1)" == "0" {
            return selectedTab
        }
        selectedTab += 1
        return recursiveFind()
        
    }
    
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView(selectedTab: .constant(1), index: 0)
            .environmentObject(HistoryStore())
    }
}
