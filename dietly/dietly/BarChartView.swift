
import SwiftUI

struct BarChartView: View {
    var data: [Double]

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 10) {
                ForEach(0..<data.count, id: \.self) { index in
                    BarView(value: normalizedValue(index: index), day: getDayOfWeek(index: index))
                        .frame(width: (geometry.size.width - 60) / CGFloat(data.count), height: CGFloat(data[index] * 200))
                }
            }
        }
    }

    func normalizedValue(index: Int) -> Double {
        let maxValue = data.max() ?? 1
        return data[index] / maxValue
    }

    func getDayOfWeek(index: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        let day = Calendar.current.date(byAdding: .day, value: -index, to: Date())!
        return formatter.string(from: day)
    }
}

struct BarView: View {
    var value: Double
    var day: String

    var body: some View {
        VStack {
            Text(String(format: "%.0f", value * 1000)) // Ajuste ici si tu veux afficher les calories
                .font(.caption)
            Rectangle()
                .fill(Color.blue) // La couleur des barres peut être modifiée
                .frame(height: CGFloat(value * 200)) // Ajuster la hauteur des barres
            Text(day)
                .font(.caption)
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(data: [100, 200, 150, 300, 100, 250, 350])
            .frame(height: 200)
    }
}
