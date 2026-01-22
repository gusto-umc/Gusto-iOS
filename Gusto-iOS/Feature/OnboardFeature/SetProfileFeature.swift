//
//  SetProfileFeature.swift
//  Gusto-iOS
//
//  Created by 김민우 on 12/14/25.
//
import ComposableArchitecture
import Foundation


// MARK: Feature
@Reducer
struct SetProfileFeature {
    // MARK: state
    @ObservableState
    struct State {
        let userName: String
        let step: OnboardFeature.Step = .setProfile
        
        var profileImage: Data? = nil
        var isValid: Bool = false
    }
    
    
    // MARK: action
    enum Action {
        case setProfileImage(Data)
        
        case validateInput
        case submit
        
        case delegate(Delegate)
        enum Delegate {
            case finished
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .setProfileImage(let image):
                state.profileImage = image
                return .none
            case .validateInput:
                // mutate
                if state.profileImage != nil {
                    state.isValid = true
                    return .none
                } else {
                    state.isValid = false
                    return .none
                }
            case .submit:
                if state.isValid {
                    return .send(.delegate(.finished))
                } else {
                    return .none
                }
            case .delegate:
                return .none
            }
        }
    }
    
    
    // MARK: value
}
