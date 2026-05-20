import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var isLoading = false
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
            WebView(url: targetURL, isLoading: $isLoading, showError: $showError)
                .ignoresSafeArea()

            if isLoading {
                ProgressView()
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(Color(red: 0, green: 0.898, blue: 1.0))
                    .frame(maxWidth: .infinity, maxHeight: 3)
            }
        }
        .alert("خطأ في الاتصال", isPresented: $showError) {
            Button("إعادة المحاولة") { showError = false }
            Button("إلغاء", role: .cancel) {}
        } message: {
            Text("تعذّر الاتصال. تحقق من اتصالك بالإنترنت.")
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.1)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 280)

                Text("هويتك الرقمية في رابط واحد")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Spacer()

                ProgressView()
                    .tint(Color(red: 0, green: 0.75, blue: 1.0))
                    .scaleEffect(1.2)
                    .padding(.bottom, 50)
            }
            .padding(.horizontal, 32)
        }
    }
}
