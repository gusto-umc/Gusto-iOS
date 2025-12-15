//
//  SetProfileFeature.swift
//  Gusto-iOS
//
//  Created by 김민우 on 12/14/25.
//
import ComposableArchitecture


// MARK: Feature
@Reducer
struct SetProfileFeature {
    // MARK: state
    @ObservableState
    struct State {
        let step: OnboardFeature.Step = .setProfile
    }
    
    
    // MARK: action
    enum Action {
        case delegate(Delegate)
        enum Delegate {
            case finished
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
