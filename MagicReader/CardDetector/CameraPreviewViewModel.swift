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
}

private extension CameraViewModel {

//    func startCamera() {
//        session.sessionPreset = AVCaptureSession.Preset.photo
//
//        guard let captureDevice = AVCaptureDevice.default(for: .video)
//        else { return }
//
//        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
//        else { return }
//
//        let output = AVCaptureVideoDataOutput()
//        session.addOutput(output)
//
//        session.addInput(deviceInput)
//        session.startRunning()
//    }
}
