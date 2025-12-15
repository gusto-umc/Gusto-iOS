//
//  SetAgeView.swift
//  Gusto-iOS
//
//  Created by 김민우 on 12/14/25.
//

import SwiftUI
import ComposableArchitecture



// MARK: View
struct SetAgeView: View {
    // MARK: model
    @Bindable var store: StoreOf<SetAgeFeature> = Store(initialState: SetAgeFeature.State()) {
        SetAgeFeature()
    }

    
    var onTapBack: (() -> Void)?
    @State private var isAgeDropdownOpen: Bool = false

    // MARK: body
    var body: some View {
        VStack(spacing: 0) {
            // 1. 뒤로 가기 버튼
            TopBackButtonBar {
                print("뒤로 가기 버튼이 클릭되었습니다.")
            }

            Spacer().frame(height: 30)

            // 2. 단계 표시
            StepIndicator(step: store.step)

            // 3. 메인 타이틀
            MainTitle(content: "____님의\n나이를 선택해주세요.")

            Spacer().frame(height: 50)

            // 4. 나이 선택 필드
            AgePickerField(
                store: store,
                isOpen: $isAgeDropdownOpen,
                onChange: { newAge in
                    store.send(.setAge(newAge))
                    store.send(.validateInput)
                }
            )
            .zIndex(1)

            Spacer()

            // 5. 하단 버튼
            SubmitButton(
                label: "다음으로 넘어가기",
                isValid: store.isValid,
                action: {
                    isAgeDropdownOpen = false
                    store.send(.submit)
                }
            )
        }
        .onAppear {
            store.send(.validateInput)
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

    private var currentIndex: Int {
        // 프로젝트의 OnboardFeature.Step 구성에 따라 필요 시 여기만 조정하면 됩니다.
        switch step {
        case .setNickname: return 1
        case .setAge: return 2
        case .setGender: return 3
        default: return 1
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                ForEach(1...3, id: \.self) { idx in
                    Circle()
                        .fill(Color.gray.opacity(idx == currentIndex ? 0.8 : 0.3))
                        .frame(width: 4, height: 4)
                }
            }
            .padding(.bottom, 10)

            Text(step.description)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.bottom, 10)
        }
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

fileprivate struct AgePickerField: View {
    let store: StoreOf<SetAgeFeature>
    @Binding var isOpen: Bool
    let onChange: (SetAgeFeature.Age) -> Void

    var body: some View {
        VStack(spacing: 0) {
            // 선택된 값 표시 영역 (버튼 역할)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isOpen.toggle()
                }
            }) {
                HStack {
                    Text(store.ageInput.rawValue)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(Color.white)
            }

            // 드롭다운 리스트
            if isOpen {
                Divider()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(SetAgeFeature.Age.ordered, id: \.self) { option in
                            Button(action: {
                                onChange(option)
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isOpen = false
                                }
                            }) {
                                HStack {
                                    Text(option.rawValue)
                                        .foregroundColor(store.ageInput == option ? pointColor : .gray)
                                        .fontWeight(store.ageInput == option ? .bold : .regular)
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 50)
                            }
                            Divider()
                        }
                    }
                }
                .frame(maxHeight: 260)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
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
fileprivate let disabledColor = Color(red: 0.93, green: 0.93, blue: 0.93)


// MARK: Preview
#Preview {
    SetAgeView()
}
