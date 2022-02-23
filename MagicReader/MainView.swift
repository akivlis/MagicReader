//
//  MainView.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 06.02.22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            CardListView(viewModel: CardListViewModel())
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            CameraPreview()
                .tabItem {
                    Label("Scan", systemImage: "camera.viewfinder")
                }

            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "doc.plaintext")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
