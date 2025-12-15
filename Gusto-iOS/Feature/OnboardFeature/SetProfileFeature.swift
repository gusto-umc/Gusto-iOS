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
        
    }
    
    
    // MARK: action
    enum Action {
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
    
    
    // MARK: value
}
