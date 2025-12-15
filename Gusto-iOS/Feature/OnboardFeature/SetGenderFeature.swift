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
        let step: OnboardFeature.Step  = .setGender
        
        var genderInput: Gender = .선택하지않음
        var isValid: Bool = false
    }
    
    
    // MARK: action
    enum Action {
        case validateInput
        
        case delegate(Delegate)
        enum Delegate {
            case finished
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .validateInput:
                // capture
                let gender = state.genderInput
                
                // process
                let isValid = (gender != .선택하지않음)
                
                // mutate
                state.isValid = isValid
                
                return .none
            case .delegate:
                return .none
            }
        }
    }
    
    
    // MARK: value
    enum Gender: String, CaseIterable, Sendable, Hashable {
        // MARK: core
        case 여성 = "여성"
        case 남성 = "남성"
        case 선택하지않음 = "선택하지 않음"

        static var ordered: [Gender] {
            [.여성, .남성, .선택하지않음]
        }
    }
}
