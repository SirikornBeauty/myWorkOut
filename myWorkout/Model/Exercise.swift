//
//  Exercise.swift
//  myWorkout
//
//  Created by Smart on 19/9/2564 BE.
//

import Foundation

struct Exercise {
    let exerciseName: String
    let videoName: String
    
    enum ExerciseEnum: String {
        case squat = "Squat"
        case jumpRope = "Jump Rope"
        case burpee = "Burpee"
        case sunSalute = "Sun Salute"
    }
}

extension Exercise {
    static let exercises = [
        Exercise(exerciseName: ExerciseEnum.squat.rawValue, videoName: "squat"),
        Exercise(exerciseName: ExerciseEnum.jumpRope.rawValue, videoName: "jump-rope"),
        Exercise(exerciseName: ExerciseEnum.burpee.rawValue, videoName: "burpee"),
        Exercise(exerciseName: ExerciseEnum.sunSalute.rawValue, videoName: "sun-salute")]
}
