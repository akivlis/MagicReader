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
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.startRunning()
        }
    }

    func stopCamera() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.session.stopRunning()
        }
    }
}
