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
        let step: OnboardFeature.Step = .setNickname
        
        var nicknameInput: String = ""
        var isNicknameValid: Bool = false
        var isNicknameTaken: Bool = false
    }
    
    
    // MARK: action
    enum Action {
        case setNickname(String)
        
        case validateInput
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .setNickname(let nickname):
                // mutate
                if nickname.count > 13 {
                    let prefixedValue = String(nickname.prefix(13))
                    
                    state.nicknameInput = prefixedValue
                } else {
                    state.nicknameInput = nickname
                }
                
                return .none
                
            case .validateInput:
                // capture
                let nickname = state.nicknameInput
                
                // process
                let isNicknameEmpty = nickname.isEmpty
                let isNicknameTaken = (nickname == "김철수")
                
                let isValid = !isNicknameEmpty && !isNicknameTaken
                
                // mutate
                state.isNicknameTaken = isNicknameTaken
                state.isNicknameValid = isValid
                return .none
                
            default:
                logger.error("처리되지 않은 Action이 호출되었습니다.")
                return .none
            }
        }
    }
    
    
    // MARK: value
}
