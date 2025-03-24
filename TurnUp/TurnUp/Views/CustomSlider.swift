import SwiftUI

struct CustomSlider: View {
    @State private var value: CGFloat = 0.6

    let barWidth: CGFloat = 300
    let barHeight: CGFloat = 30

    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: barWidth, height: barHeight)

                Capsule()
                    .fill(Color(red: 172/255, green: 233/255, blue: 250/255)) // #ACE9FA
                    .frame(width: barWidth * value, height: barHeight)

                Circle()
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
                    .offset(x: barWidth * value - 12)
                    .gesture(
                        DragGesture()
                            .onChanged { drag in
                                let newValue = min(max(0, drag.location.x / barWidth), 1)
                                value = newValue
                            }
                    )
            }

            Text("2:\(String(format: "%02.0f", value * 55))")
                .font(.system(size: 18, weight: .bold))
        }
        .padding(.top, 360)
    }
}

#Preview {
    CustomSlider()
}
