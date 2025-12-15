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
    var onTapKakao: (() -> Void)?
    var onTapNaver: (() -> Void)?
    var onTapGoogle: (() -> Void)?
    var onTapContinueWithoutLogin: (() -> Void)?


    // MARK: body
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)

            // 1. 로고
            OnboardLogo()

            Spacer(minLength: 0)

            // 2. 섹션 타이틀
            SocialLoginSectionTitle(content: "SNS 계정으로 빠른 시작하기")

            Spacer().frame(height: 28)

            // 3. 소셜 로그인 버튼
            SocialLoginButtonRow(
                onTapKakao: { onTapKakao?() },
                onTapNaver: { onTapNaver?() },
                onTapGoogle: { onTapGoogle?() }
            )

            Spacer().frame(height: 56)

            // 4. 로그인 없이 시작하기
            ContinueWithoutLoginButton(
                label: "또는 로그인 없이 시작하기",
                action: { onTapContinueWithoutLogin?() }
            )

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}


// MARK: Component
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

fileprivate struct SocialLoginButtonRow: View {
    let onTapKakao: () -> Void
    let onTapNaver: () -> Void
    let onTapGoogle: () -> Void

    var body: some View {
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

fileprivate struct ContinueWithoutLoginButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.red)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}


// MARK: Preview
#Preview {
    OnboardFeatureView(
        onTapKakao: { print("Kakao tapped") },
        onTapNaver: { print("Naver tapped") },
        onTapGoogle: { print("Google tapped") },
        onTapContinueWithoutLogin: { print("Continue without login tapped") }
    )
}
