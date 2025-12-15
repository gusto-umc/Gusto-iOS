//
//  SetAgeFeature.swift
//  Gusto-iOS
//
//  Created by 김민우 on 12/14/25.
//
import ComposableArchitecture


// MARK: Feature
@Reducer
struct SetAgeFeature {
    // MARK: state
    @ObservableState
    struct State {
        let step: OnboardFeature.Step = .setAge
        
        var ageInput: Age = ._20대
        var isValid: Bool = false
    }
    
    
    // MARK: action
    enum Action {
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
            case .validateInput:
                // capture
                let age = state.ageInput
                
                // process
                let isAgeValid = (age != .선택하지않음)
                
                // mutate
                state.isValid = isAgeValid
                
                return .none
            case .submit:
                fatalError("구현 예정입니다.")
                return .none
            case .delegate:
                return .none
            }
        }
    }
    
    
    // MARK: value
    enum Age: String, CaseIterable, Sendable, Hashable, CustomStringConvertible {
        // MARK: core
        case _10대 = "10대"
        case _20대 = "20대"
        case _30대 = "30대"
        case _40대 = "40대"
        case _50대 = "50대"
        case _60대이상 = "60대 이상"
        case 선택하지않음 = "선택하지 않음"
        
        static var ordered: [Age] {
            [._10대, ._20대, ._30대, ._40대, ._50대, ._60대이상, .선택하지않음]
        }

        // MARK: operator
        var description: String { self.rawValue }
    }
}
