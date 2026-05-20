import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var showError: Bool

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        init(_ parent: WebView) { self.parent = parent }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
            parent.isLoading = true
            parent.showError = false
        }

        func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
            parent.isLoading = false
        }

        func webView(_ webView: WKWebView, didFail _: WKNavigation!, withError _: Error) {
            parent.isLoading = false
            parent.showError = true
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError _: Error) {
            parent.isLoading = false
            parent.showError = true
        }
    }
}
