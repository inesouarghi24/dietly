
import Foundation
import CoreData

func addWeightLog(for user: User, currentWeight: Double, context: NSManagedObjectContext) {
    let weightLog = WeightLog(context: context)
    weightLog.currentWeight = currentWeight
    weightLog.date = Date()

   
    user.addToWeightLogs(weightLog)
    
    do {
        try context.save()
        print("WeightLog sauvegardé avec succès")
    } catch {
        print("Erreur lors de la sauvegarde : \(error.localizedDescription)")
    }
}


func addCalorieLog(for user: User, calories: Double, foodItems: String, context: NSManagedObjectContext) {
    let calorieLog = CalorieLog(context: context)
    calorieLog.calories = calories
    calorieLog.date = Date()
    calorieLog.foodItems = foodItems

    
    user.addToCalorieLogs(calorieLog)
    
    do {
        try context.save()
        print("CalorieLog sauvegardé avec succès")
    } catch {
        print("Erreur lors de la sauvegarde : \(error.localizedDescription)")
    }
}
