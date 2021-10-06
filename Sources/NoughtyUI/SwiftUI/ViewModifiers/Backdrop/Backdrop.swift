//
//  Backdrop.swift
//  ComponentLibrary
//
//  Created by Lisnic Victor on 16.04.2021.
//

import SwiftUI



// TODO:
// input
// user - drag gesture
// programmatic: stage, isShown

public struct Backdrop<Backdrop: View>: ViewModifier {
    @Binding var isShown: Bool
    
    public typealias BackdropContentConstructor = (_ config: BackDropContentConfig, _ dragEnabled: Binding<Bool>) -> Backdrop
    var backdrop: BackdropContentConstructor
    
    let config: BackdropConfig
    
    @GestureState private var isGestureActive: Bool = false
    
    // change it to a binding
    @State private var isDragEnabled: Bool = true
    // a model height of backdrop when you let go of it
    @State private var backdropHeight: CGFloat = .zero
    // current translation of drag gesture
    @State private var currentDragTranslation: CGFloat = .zero
    
    // BUG stage is in .hidden after first dismiss and on show it has backdropheight of 0
    @State private var stage: BackdropStage = .hidden
    
    /// Size of the parent in which we do the presentation
    @State private var containerSize: CGSize = .zero
    @State private var contentSafeAreaInset: EdgeInsets = .init()
    /// A distance that needs to be traveled from half stage up or down to initiate expansion/collapse during drag
    let threshold: CGFloat = 100
    
    /// current onscreen height of backdrop including current drag translation
    /// is used for actual drawing
    var screenBackdropHeight: CGFloat {
        backdropHeight + currentDragTranslation
    }
    
    var screenOffset: CGFloat {
        containerSize.height - screenBackdropHeight
    }
    
    public init(
        config: BackdropConfig,
        isShown: Binding<Bool>,
        @ViewBuilder _ backdrop: @escaping BackdropContentConstructor
    ) {
        self.config = config
        self.backdrop = backdrop
        self._isShown = isShown
    }
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        content
            .observeSize($containerSize)
            .onPreferenceChange(
                SafeAreaInsetsKey.self,
                perform: { value in
                    self.contentSafeAreaInset = value ?? .init()
                }
            )
            .overlay(
                VStack {
                    if isShown {
                        backdrop(
                            .init(
                                offset: screenOffset,
                                height: screenBackdropHeight,
                                stage: stage,
                                gestureInProgress: isGestureActive
                            ),
                            $isDragEnabled
                        )
                        .onAppear {
                            backdropHeight = height(for: config.initialStage)
                        }
                        .transition(.backDrop(target: containerSize.height + contentSafeAreaInset.bottom))
                        .gesture(
                            dragGesture,
                            including: isDragEnabled ? .all : .none
                        )
                    }
                }
                .ignoresSafeArea(.container, edges: .bottom)
            )
    }
}

//MARK: Gesture management
extension Backdrop {
    var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .local)
            .updating($isGestureActive) { value, state, transaction in
                state = true
            }
            .onChanged(dragChanged)
            .onEnded(dragEnded)
    }
    
    func dragChanged(_ value: DragGesture.Value) {
        withAnimation {
            setCurrentDragTranslation(value.translation)
            self.stage = getStage(for: screenBackdropHeight)
        }
    }
    
    func setCurrentDragTranslation(_ translation: CGSize) {
        // We flip it so we can represent it as height, i.e. positive values are up, negative are down
        let flippedTranslation = translation.height * -1
        let totalHeight = flippedTranslation + backdropHeight
        
        switch totalHeight {
        case ..<0: return
        // if the backdrop can be minimized, we will not allow the user to go lower that that
        case 0..<height(for: .minimized) where config.canBeMinimized: return
        // if the backdrop can't be expanded, we will not allow the user to go higher that half
        case (height(for: .half) + threshold)... where !config.canBeExpanded: return
        // we cannot go higher that full height (will add bounce threshold later)
        case height(for: .full)...: return
        default: break
        }
        
       
        currentDragTranslation = flippedTranslation
    }
    
    func dragEnded(_ value: DragGesture.Value) {
        withAnimation(.spring()) {
            if case .hidden = stage {
                isShown = false
            }
            
            self.currentDragTranslation = .zero
            self.backdropHeight = height(for: stage)
        }
    }
}

//MARK: Stage management
extension Backdrop {
    func height(for stage: BackdropStage) -> CGFloat {
        let halfHeight = config.halfHeight.relativeValue(whole: containerSize.height)
        let minimizedHeight = config.minimizedHeight.relativeValue(whole: containerSize.height)
        let fullHeight = config.fullHeight.relativeValue(whole: containerSize.height)
        
        switch stage {
        case .minimized:
            return minimizedHeight
        case .full:
            return fullHeight
        case .half:
            return halfHeight
        case .hidden:
            return .zero
        }
    }
    
    func getStage(for backdropHeight: CGFloat) -> BackdropStage {
        let halfHeight = height(for: .half)
        let minimizedHeight = height(for: .minimized)
        
        switch backdropHeight {
        case 0...height(for: .minimized):
            return config.canBeMinimized ? .minimized : .hidden
        case minimizedHeight..<(halfHeight - threshold):
            return config.canBeMinimized ? .minimized : .hidden
        case (halfHeight - threshold)..<(halfHeight + threshold):
            return .half
        case (halfHeight + threshold)...:
            return config.canBeExpanded ? .full : .half
        default:
            return .hidden
        }
    }
}

extension View {
    public func backdrop<BackdropContent: View>(
        isShown: Binding<Bool>,
        config: BackdropConfig = .default,
        content: @escaping (_ config: BackDropContentConfig,
                            _ dragEnabled: Binding<Bool>) -> BackdropContent
    ) -> some View {
        self.modifier(
            Backdrop(
                config: config,
                isShown: isShown,
                content
            )
        )
    }
}

struct Backdrop_wrapper: View {
    @State var isShown: Bool = false
    
    var body: some View {
        Color.black
            .ignoresSafeArea()
            .overlay(
                Button("Show") {
                    withAnimation {
                        self.isShown.toggle()
                    }
                }
                .padding()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topTrailing
                )
            )
            .backdrop(isShown: $isShown, content: backdropContent)
    }
    
    @ViewBuilder
    func backdropContent(config: BackDropContentConfig, dragEnabled: Binding<Bool>) -> some View {
        Text("\(config.height), \(config.offset)")
            .frame(maxHeight: .infinity)
        .defaultBackdropContainer(config: config, showChevron: true)
    }
}

struct Backdrop_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Backdrop_wrapper()
        }
    }
}
