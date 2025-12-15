//
//  OnboardFeatureView.swift
//  Gusto-iOS
//
//  Created by 김민우 on 11/22/25.
//
import SwiftUI
import ComposableArchitecture



// MARK: View
struct OnboardFeatureView: View {
    // MARK: model
    let store: StoreOf<OnboardFeature> = .init(initialState: OnboardFeature.State()) {
        OnboardFeature()
    }


    // MARK: body
    var body: some View {
        OnboardLayout(store: store) {
            Spacer()
            Spacer()

            // 1. 로고
            OnboardLogo()

            Spacer()

            // 2. 섹션 타이틀
            SocialLoginSectionTitle(content: "SNS 계정으로 빠른 시작하기")

            // 3. 로그인 버튼 그룹
            LoginButtonGroup(
                onTapKakao: {
                    // Kakao 버튼 클릭 액션
                    store.send(.startSignUp)
                },
                onTapNaver: {
                    // Naver 버튼 클릭 액션
                    store.send(.startSignUp)
                },
                onTapGoogle: {
                    // Google 버튼 클릭 액션
                    store.send(.startSignUp)
                },
                onTapContinueWithoutLogin: {
                    // 로그인 없이 시작하기 버튼 액션
                    store.send(.startSignUp)
                }
            )

            Spacer(minLength: 0)
        }
    }
}


// MARK: Component
fileprivate struct OnboardLayout<Content: View>: View {
    @Bindable var store: StoreOf<OnboardFeature>
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                content()
            }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
        } destination: { store in
            switch store.case {
            case .setNickname(let store):
                SetNicknameView(store: store)
            case .setAge(let store):
                SetAgeView(store: store)
            case .setGender(let store):
                SetGenderView(store: store)
            case .setProfile(let store):
                SetProfileView(store: store)
            }
        }
    }
}

fileprivate struct OnboardLogo: View {
    var body: some View {
        Image("gusto_first_icon")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 260)
            .accessibilityLabel("Gusto")
    }
}

fileprivate struct SocialLoginSectionTitle: View {
    let content: String

    var body: some View {
        Text(content)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.secondary)
    }
}

fileprivate struct LoginButtonGroup: View {
    let onTapKakao: () -> Void
    let onTapNaver: () -> Void
    let onTapGoogle: () -> Void
    let onTapContinueWithoutLogin: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 26) {
                SocialLoginIconButton(
                    imageName: "kakao_login_btn",
                    accessibilityLabel: "카카오로 시작하기",
                    action: onTapKakao
                )

                SocialLoginIconButton(
                    imageName: "naver_login_btn",
                    accessibilityLabel: "네이버로 시작하기",
                    action: onTapNaver
                )

                SocialLoginIconButton(
                    imageName: "google_login_btn",
                    accessibilityLabel: "구글로 시작하기",
                    action: onTapGoogle
                )
            }

            Spacer().frame(height: 56)

            Button(action: onTapContinueWithoutLogin) {
                Text("또는 로그인 없이 시작하기")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.red)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("로그인 없이 시작하기")
        }
        .padding(.top, 28)
    }
}

fileprivate struct SocialLoginIconButton: View {
    let imageName: String
    let accessibilityLabel: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}


// MARK: Preview
#Preview {
    OnboardFeatureView()
}
