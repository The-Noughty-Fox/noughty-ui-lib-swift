import SwiftUI

public enum Dimension {
    case width
    case height
    case all
}

extension Image {
    ///Wraps an image in a container that lets it resize but will constrain it by the proposed size, not allowing it to stretch the parent, while preserving the aspect ratio thus avoiding distortion
    public func resizableWithRespect(to parentDimension: Dimension) -> some View {
        
        let dimensionsToRespect: (width: Bool, height: Bool)
        
        switch parentDimension {
        case .all:
            dimensionsToRespect = (true, true)
        case .height:
            dimensionsToRespect = (false, true)
        case .width:
            dimensionsToRespect = (true, false)
        }
        
        return GeometryReader { proxy in
            self
                .resizable()
                .scaledToFill()
                .frame(
                    width: dimensionsToRespect.width ? proxy.size.width : nil,
                    height: dimensionsToRespect.height ? proxy.size.height : nil,
                    alignment: .center
                )
        }
    }
}
