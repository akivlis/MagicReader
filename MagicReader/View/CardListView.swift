//
//  CardListView.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 17.08.21.
//

import SwiftUI

struct CardListView: View {

    private var cards = [ Card(name: "Sol Ring"),
                          Card(name: "Fighter Class"),
                          Card(name: "Portable Hole"),
                          Card(name: "Silverbluff Bridge"),
                          Card(name: "Silent Arbiter")
    ]

    @State private var searchText = ""
    @State private var showingScanningView = false
    @State private var recognizedText = "Tap button to start scanning."
    @State private var inputImage: UIImage?

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.bottom, 0.0)

                List(cards.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) })) { item in
                    Text(item.name)
                }

                Text(recognizedText)
                    .padding()
            }
            .navigationBarTitle("Single Cards")
            .toolbar {
                Button(action: {
                    self.showingScanningView = true

                }) {
                    Image(systemName: "camera.viewfinder")
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                }
            }
            .sheet(isPresented: $showingScanningView) {
//                ScanCardView(recognizedText: self.$recognizedText)
                ImagePicker(image: self.$inputImage, recognizedText: self.$recognizedText)
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
//        image = Image(uiImage: inputImage)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView()
    }
}
