import UIKit
import Combine

class UIControlEventSubscription<S: Subscriber, Control: UIControl>: Subscription where S.Input == Control {
    let control: Control
    var subscriber: S?

    public init(subscriber: S, control: Control, event: Control.Event) {
        self.subscriber = subscriber
        self.control = control

        control.addTarget(self, action: #selector(action), for: event)
    }

    @objc
    func action() {
        _ = subscriber?.receive(control)
    }

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
        subscriber = nil
    }
}

public struct UIControlEventPublisher<Control: UIControl>: Publisher {
    public typealias Output = Control
    public typealias Failure = Never

    let control: Control
    let event: Control.Event

    public init(control: Control, event: Control.Event) {
        self.control = control
        self.event = event
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        subscriber.receive(subscription: UIControlEventSubscription(subscriber: subscriber, control: control, event: event))
    }
}

public protocol CombineSupport {}
extension UIControl: CombineSupport {}

public extension CombineSupport where Self: UIControl {
    func publisher(for event: Event) -> UIControlEventPublisher<Self> {
        UIControlEventPublisher(control: self, event: event)
    }
}

public extension CombineSupport where Self: UIButton {
    var onTap: AnyPublisher<Self, Never> {
        publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
}

public extension Publisher {
    var toVoid: AnyPublisher<Void, Failure> {
        map { _ in }.eraseToAnyPublisher()
    }
}
