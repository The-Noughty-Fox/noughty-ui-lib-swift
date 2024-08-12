import Foundation
import SwiftUI

public struct OnboardingView<Content: View>: View {
    @Environment(\.onboardingViewStyle) var style
    
    @Binding var currentStep: Int
    let screensCount: Int
    let onEndAction: () -> ()
    let content: () -> Content
    
    public init(
        currentStep: Binding<Int>,
        screensCount: Int,
        onEndAction: @escaping () -> Void,
        content: @escaping () -> Content
    ) {
        self._currentStep = currentStep
        self.screensCount = screensCount
        self.onEndAction = onEndAction
        self.content = content
    }
    
    public var body: some View {
        style
            .makeBody(
                configuration: OnboardingConfig(
                    screensCount: screensCount,
                    currentStep: $currentStep,
                    label: OnboardingConfig.Label(content: content()),
                    onEndAction: {
                        onEndAction()
                    }
                )
            )
    }
}

public struct OnboardingConfig {
    let screensCount: Int
    @Binding var currentStep: Int
    let label: OnboardingConfig.Label
    let onEndAction: () -> ()
    
    struct Label: View {
        public init<Content: View>(content: Content) {
            body = AnyView(content)
        }
        
        public var body: AnyView
    }
}

public protocol OnboardingViewStyle {
    associatedtype Body: View
    typealias Configuration = OnboardingConfig
    
    func makeBody(configuration: Self.Configuration) -> Body
}

public struct AnyOnboardingStyle: OnboardingViewStyle {
    
    private var _makeBody: (Configuration) -> AnyView
    
    public init<S: OnboardingViewStyle>(style: S) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

public extension EnvironmentValues {
    var onboardingViewStyle: AnyOnboardingStyle {
        get { self[OnboardingViewStyleKey.self] }
        set { self[OnboardingViewStyleKey.self] = newValue }
    }
}

public struct OnboardingViewStyleKey: EnvironmentKey {
    public static let defaultValue = AnyOnboardingStyle(style: DefaultOnboardingStyle())
}

public extension View {
    func onboardingStyle<S: OnboardingViewStyle>(_ style: S) -> some View {
        environment(\.onboardingViewStyle, AnyOnboardingStyle(style: style))
    }
}
