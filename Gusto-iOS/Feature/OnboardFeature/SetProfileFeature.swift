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
        let step: OnboardFeature.Step = .setProfile
        
        var profileImageUrl: URL? = nil
    }
    
    
    // MARK: action
    enum Action {
        case validateInpput
        case submit
        
        case delegate(Delegate)
        enum Delegate {
            case finished
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .validateInpput:
                fatalError("구현 예정입니다.")
            case .submit:
                fatalError("구현 예정입니다.")
            case .delegate:
                return .none
            }
        }
    }
    
    
    // MARK: value
}
