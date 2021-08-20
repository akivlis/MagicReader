//
//  ScannerViewController.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 20.08.21.
//

import Foundation
import AVFoundation
import UIKit

class ScannerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension ScannerViewController {

    func startLiveVideo() {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo

        guard let captureDevice = AVCaptureDevice.default(for: .video)
        else { return }

        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
        else { return }

        session.addInput(deviceInput)

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)

        session.startRunning()
    }

}
