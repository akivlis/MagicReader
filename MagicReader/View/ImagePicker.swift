//
//  ImagePicker.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 18.08.21.
//

import SwiftUI
import VisionKit
import Vision

struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var recognizedText: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedText: $recognizedText, parent: self)
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        var recognizedText: Binding<String>
        let parent: ImagePicker

        lazy var textDetectionRequest: VNRecognizeTextRequest = {
            let request = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en_GB"]
            return request
        }()

        init(recognizedText: Binding<String>, parent: ImagePicker) {
            self.recognizedText = recognizedText
            self.parent = parent
        }

        // MARK: - UIImagePickerControllerDelegate

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
//                self.image = image
//                parent.image = image
                process(image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        // MARK: Card Recognition

        fileprivate  func process(_ image: UIImage) {
            guard let cgImage = image.cgImage else { return }

            let requests = [textDetectionRequest]
            let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .right, options: [:])
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try imageRequestHandler.perform(requests)
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }

        fileprivate func handleDetectedText(request: VNRequest?, error: Error?) {
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let results = request?.results, results.count > 0 else {
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
                print(processedText)
            }
        }
    }
}
