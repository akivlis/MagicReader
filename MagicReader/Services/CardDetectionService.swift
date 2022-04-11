//
//  CardDetectionService.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 20.08.21.
//

import Foundation
import Vision

class CardDetectionService {

    func getDetectedText(request: VNRequest?, error: Error?) -> String {
        if let error = error {
            print(error.localizedDescription)
            return ""
        }
        guard let results = request?.results, results.count > 0 else {
            print("No text was found")
            return ""
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

        guard let firstComponent = components.first else { return "" }

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

//        DispatchQueue.main.async {
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
            //            self.recognizedText.wrappedValue = processedText
            print(processedText)

            return processedText

    }

    func getDetectedText(from request: VNRequest?) -> String {
        guard let results = request?.results, results.count > 0 else {
            print("No text was found")
            return ""
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

        guard let firstComponent = components.first else { return "" }

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

//        DispatchQueue.main.async {
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
            //            self.recognizedText.wrappedValue = processedText
            print(processedText)

            return processedText

    }
}
