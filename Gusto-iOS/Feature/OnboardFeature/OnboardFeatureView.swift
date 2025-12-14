//
//  OnboardFeatureView.swift
//  Gusto-iOS
//
//  Created by 김민우 on 11/22/25.
//
import SwiftUI


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

            // MARK: - Logo
            Image("gusto_first_icon")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 260)
                .accessibilityLabel("Gusto")

            Spacer(minLength: 0)

            // MARK: - Social login section
            Text("SNS 계정으로 빠른 시작하기")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.bottom, 28)

            HStack(spacing: 26) {
                Button {
                    onTapKakao?()
                } label: {
                    Image("kakao_login_btn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("카카오로 시작하기")

                Button {
                    onTapNaver?()
                } label: {
                    Image("naver_login_btn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("네이버로 시작하기")

                Button {
                    onTapGoogle?()
                } label: {
                    Image("google_login_btn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("구글로 시작하기")
            }

            Spacer().frame(height: 56)

            // MARK: - Skip login
            Button {
                onTapContinueWithoutLogin?()
            } label: {
                Text("또는 로그인 없이 시작하기")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.red)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("로그인 없이 시작하기")

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
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
