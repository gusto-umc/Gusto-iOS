//
//  OnboardFeature.swift
//  Gusto-iOS
//
//  Created by 김민우 on 11/22/25.
//
import ComposableArchitecture
import Foundation
import OSLog


// MARK: Feature
@Reducer
struct OnboardFeature {
    // MARK: core
    private let logger = Logger()
    
    
    // MARK: state
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var userName: String!
    }
    
    @Reducer
    enum Path {
        case setNickname(SetNicknameFeature)
        case setAge(SetAgeFeature)
        case setGender(SetGenderFeature)
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
                
            case .path(.element(id: _ , action: .setNickname(.delegate(.finished(let userName))))):
                state.userName = userName
                
                state.path.append(.setAge(.init(userName: userName)))
                return .none
            case .path(.element(id: _ , action: .setAge(.delegate(.finished)))):
                state.path.append(.setGender(.init(userName: state.userName)))
                return .none
            case .path(.element(id: _ , action: .setGender(.delegate(.finished)))):
                state.path.append(.setProfile(.init(userName: state.userName)))
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
