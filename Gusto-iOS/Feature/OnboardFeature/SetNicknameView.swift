//
//  NicnameSettingView.swift
//  Gusto-iOS
//
//  Created by 김민우 on 11/22/25.
//
import SwiftUI
import ComposableArchitecture
import OSLog



// MARK: View
struct SetNicknameView: View {
    // MARK: model
    @Bindable var store: StoreOf<SetNicknameFeature> = Store(initialState: SetNicknameFeature.State()) { SetNicknameFeature() }
    
    
    // MARK: body
    var body: some View {
        VStack(spacing: 0) {
            // 1. 뒤로 가기 버튼
            TopBackButtonBar {
                print("뒤로 가기")
            }
            
            Spacer().frame(height: 30)
            
            // 2. 단계 표시
            StepIndicator(
                step: store.step
            )
            
            // 3. 메인 타이틀
            MainTitle(
                content: "앱 내에서 사용하실\n닉네임을 설정해 주세요."
            )
            
            Spacer().frame(height: 50)
            
            // 4. 닉네임 입력 필드
            NicknameTextField(
                prompt: "용맹한 파스타 21",
                store: store,
                onChange: { newNickname in
                    store.send(.setNickname(newNickname))
                    store.send(.validateInput)
                }
            )
            
            Spacer()
            
            // 5. 하단 버튼
            SubmitButton(
                label: "다음으로 넘어가기",
                isValid: store.isNicknameValid,
                action: {
                    print("다음으로 넘어가기")
                })
        }
    }
}


// MARK: Component
fileprivate struct TopBackButtonBar: View {
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

fileprivate struct StepIndicator: View {
    let step: OnboardFeature.Step
    
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(Color.gray.opacity(0.8)).frame(width: 4, height: 4) // Active (조금 더 진하게)
            Circle().fill(Color.gray.opacity(0.3)).frame(width: 4, height: 4)
            Circle().fill(Color.gray.opacity(0.3)).frame(width: 4, height: 4)
        }
        .padding(.bottom, 10)
        
        Text(step.description)
            .font(.system(size: 14))
            .foregroundColor(.gray)
            .padding(.bottom, 10)
    }
}

fileprivate struct MainTitle: View {
    let content: String
    
    var body: some View {
        Text(content)
            .font(.system(size: 22, weight: .bold))
            .multilineTextAlignment(.center)
            .foregroundColor(.black)
            .lineSpacing(4)
    }
}

fileprivate struct NicknameTextField: View {
    private let logger = Logger()
    let prompt: String
    let store: StoreOf<SetNicknameFeature>
    let onChange: (String) -> Void
    
    @State private var nickname: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField(prompt, text: $nickname)
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    // 글자수 제한 로직
                    .onChange(of: nickname, initial: false) { _, newValue in
                        onChange(newValue)
                        
                        self.nickname = store.nicknameInput
                    }
                
                // 오른쪽 체크마크 (유효할 때만 표시)
                if store.isNicknameValid {
                    Image(systemName: "checkmark")
                        .foregroundColor(pointColor)
                        .padding(.trailing, 16)
                }
            }
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            
            // 하단 안내 메시지 및 카운터
            HStack {
                if !nickname.isEmpty {
                    Text(store.isNicknameTaken ? "이미 사용중인 닉네임입니다." : "사용 가능한 닉네임입니다.")
                        .font(.system(size: 12))
                        .foregroundColor(store.isNicknameTaken ? warningColor : pointColor)
                } else {
                    // 텍스트가 비었을 때 플레이스홀더처럼 보일 문구가 필요하다면 여기에 작성
                    Text(" ")
                }
                
                Spacer()
                
                Text("(\(nickname.count)/13)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 4)
        }
        .padding(.horizontal, 24)
    }
}


fileprivate struct SubmitButton: View {
    let label: String
    let isValid: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isValid ? .white : .gray)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isValid ? pointColor : disabledColor)
                .cornerRadius(12)
        }
        .disabled(!isValid)
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }
}


// MARK: Color
fileprivate let pointColor = Color(red: 0.89, green: 0.45, blue: 0.47)
fileprivate let warningColor = Color(red: 1.0, green: 0.6, blue: 0.4)
fileprivate let disabledColor = Color(red: 0.93, green: 0.93, blue: 0.93)
fileprivate let disabledTextColor = Color.gray


// MARK: Preview
#Preview {
    SetNicknameView()
}
