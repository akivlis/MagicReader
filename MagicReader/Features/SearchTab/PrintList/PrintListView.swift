//
//  PrintListView.swift
//  MagicReader
//
//  Created by Silvia Kuzmova on 15.02.22.
//

import SwiftUI

struct PrintListView: View {

    let viewModel: PrintListViewModel

    var body: some View {
        Text(viewModel.url?.relativeString ?? "")
    }
}

struct PrintListView_Previews: PreviewProvider {
    static var previews: some View {
        PrintListView(viewModel: PrintListViewModel(printURLString: ""))
    }
}
