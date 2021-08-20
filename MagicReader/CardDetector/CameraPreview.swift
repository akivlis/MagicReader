//
//  DetectCardView.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 20.08.21.
//

import Foundation
import SwiftUI
import Vision
import AVFoundation
import CoreML

struct CameraPreview: UIViewRepresentable {

    @Environment(\.presentationMode) var presentationMode
    @Binding var recognizedText: String
    let session : AVCaptureSession

    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    // MARK: - Helper

    func makeCoordinator() -> Coordinator {
        Coordinator(session: session,
                    recognizedText: $recognizedText,
                    parent: self)
    }

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        return view
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) {

    }
    // MARK: - Public

    func startCamera() {
        session.startRunning()
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

        var recognizedText: Binding<String>
        var parent: CameraPreview
        var session: AVCaptureSession

        init(session: AVCaptureSession,
             recognizedText: Binding<String>,
             parent: CameraPreview) {
            self.session = session
            self.recognizedText = recognizedText
            self.parent = parent

            super.init()

            configureCamera()
        }


        fileprivate func configureCamera() {
            session.sessionPreset = AVCaptureSession.Preset.photo

            guard let captureDevice = AVCaptureDevice.default(for: .video)
            else { return }

            guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
            else { return }

            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            session.addOutput(output)

            session.addInput(deviceInput)
        }

        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            print("frame was captured")

//            guard let pixelBuffer = CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

//            print(pixelBuffer)

        }

        
    }


}
