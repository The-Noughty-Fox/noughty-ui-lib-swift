//
//  SwipeToDeleteModifier.swift
//  ComponentLibrary
//
//  Created by Lisnic Victor on 09.04.2021.
//

import SwiftUI

public enum SwipeStage: Equatable {
    case initial
    case locked
}

public struct SwipeActionConfig {
    public let progress: CGFloat // progress to the limit offset value
    public let availableWidth: CGFloat // raw offset
    public let swipeStage: SwipeStage // stage
    public let itemIndex: Int
    public let actionContainerWidth: CGFloat
}


public struct SwipeActionModifier<Action: Hashable, ActionView: View>: ViewModifier {
    public let swipeActions: [Action]
    private let actionLimit: CGFloat
    private let container: (Action, SwipeActionConfig) -> ActionView

    @State private var limit: CGSize = .zero

    @State private var offset: CGFloat = 0
    @State private var currentTranslation: CGSize = .zero
    @State private var feedback: UIImpactFeedbackGenerator?
    @State private var stage: SwipeStage = .initial
    @GestureState private var isActive = false

    public init(
        swipeActions: [Action],
        actionLimit: CGFloat = 150,
        @ViewBuilder container: @escaping (Action, SwipeActionConfig) -> ActionView
    ) {
        self.swipeActions = swipeActions
        self.actionLimit = actionLimit
        self.container = container
    }

    private func progress(
        for offset: CGFloat,
        limit: CGFloat
    ) -> CGFloat {
        max(min(abs(offset/limit), 1), 0)
    }

    private var screenTranslation: CGSize {
        var size = currentTranslation
        size.width += offset
        return size
    }

    //MARK: View
    public func body(content: Content) -> some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {
            HStack(spacing: 0) {
                ForEach(Array(swipeActions.enumerated()), id: \.offset) {
                    index,
                    swipeAction in
                    container(
                        swipeAction,
                        SwipeActionConfig(
                            progress: progress(
                                for: screenTranslation.width,
                                limit: limit.width
                            ),
                            availableWidth: max(limit.width, -screenTranslation.width),
                            swipeStage: stage,
                            itemIndex: index,
                            actionContainerWidth: limit.width
                        )
                    )
                }
            }
            .observeSize($limit)
            .frame(maxWidth: limit.width)
            content
                .offset(x: screenTranslation.width, y: 0)
                .layoutPriority(10)
                .simultaneousGesture(
                    DragGesture(coordinateSpace: .local)
                        .updating($isActive) { (value, state, transaction) in
                            state = true
                        }
                        .onChanged { value in
                            withAnimation(.default) {
                                setOffset(currentTranslation: value.translation) // moved the view, set the stage
                            }
                        }.onEnded { (value) in
                            withAnimation(.default) {
                                dragEnded()
                            }
                        }
                )
        }.onChange(of: stage) { [old=stage] new in
            stageChanged(old: old, new: new)
        }.onChange(of: isActive) { [old=isActive] new in
            manageGenerator(isActive: old, new: new)
        }
    }
}

// MARK:- Gesture management
private extension SwipeActionModifier {
    func setOffset(currentTranslation: CGSize) {
        // we can't go past initial position to the right
        if currentTranslation.width + offset > 0 { return }

        // we can alter the translation to move slower/with a curve etc.
        self.currentTranslation.width = currentTranslation.width

        // changing the stage according to current offset
        setStage(translation: currentTranslation)
    }

    func dragEnded() {
        // resetting the active drag translation
        currentTranslation = .zero

        switch stage {
        case .initial:
            self.offset = 0
        case .locked:
            self.offset = -limit.width
        }
    }
}

// MARK:- Stage management
private extension SwipeActionModifier {
    func setStage(translation: CGSize) {
        let totalTranslation = (offset + translation.width) * -1 // flipping for ease of use
        var newStage: SwipeStage = .initial

        switch totalTranslation {
        case ..<limit.width:
            newStage = .initial
        case limit.width...:
            newStage = .locked
        default:
            break;
        }

        self.stage = newStage
    }

    // Called from @State stage changes through .onChange()
    private func stageChanged(old: SwipeStage, new: SwipeStage) {
        // fire feedback generator
        // intensity
        //.initial -> .locked 0.8, .locked -> .commit 1,
        //.commit -> .locked 0.5, .locked -> .initial 0.5
        switch (old, new) {
        case (.initial, .locked):
            fireFeedback(intensity: 0.8)
        case (.locked, .initial):
            fireFeedback(intensity: 0.5)
        default:
            break
        }
    }
}


// MARK:- Feedback generator managing
private extension SwipeActionModifier {
    // called on @GestureState isActive change through .onChange()
    func manageGenerator(isActive old: Bool, new: Bool) {
        switch (old, new) {
        case (false, true):
            feedback = UIImpactFeedbackGenerator()
            feedback?.prepare()
        case (true, false):
            feedback = nil
        default:
            break
        }
    }

    func fireFeedback(intensity: CGFloat) {
        feedback?.impactOccurred(intensity: intensity)
        feedback?.prepare()
    }
}

// MARK:- Previews
public struct SwipeToDeleteModifier_Previews: PreviewProvider {

    private enum TestAction: String, Hashable {
        case delete
        case edit
        case pin

        var color: Color {
            switch self {
            case .delete:
                    .red
            case .edit:
                    .blue
            case .pin:
                    .green
            }
        }
        var title: String {
            switch self {
            case .delete:
                "Delete"
            case .edit:
                "Edit"
            case .pin:
                "Pin"
            }
        }
    }

    static private func item(for action: TestAction, config: SwipeActionConfig, actionCount: Int = 3) -> some View {
        Text(action.title)
            .padding()
            .frame(width: 90)
            .frame(maxHeight: .infinity)
            .background(action.color)
            .foregroundColor(Color.white)
            .offset(x: CGFloat(actionCount - config.itemIndex) * config.actionContainerWidth/CGFloat(actionCount) * (1 - config.progress))
            .opacity(config.progress > 0 ? 1 : 0)
    }

    public static var previews: some View {
        Color.purple
            .frame(
                width: 300,
                height: 60
            )
            .modifier(
                SwipeActionModifier(swipeActions: [TestAction.pin, TestAction.edit, TestAction.delete]) { action, config in
                    item(for: action, config: config, actionCount: 3)
                }
            )
            .border(color: .red, corderRadius: 0, relationToContent: .over, lineWidth: 1)
    }
}

