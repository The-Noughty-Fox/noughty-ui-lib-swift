import Foundation
import SwiftUI

public struct DefaultOnboardingStyle: OnboardingViewStyle {
    public func makeBody(configuration: Configuration) -> some View {
        VStack {
            Button {
                configuration.currentStep = configuration.screensCount - 1
            } label: {
                Text("Skip")
            }
            
            configuration.label
            
            HStack {
                ForEach(0..<configuration.screensCount) { item in
                    Rectangle()
                        .frame(width: item == configuration.currentStep ? 20  : 10, height: 10)
                        .cornerRadius(10)
                        .foregroundColor(.purple)
                        .animation(.easeIn, value: configuration.currentStep)
                }
            }
            
            Button {
                if configuration.currentStep == configuration.screensCount - 1  {
                    configuration.onEndAction()
                } else {
                    configuration.currentStep += 1
                }
            } label: {
                Text("Next")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.black)
                    .cornerRadius(10)
            }
        }
    }
}
