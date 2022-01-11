//
//  MagicReaderApp.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 17.08.21.
//

import SwiftUI

@main
struct MagicReaderApp: App {
    var body: some Scene {
        WindowGroup {
            CardListView(viewModel: CardListViewModel())
        }
    }
}
