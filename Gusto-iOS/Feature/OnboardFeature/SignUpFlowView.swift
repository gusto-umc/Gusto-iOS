//
//  SignUpFlowView.swift
//  Gusto-iOS
//
//  Created by 김민우 on 11/22/25.
//
import SwiftUI

// MARK: - 데이터 및 단계 정의
enum SignupStep: Int, CaseIterable {
    case nickname = 1
    case age = 2
    case gender = 3
    case final = 4
    
    var title: String {
        switch self {
        case .nickname: return "앱 내에서 사용하실\n닉네임을 설정해 주세요."
        case .age: return "000님의\n나이를 선택해주세요." // 실제 닉네임 바인딩 필요
        case .gender: return "000님의\n성별을 선택해주세요."
        case .final: return "000님의\n프로필 사진이에요."
        }
    }
    
    var subtitle: String {
        return "step \(self.rawValue)"
    }
}

struct SignupFlowView: View {
    // MARK: - State
    @State private var currentStep: SignupStep = .nickname
    
    // 입력 데이터
    @State private var nickname: String = ""
    @State private var selectedAge: String? = nil
    @State private var selectedGender: String? = nil
    
    // 드롭다운 확장 여부
    @State private var isAgeDropdownOpen: Bool = false
    @State private var isGenderDropdownOpen: Bool = false
    
    // Colors
    let pointColor = Color(red: 0.89, green: 0.45, blue: 0.47)
    let disabledColor = Color(red: 0.93, green: 0.93, blue: 0.93)
    
    // Data Source
    let ageOptions = ["10대", "20대", "30대", "40대", "50대", "60대 이상", "선택하지 않음"]
    let genderOptions = ["선택하지 않음", "여성", "남성", "선택하지 않음(중복예시)"] // 이미지상의 예시
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 1. 공통 네비게이션 바
            navigationHeader
            
            // 2. 공통 단계 인디케이터 (마지막 단계 제외)
            if currentStep != .final {
                stepIndicator
            } else {
                Text("Final")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
            
            // 3. 공통 타이틀
            Text(currentStepTitle)
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            if currentStep == .final {
                Text("수정하려면 사진을 탭하세요.")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
            
            Spacer().frame(height: 40)
            
            // 4. 메인 컨텐츠 (단계별 스위칭)
            ZStack(alignment: .top) {
                switch currentStep {
                case .nickname:
                    nicknameStepView
                case .age:
                    selectionStepView(
                        placeholder: "20대",
                        selection: $selectedAge,
                        isOpen: $isAgeDropdownOpen,
                        options: ageOptions
                    )
                case .gender:
                    selectionStepView(
                        placeholder: "선택하지 않음",
                        selection: $selectedGender,
                        isOpen: $isGenderDropdownOpen,
                        options: genderOptions
                    )
                case .final:
                    finalProfileView
                }
            }
            .padding(.horizontal, 24)
            .zIndex(1) // 드롭다운이 다른 요소보다 위에 뜨게 하려면 필요할 수 있음
            
            Spacer()
            
            // 5. 하단 버튼
            actionButton
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
        }
    }
    
    // MARK: - Computed Properties for UI Logic
    
    var currentStepTitle: String {
        // 닉네임이 설정되었다면 000님 부분을 실제 닉네임으로 치환
        let rawTitle = currentStep.title
        return rawTitle.replacingOccurrences(of: "000", with: nickname.isEmpty ? "사용자" : nickname)
    }
    
    var isNextButtonEnabled: Bool {
        switch currentStep {
        case .nickname:
            return !nickname.isEmpty && nickname.count <= 13 // + 중복체크 로직
        case .age:
            return selectedAge != nil
        case .gender:
            return selectedGender != nil
        case .final:
            return true
        }
    }
    
    var buttonTitle: String {
        switch currentStep {
        case .nickname, .age: return "다음으로 넘어가기"
        case .gender: return "완료하기"
        case .final: return "그대로 가져가기"
        }
    }
}

// MARK: - Subviews (Components)
extension SignupFlowView {
    
    // 상단 네비게이션 (뒤로가기)
    var navigationHeader: some View {
        HStack {
            Button(action: {
                withAnimation {
                    goBack()
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    // ... 인디케이터
    var stepIndicator: some View {
        VStack(spacing: 10) {
            HStack(spacing: 6) {
                ForEach(1...3, id: \.self) { index in
                    Circle()
                        .fill(currentStep.rawValue == index ? Color.gray.opacity(0.8) : Color.gray.opacity(0.3))
                        .frame(width: 4, height: 4)
                }
            }
            
            Text(currentStep.subtitle)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding(.bottom, 10)
    }
    
    // STEP 1: 닉네임 입력 뷰
    var nicknameStepView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField("용맹한 파스타 21", text: $nickname)
                    .font(.system(size: 16))
                    .onChange(of: nickname) { newValue in
                        if newValue.count > 13 { nickname = String(newValue.prefix(13)) }
                    }
                
                if !nickname.isEmpty {
                    Image(systemName: "checkmark")
                        .foregroundColor(pointColor)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            
            HStack {
                Text(nickname.isEmpty ? "" : "사용 가능한 닉네임입니다.")
                    .font(.system(size: 12))
                    .foregroundColor(pointColor)
                Spacer()
                Text("(\(nickname.count)/13)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 4)
        }
    }
    
    // STEP 2 & 3: 선택(Dropdown) 뷰 빌더
    func selectionStepView(placeholder: String, selection: Binding<String?>, isOpen: Binding<Bool>, options: [String]) -> some View {
        VStack(spacing: 0) {
            // 선택된 값 표시 영역 (버튼 역할)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isOpen.wrappedValue.toggle()
                }
            }) {
                HStack {
                    Text(selection.wrappedValue ?? placeholder)
                        .foregroundColor(selection.wrappedValue == nil ? .gray : .black)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(Color.white) // 배경 있어야 클릭 영역 확보
            }
            
            // 드롭다운 리스트
            if isOpen.wrappedValue {
                Divider()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                selection.wrappedValue = option
                                withAnimation {
                                    isOpen.wrappedValue = false
                                }
                            }) {
                                HStack {
                                    Text(option)
                                        .foregroundColor(selection.wrappedValue == option ? pointColor : .gray)
                                        .fontWeight(selection.wrappedValue == option ? .bold : .regular)
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 50)
                            }
                            Divider()
                        }
                    }
                }
                .frame(maxHeight: 200) // 리스트 최대 높이 제한
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    // Final: 프로필 확인 뷰
    var finalProfileView: some View {
        VStack {
            Spacer().frame(height: 20)
            
            // 프로필 이미지 (예시용 시스템 이미지 or AsyncImage)
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Image(systemName: "person.fill") // 실제 앱에선 AsyncImage 사용
                            .resizable()
                            .scaledToFit()
                            .padding(30)
                            .foregroundColor(.gray)
                    )
                    // 이미지가 있다면 아래처럼 clipping
                    // .clipShape(Circle())
                
                // 꽃 아이콘 데코레이션 (이미지 참고)
                Image(systemName: "camera.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.gray)
                    .background(Circle().fill(.white))
                    .offset(x: 0, y: 0)
            }
        }
    }
    
    // 하단 공통 액션 버튼
    var actionButton: some View {
        Button(action: {
            withAnimation {
                goNext()
            }
        }) {
            Text(buttonTitle)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isNextButtonEnabled ? .white : .gray)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isNextButtonEnabled ? pointColor : disabledColor)
                .cornerRadius(12)
        }
        .disabled(!isNextButtonEnabled)
    }
    
    // MARK: - Logic Methods
    
    func goNext() {
        switch currentStep {
        case .nickname:
            currentStep = .age
        case .age:
            isAgeDropdownOpen = false // 이동 시 닫기
            currentStep = .gender
        case .gender:
            isGenderDropdownOpen = false // 이동 시 닫기
            currentStep = .final
        case .final:
            print("회원가입 완료 처리")
        }
    }
    
    func goBack() {
        switch currentStep {
        case .nickname:
            print("첫 화면에서 뒤로가기 - 화면 닫기 등")
        case .age:
            currentStep = .nickname
        case .gender:
            currentStep = .age
        case .final:
            currentStep = .gender
        }
    }
}

struct SignupFlowView_Previews: PreviewProvider {
    static var previews: some View {
        SignupFlowView()
    }
}
