//
//  CameraPreviewViewModel.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 20.08.21.
//

import Combine
import AVFoundation

class CameraViewModel: ObservableObject {

    @Published var showAlertError = false

    let session = AVCaptureSession()
    let cardDetector = CardDetectionService()

    private var subscriptions = Set<AnyCancellable>()

    init() {
    }

    func startCamera() {
        session.startRunning()
    }

    func stopCamera() {
        session.stopRunning()
    }
}
