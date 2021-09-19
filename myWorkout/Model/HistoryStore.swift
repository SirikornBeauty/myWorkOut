//
//  HistoryStore.swift
//  myWorkout
//
//  Created by Smart on 19/9/2564 BE.
//

import Foundation

struct ExerciseDay: Identifiable {
    let id = UUID()
    let date: Date
    var exercises: [String]
}

class HistoryStore: ObservableObject {
    @Published var exerciseDays: [ExerciseDay] = []
    
    init() {
        #if DEBUG
        //        createDevDate()
        #endif
        
        load()
    }
    
    func addDoneExercise(_ exerciseName: String) {
        if !checkExercise(exerciseName: exerciseName) {
            let today = Date()
            if let firstDate = exerciseDays.first?.date, today.isSameDay(as: firstDate) {
                exerciseDays[0].exercises.append(exerciseName)
            } else {
                exerciseDays.insert(
                    ExerciseDay(date: today, exercises: [exerciseName]),
                    at: 0
                )
            }
            
            save()
        }
    }

    func load() {
        guard let dataURL = getURL() else {
            print("Cannot get file url.")
            return
        }
        
        do {
            let data = try Data(contentsOf: dataURL)
            let plistData = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
            let convertedPlistData = plistData as? [[Any]] ?? []
            exerciseDays = convertedPlistData.map {
                ExerciseDay(date: $0[1] as? Date ?? Date(), exercises: $0[2] as? [String] ?? [])
            }
        } catch {
            print("Error loading file.")
        }
    }
    
    func save() {
        guard let dataURL = getURL() else {
            print("Cannot get file url.")
            return
        }
        
        let plistData = exerciseDays.map { [$0.id.uuidString, $0.date, $0.exercises] }
        
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: plistData, format: .binary, options: .zero)
            try data.write(to: dataURL, options: .atomic)
        } catch {
            print("Cannot save file.")
        }
    }
    
    func getURL() -> URL? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return documentsURL.appendingPathComponent("history.plist")
    }
    
    func checkExercise(exerciseName: String) -> Bool {
        let find = exerciseDays.first?.exercises.filter({ $0 == exerciseName })
        if find?.first == exerciseName {
            return true
        } else {
            return false
        }
    }
}
