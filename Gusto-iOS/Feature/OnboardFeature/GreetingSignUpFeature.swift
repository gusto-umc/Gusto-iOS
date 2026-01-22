//
//  GreetingSignUpFeature.swift
//  Gusto-iOS
//
//  Created by 김민우 on 12/15/25.
//
import ComposableArchitecture


// MARK: Feature
@Reducer
struct GreetingSignUpFeature {
    // MARK: state
    @ObservableState
    struct State {
        
    }
    
    
    // MARK: action
    enum Action {
        
        case delegate(Delegate)
        enum Delegate {
            case goHome
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            }
        }
    }
    
    
    // MARK: value
}
