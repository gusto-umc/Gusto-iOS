//
//  NicnameSettingView.swift
//  Gusto-iOS
//
//  Created by 김민우 on 11/22/25.
//
import SwiftUI

struct NicknameSettingView: View {
    // MARK: - State
    @State private var nickname: String = ""
    
    // 시뮬레이션을 위한 가짜 상태 변수입니다.
    // 실제 앱에서는 서버 통신 결과에 따라 이 값을 변경해야 합니다.
    // 테스트 방법: "중복"이라고 입력하면 왼쪽 화면(중복)처럼 보이고, 그 외에는 오른쪽 화면(성공)처럼 보입니다.
    var isNicknameTaken: Bool {
        return nickname == "중복"
    }
    
    var isValid: Bool {
        return !nickname.isEmpty && !isNicknameTaken
    }
    
    // MARK: - Colors
    // 이미지에서 추출한 포인트 컬러 (살구색/핑크색)
    let pointColor = Color(red: 0.89, green: 0.45, blue: 0.47)
    let warningColor = Color(red: 1.0, green: 0.6, blue: 0.4) // 주황색 계열
    let disabledColor = Color(red: 0.93, green: 0.93, blue: 0.93)
    let disabledTextColor = Color.gray
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. 상단 네비게이션 영역 (뒤로가기)
            HStack {
                Button(action: {
                    print("뒤로가기")
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Spacer().frame(height: 30)
            
            // 2. 단계 표시 (Step Indicator)
            HStack(spacing: 6) {
                Circle().fill(Color.gray.opacity(0.8)).frame(width: 4, height: 4) // Active (조금 더 진하게)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 4, height: 4)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 4, height: 4)
            }
            .padding(.bottom, 10)
            
            Text("step 1")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.bottom, 10)
            
            // 3. 메인 타이틀
            Text("앱 내에서 사용하실\n닉네임을 설정해 주세요.")
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .lineSpacing(4)
            
            Spacer().frame(height: 50)
            
            // 4. 닉네임 입력 필드
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    TextField("용맹한 파스타 21", text: $nickname)
                        .font(.system(size: 16))
                        .padding(.horizontal, 16)
                        // 글자수 제한 로직
                        .onChange(of: nickname) { newValue in
                            if newValue.count > 13 {
                                nickname = String(newValue.prefix(13))
                            }
                        }
                    
                    // 오른쪽 체크마크 (유효할 때만 표시)
                    if isValid {
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
                        Text(isNicknameTaken ? "이미 사용중인 닉네임입니다." : "사용 가능한 닉네임입니다.")
                            .font(.system(size: 12))
                            .foregroundColor(isNicknameTaken ? warningColor : pointColor)
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
            
            Spacer()
            
            // 5. 하단 버튼
            Button(action: {
                print("다음으로 넘어가기")
            }) {
                Text("다음으로 넘어가기")
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
}

// 미리보기
struct NicknameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameSettingView()
    }
}
