import Foundation
import SwiftUI

protocol OnboardingViewStyle {
    associatedtype Body: View
    typealias Configuration = OnboardingConfig
}
