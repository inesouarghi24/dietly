import SwiftUI
import UserNotifications

struct RemindersView: View {
    @State private var waterReminderInterval: Int = 1 // Intervalle pour le rappel d'eau (1 heure ou 2 heures)
    @State private var mealReminderTimes: [Date] = [Date()]
    @State private var newMealReminderTime = Date()
    @State private var weighInReminderInterval: Int = 7
    @State private var showWeightReminderPicker = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Rappels et notifications")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)
                
                // Section du rappel d'eau
                VStack(spacing: 15) {
                    Text("Rappel pour boire de l'eau")
                        .font(.headline)
                    
                    Picker("Intervalle des rappels", selection: $waterReminderInterval) {
                        Text("Toutes les heures").tag(1)
                        Text("Toutes les 2 heures").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Button(action: {
                        requestNotificationPermission()
                        scheduleWaterReminder(interval: waterReminderInterval)
                    }) {
                        Text("Activer le rappel d'hydratation")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                VStack(spacing: 15) {
                    Text("Rappels pour les repas")
                        .font(.headline)
                    
                    DatePicker("Ajouter une heure de rappel", selection: $newMealReminderTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                    
                    Button(action: {
                        requestNotificationPermission()
                        mealReminderTimes.append(newMealReminderTime)
                        scheduleMealReminder(at: newMealReminderTime)
                    }) {
                        Text("Ajouter un rappel de repas")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    // Liste des rappels de repas
                    List {
                        ForEach(mealReminderTimes, id: \.self) { time in
                            Text("Rappel à : \(time, formatter: timeFormatter)")
                                .font(.subheadline)
                        }
                        .onDelete(perform: deleteReminder)
                    }
                    .frame(height: 150)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                VStack(spacing: 15) {
                    Text("Rappel pour se peser")
                        .font(.headline)
                    
                    HStack {
                        Text("Tous les ")
                            .font(.subheadline)
                        
                        Picker("Intervalle des rappels", selection: $weighInReminderInterval) {
                            ForEach(1..<31) { day in
                                Text("\(day) jours").tag(day)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 80)
                        .clipped()
                        
                        Text(" jours")
                            .font(.subheadline)
                    }
                    
                    Button(action: {
                        requestNotificationPermission()
                        scheduleWeighInReminder(intervalInDays: weighInReminderInterval)
                    }) {
                        Text("Activer le rappel de pesée")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                Button(action: {
                    removeAllNotifications()
                }) {
                    Text("Supprimer tous les rappels")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Erreur lors de la demande d'autorisation: \(error)")
            }
            if granted {
                print("Autorisation de notifications accordée")
            } else {
                print("Autorisation de notifications refusée")
            }
        }
    }

    // Fonction pour planifier les rappels d'hydratation toutes les 1 ou 2 heures
    func scheduleWaterReminder(interval: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Rappel"
        content.body = "N'oublie pas de boire de l'eau !"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(interval * 3600), repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)

        print("Rappel d'eau activé toutes les \(interval) heures")
    }

    // Fonction pour planifier les rappels de repas à des heures précises
    func scheduleMealReminder(at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Rappel"
        content.body = "C'est l'heure de manger !"

        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)

        print("Rappel de repas ajouté pour \(timeFormatter.string(from: time))")
    }

    // Fonction pour planifier le rappel de pesée tous les X jours
    func scheduleWeighInReminder(intervalInDays: Int) {
        let content = UNMutableNotificationContent()
        content.title = "C'est l'heure de se peser !"
        content.body = "N'oubliez pas de vous peser aujourd'hui pour suivre votre progression."
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(intervalInDays * 86400), repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)

        print("Rappel de pesée activé tous les \(intervalInDays) jours")
    }

    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Tous les rappels ont été supprimés.")
    }

    func deleteReminder(at offsets: IndexSet) {
        let identifiers = offsets.map { mealReminderTimes[$0].description }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        mealReminderTimes.remove(atOffsets: offsets)
        print("Rappel supprimé.")
    }

    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
    }
}
