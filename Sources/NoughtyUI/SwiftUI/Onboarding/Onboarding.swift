//
//  Onboarding.swift
//  NoughtyUI
//
//  Created by Dmitrii Sorochin on 05.11.2024.
//
import SwiftUI

struct Onboarding<T, Container, Page>: View where  Container: View, Page: View {
    @State var items: [T]
    var currentItem: T
    var page: (T) -> Page
    var container: (T, @escaping (T) -> Page) ->  Container

    init(
        items: [T],
        currentItem: T,
        page: @escaping (T) -> Page,
        container: @escaping (T, @escaping (T) -> Page) ->  Container
    ) {
        self.items = items
        self.currentItem = currentItem
        self.page = page
        self.container = container
    }

    @ViewBuilder
    var body: some View {
        container(currentItem) { item in
            page(item)
        }
    }
}
