//
//  DataMethods.swift
//  CPSC491
//
//  Created by Allan Cortes on 2/23/24.
//

import Foundation
import CoreData



final class DataHandler:ObservableObject {

    let container = NSPersistentContainer(name:"FoodModel")
    
    init(){
        
        container.loadPersistentStores { desc, error in
            if let error = error {
                
                print("Failure to grab data \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
   
    func save(context: NSManagedObjectContext){
        do{
            try context.save()
        }catch{
            print("error")
        }
    }
    

    func addFood(name:String, cal: Double, protein:String, carb:String, fat:String,mealType:String,context:NSManagedObjectContext){
        let food = FoodInfo(context: context)
        food.id = UUID()
        food.date = Date()
        food.name = name
        food.cal = cal
        food.protein = protein
        food.carb = carb
        food.fat = fat
        food.mealType = mealType

        
        save(context: context)
        
    }
    
    
    func editFood(food:FoodInfo,name:String,cal:Double, protein:String, carb:String, fat:String,context: NSManagedObjectContext){
        
        food.date = Date()
        food.name = name
        food.cal = cal
        food.protein = protein
        food.carb = carb
        food.fat = fat
        
        save(context: context)

    }
    
    
    func setCalGoal(goal:String, context:NSManagedObjectContext){
        
        
        let User = UserInfo(context: context)
        User.calGoal = goal
        User.id = UUID()
        User.date = Date()
        
        save(context: context)

        
    }
  
    func addExercise(name:String, Reps:String, Weight:String, Total:String,context:NSManagedObjectContext){
        let exercise = GymInfo(context: context)
        exercise.date = Date()
        exercise.name = name
        exercise.reps = Reps
        exercise.weight = Weight
        exercise.setTotal = Total

        save(context: context)
        
    }
    
    func updateExercise(exercise:GymInfo,name:String, Reps:String, Weight:String, Total:String,context:NSManagedObjectContext){
        exercise.date = Date()
        exercise.name = name
        exercise.reps = Reps
        exercise.weight = Weight
        exercise.setTotal = Total

        save(context: context)
        
    }
    
    
    func addRoutine(title:String, exercise:String, context:NSManagedObjectContext){
        let r = Routine(context:context)
        r.exercise = exercise
        r.title = title
        r.date = Date()

        save(context: context)
        
    }
    
    func addRoutineTitleOnly(title:String,context:NSManagedObjectContext){
        let r = Routine(context:context)
        r.title = title
        r.date = Date()

        save(context: context)
        
    }

    
  
    
    

}
