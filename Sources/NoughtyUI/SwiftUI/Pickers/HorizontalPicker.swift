//
//  SwiftUIView.swift
//  
//
//  Created by Lisnic Victor on 30.04.2021.
//

import SwiftUI

public struct HorizontalPicker<T, ID: Hashable, EachContent: View >: DynamicViewContent {
    public typealias Data = [T]
    
    public let data: [T]
    let idPath: KeyPath<T, ID>
    let forEachContent: (Int, T, Bool) -> EachContent
    let isSelected: (Int, T) -> Bool

    public init(
        dataSource: [T],
        idPath: KeyPath<T, ID>,
        isSelected: @escaping (Int, T) -> Bool,
        forEachContent: @escaping (Int, T, Bool) -> EachContent
    ) {
        self.data = dataSource
        self.idPath = idPath
        self.isSelected = isSelected
        self.forEachContent = forEachContent
    }
    
    public init(
        dataSource: [T],
        isSelected: @escaping (Int, T) -> Bool,
        forEachContent: @escaping (Int, T, Bool) -> EachContent
    ) where T: Identifiable, T.ID == ID {
        self.data = dataSource
        self.idPath = \T.id
        self.isSelected = isSelected
        self.forEachContent = forEachContent
    }
    
    public var body: some View {
        HStack {
            ForEach(
                Array(data.enumerated()),
                id: (\(offset: Int, element: T).element).appending(path: idPath)
            ) { (offset, data) in
                forEachContent(offset, data, isSelected(offset, data))
            }
        }
    }
}
