//
//  OnboardFeature.swift
//  Gusto-iOS
//
//  Created by 김민우 on 11/22/25.
//
import ComposableArchitecture


// MARK: Feature
@Reducer
struct OnboardFeature {
    // MARK: state
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
    }
    
    @Reducer
    enum Path {
        case setNickname(SetNicknameFeature)
        case setAge(SetAgeFeature)
        case setProfile(SetProfileFeature)
    }
    
    
    // MARK: action
    enum Action {
        case path(StackActionOf<Path>)
        
        case startSignUp
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .startSignUp:
                state.path.append(.setNickname(.init()))
                
                return .none
            default:
                
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    
    // MARK: value
    enum Step: Int, Sendable, Hashable, CaseIterable {
        // MARK: core
        case setNickname = 1
        case setAge = 2
        case setGender = 3
        case setProfile = 4
        
        // MARK: operator
        var description: String {
            return "step \(self.rawValue)"
        }
        
        var totalCount: Int {
            return Self.allCases.count
        }
        
        var number: Int {
            return self.rawValue
        }
    }
}
