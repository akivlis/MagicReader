//
//  PrintListViewModel.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 16.02.22.
//

import Foundation
import Combine
import SwiftUI
import Moya
import CombineMoya

class PrintListViewModel: ObservableObject {

    var url: URL? = nil

    init(printURLString: String) {
        if let url = URL(string: printURLString) {
            self.url = url
        }
    }


}
