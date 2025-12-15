//
//  SetNicknameFeature.swift
//  Gusto-iOS
//
//  Created by 김민우 on 12/14/25.
//
import ComposableArchitecture


// MARK: Feature
@Reducer
struct SetNicknameFeature {
    // MARK: state
    @ObservableState
    struct State {
        var nicknameInput: String = ""
        var isNicknameValid: Bool = false
    }
    
    
    // MARK: action
    enum Action {
        case validateInput
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .validateInput:
                // capture
                
                
                // mutate
            }
        }
    }
    
    
    // MARK: value
}
