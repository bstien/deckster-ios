//
//  GameSelectorView.swift
//  DecksterApp
//
//  Created by Øivind Jorfald on 15/11/2024.
//

import SwiftUICore

struct GameSelectorView: View {
    
    @State private var viewModel: ViewModel

    init() {
        viewModel = ViewModel()
    }
    
    var body: some View {
        
    }
}

extension GameSelectorView {
    @Observable
    class ViewModel {
        
    }
}
