//
//  SetNicknameFeature.swift
//  Gusto-iOS
//
//  Created by 김민우 on 12/14/25.
//
import ComposableArchitecture
import OSLog


// MARK: Feature
@Reducer
struct SetNicknameFeature {
    // MARK: core
    private let logger = Logger()
    
    
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
                let nickname = state.nicknameInput
                
                // process
                let isNicknameEmpty = nickname.isEmpty
                let isNicknameTaken = (nickname == "김철수")
                
                let isValid = !isNicknameEmpty && !isNicknameTaken
                
                // mutate
                state.isNicknameValid = isValid
                return .none
            }
        }
    }
    
    
    // MARK: value
}
