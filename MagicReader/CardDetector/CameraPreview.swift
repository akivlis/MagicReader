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
    private let session = AVCaptureSession()

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
                    recognizedText: .constant(""),
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
    //    // MARK: - Public
    //
    //    func startCamera() {
    //        session.startRunning()
    //    }

    // MARK: - Coordinator

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

        var recognizedText: Binding<String>
        var parent: CameraPreview
        var session: AVCaptureSession
        let detectionService = CardDetectionService()
        let nameTracker = StringTracker()

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

            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }

            if session.canAddOutput(output) {
                session.addOutput(output)
            }
        }

        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            // do stuff here
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                print("no image")
                return
            }
            let ciimage = CIImage(cvPixelBuffer: imageBuffer)
            handleOutput(from: ciimage)
        }

        func handleOutput(from ciImage: CIImage) {

            let textDetectionRequest = VNRecognizeTextRequest { request, error in

                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let results = request.results, results.count > 0 else {
                    print("No text was found")
                    return
                }

                var components = [CardComponent]()
                for result in results {
                    if let observation = result as? VNRecognizedTextObservation {
                        for text in observation.topCandidates(1) {
                            let component = CardComponent(x: observation.boundingBox.origin.x,
                                                          y: observation.boundingBox.origin.y,
                                                          text: text.string)
                            components.append(component)
                        }
                    }
                }

                guard let firstComponent = components.first else { return }

                var nameComponent = firstComponent
                var numberComponent = firstComponent
                var setComponent = firstComponent
                for component in components {
                    if component.x < nameComponent.x && component.y > nameComponent.y {
                        nameComponent = component
                    }

                    if component.x < (numberComponent.x + 0.05) && component.y < numberComponent.y {
                        numberComponent = setComponent
                        setComponent = component
                    }
                }

                // maybe this should not be async, only ui changes go to main thread
                DispatchQueue.main.async {
                    let name = nameComponent.text
                    var number = "?"
                    var setCode = "?"

                    if numberComponent.text.count >= 3 {
                        number = String(numberComponent.text.prefix(3))
                    }
                    if setComponent.text.count >= 3 {
                        setCode = String(setComponent.text.prefix(3))
                    }
                    let processedText = "🐉 name: \(name) \n number: \(number) \n setCode: \(setCode) \n"
                    self.recognizedText.wrappedValue = processedText
                    //                    self.parent.onTextDetected((name, number))
                    //                    print(processedText)

                    // Log any found numbers.
                    self.nameTracker.logFrame(strings: [name])
                    //                    show(boxGroups: [(color: UIColor.red.cgColor, boxes: redBoxes), (color: UIColor.green.cgColor, boxes: greenBoxes)])

                    // Check if we have any temporally stable names.
                    if let sureName = self.nameTracker.getStableString() {
                        self.showCardText(name: sureName, number: number)
                        self.nameTracker.reset(string: sureName)
                    }
                }
            }

            textDetectionRequest.recognitionLevel = .fast
            textDetectionRequest.recognitionLanguages = ["en_GB"]
            textDetectionRequest.revision = VNRecognizeTextRequestRevision2
            // textDetectionRequest.regionOfInterest // this would be good to have as i would get rid of the noise

            let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .right, options: [:])

            // perform request
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try imageRequestHandler.perform([textDetectionRequest])
                } catch let error {
                    print("Error: \(error)")
                }
            }

            //            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: textOrientation, options: [:])
            //            do {
            //                try requestHandler.perform([request])
            //            } catch {
            //                print(error)
            //            }

        }


        func showCardText(name: String, number: String) {
            //        self.recognizedText.wrappedValue = processedText
            session.stopRunning()
//            parent.onTextDetected((name, number))
        }


        //    func showString(string: String) {
        //        // Found a definite number.
        //        // Stop the camera synchronously to ensure that no further buffers are
        //        // received. Then update the number view asynchronously.
        //        captureSessionQueue.sync {
        //            self.captureSession.stopRunning()
        //            DispatchQueue.main.async {
        //                self.numberView.text = string
        //                self.numberView.isHidden = false
        //            }
        //        }
        //    }
    }
}
