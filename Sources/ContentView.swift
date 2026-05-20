import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var isLoading = false
    @State private var error: Error?
    @State private var showError = false

    private let targetURL = URL(string: "https://link.my-zone.space")!

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeOut(duration: 0.4)) {
                                showSplash = false
                            }
                        }
                    }
            } else {
                mainView
            }
        }
    }

    var mainView: some View {
        ZStack(alignment: .top) {
            WebView(url: targetURL, isLoading: $isLoading, error: $error)
                .ignoresSafeArea()
                .onChange(of: error) { newError in
                    showError = newError != nil
                }

            if isLoading {
                ProgressView()
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#00E5FF")))
                    .frame(height: 3)
            }
        }
        .alert("Connection Error", isPresented: $showError) {
            Button("Retry") {
                error = nil
                showError = false
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Unable to connect. Please check your internet connection.")
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(hex: "#0D0D1A")
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280)

                Text("هويتك الرقمية في رابط واحد")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Spacer()

                ProgressView()
                    .tint(Color(hex: "#00BFFF"))
                    .scaleEffect(1.2)
                    .padding(.bottom, 50)
            }
            .padding(.horizontal, 32)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
