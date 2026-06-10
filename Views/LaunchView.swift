import SwiftUI

struct LaunchView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.95, blue: 0.91), Color(red: 0.97, green: 0.87, blue: 0.75)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                Image("launchIllustration")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 190)
                    .clipShape(RoundedRectangle(cornerRadius: 28))

                Text("Sake Finder")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)

                Text("Discover Nagano sake spots with a refined, elegant browse.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                ProgressView()
                    .tint(.orange)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1.2))
            withAnimation(.easeInOut) {
                isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            SakeListView()
        }
    }
}
