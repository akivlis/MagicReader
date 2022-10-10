//
//  ScannerView.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 06.02.22.
//

import SwiftUI

struct ScannerView: View {

    @State private var recognizedText = "Test"
    @ObservedObject private var viewModel = CameraViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                CameraView(recognizedText: $recognizedText, viewModel: viewModel)
                Text(recognizedText)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Restart", action: viewModel.startCamera)
                }
            }
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
