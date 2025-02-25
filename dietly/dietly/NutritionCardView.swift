

import SwiftUI

struct NutritionCardView: View {
    var iconName: String
    var label: String
    var value: Double
    var unit: String
    var color: Color

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title)
                .foregroundColor(color)

            VStack(alignment: .leading) {
                Text(label)
                    .font(.headline)
                Text("\(value, specifier: "%.2f") \(unit)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}
