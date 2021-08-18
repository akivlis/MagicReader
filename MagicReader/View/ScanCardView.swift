//
//  ScanCardView.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 18.08.21.
//

import SwiftUI
import VisionKit
import Vision

struct ScanCardView: UIViewControllerRepresentable {

    @Binding var recognizedText: String
    @Environment(\.presentationMode) var presentationMode

    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: Context) -> some VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // nothing to do here
    }

    // MARK: - Helper

    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedText: $recognizedText, parent: self)
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {

        var recognizedText: Binding<String>
        var parent: ScanCardView

        init(recognizedText: Binding<String>, parent: ScanCardView) {
            self.recognizedText = recognizedText
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            // do the processing of the scan
            let extractedImages = extractImages(from: scan)
            let processedText = recognizeText(from: extractedImages)
            recognizedText.wrappedValue = processedText
            parent.presentationMode.wrappedValue.dismiss()
        }

        fileprivate func extractImages(from scan: VNDocumentCameraScan) -> [CGImage] {
            var extractedImages = [CGImage]()
            for index in 0..<scan.pageCount {
                let extractedImage = scan.imageOfPage(at: index)
                guard let cgImage = extractedImage.cgImage else { continue }

                extractedImages.append(cgImage)
            }
            return extractedImages
        }


        fileprivate func recognizeText(from images: [CGImage]) -> String {
            var entireRecognizedText = ""
            let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
                guard error == nil else {
                    print("Error: \(error!)")
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation],
                      observations.count > 0
                else {
                    print("No text found")
                    return
                }

                let maximumRecognitionCandidates = 1
                for observation in observations {
    //                guard let candidate = observation.topCandidates(maximumRecognitionCandidates).first else { continue }

                    for candidate in observation.topCandidates(maximumRecognitionCandidates) {
                        print(candidate.string)
                        print(candidate.confidence)
                        print(observation.boundingBox)
                        print("\n")

                        entireRecognizedText += "\(candidate.string)\n"
                    }
                }
            }
            recognizeTextRequest.recognitionLevel = .accurate
            recognizeTextRequest.recognitionLanguages = ["en_GB"]

            for image in images {
                let requestHandler = VNImageRequestHandler(cgImage: image, orientation: .right, options: [:])
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        try requestHandler.perform([recognizeTextRequest])
                    } catch let error {
                        print("Error: \(error)")
                    }
                }
            }

            print(entireRecognizedText)
            return entireRecognizedText
        }
    }
}

