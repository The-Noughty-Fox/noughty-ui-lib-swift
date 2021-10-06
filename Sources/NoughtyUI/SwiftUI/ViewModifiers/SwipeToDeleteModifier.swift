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
    case commit
}

public struct DeleteViewConfig {
    public let progress: CGFloat // progress to the limit offset value
    public let availableWidth: CGFloat // raw offset
    public let swipeStage: SwipeStage // stage
}

public struct SwipeToDeleteModifier<DeleteView: View>: ViewModifier {
    public let onDelete: () -> ()
    public let deleteView: (DeleteViewConfig) -> DeleteView
    public let limit: CGFloat
    private let actionLimit: CGFloat
    
    @State private var offset: CGFloat = 0
    @State private var currentTranslation: CGSize = .zero
    
    @State private var feedback: UIImpactFeedbackGenerator?
    @State private var stage: SwipeStage = .initial
    @GestureState private var isActive = false
    
    public init(
        onDelete: @escaping () -> (),
        deleteView: @escaping (DeleteViewConfig) -> DeleteView,
        limit: CGFloat = 100,
        actionLimit: CGFloat = 150
    ) {
        self.onDelete = onDelete
        self.deleteView = deleteView
        self.limit = limit
        self.actionLimit = limit + actionLimit
    }
    
    private func progress(
        for offset: CGFloat,
        limit: CGFloat
    ) -> CGFloat {
        max(min(abs(offset/limit), 1), 0.01)
    }
    
    private var screenTranslation: CGSize {
        var size = currentTranslation
        size.width += offset
        
        return size
    }
    
    //MARK: View
    public func body(content: Content) -> some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {
            deleteView(
                .init(
                    progress: progress(for: screenTranslation.width, limit: limit),
                    availableWidth: max(limit, -screenTranslation.width),
                    swipeStage: stage
                )
            ).onTapGesture {
                onDelete()
            }
            content
                .offset(x: screenTranslation.width, y: 0)
                .gesture(
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
private extension SwipeToDeleteModifier {
    func setOffset(currentTranslation: CGSize) {
        // we can't go past initial position to the right
        if currentTranslation.width + offset > 0 { return }
        
        // we can't go far past second limit
        if currentTranslation.width + offset < -actionLimit - 100 { return } // minus cause we'll provide the limit as positive but moving towards negative numbers
        
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
            self.offset = -limit
        case .commit:
            // add animation/transition
            self.offset = -500
            onDelete()
        }
    }
}

// MARK:- Stage management
private extension SwipeToDeleteModifier {
    func setStage(translation: CGSize) {
        let totalTranslation = (offset + translation.width) * -1 // flipping for ease of use
        var newStage: SwipeStage = .initial
        
        switch totalTranslation {
        case ..<limit:
            newStage = .initial
        case limit..<actionLimit:
            newStage = .locked
        case actionLimit...:
            newStage = .commit
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
        case (.locked, .commit):
            fireFeedback(intensity: 1)
        case (.commit, .locked):
            fireFeedback(intensity: 0.5)
        case (.locked, .initial):
            fireFeedback(intensity: 0.5)
        default:
            break
        }
    }
}


// MARK:- Feedback generator managing
private extension SwipeToDeleteModifier {
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
    public static var previews: some View {
        Color.blue
            .frame(
                width: 300,
                height: 60
            )
            .modifier(
                SwipeToDeleteModifier(
                    onDelete: {},
                    deleteView: { config in
                        Text("Delete")
                            .padding()
                            .aspectRatio(1, contentMode: .fill)
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .cornerRadius(8)
                            .scaleEffect(config.progress)
                    }
                )
            )
    }
}
