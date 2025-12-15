//
//  SetGenderFeature.swift
//  Gusto-iOS
//
//  Created by 김민우 on 12/15/25.
//
import ComposableArchitecture


// MARK: Feature
@Reducer
struct SetGenderFeature {
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

