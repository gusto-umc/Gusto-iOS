//
//  SetProfileView.swift
//  Gusto-iOS
//
//  Created by 김민우 on 12/14/25.
//
import SwiftUI
import PhotosUI
import ComposableArchitecture



// MARK: View
struct SetProfileView: View {
    // MARK: model
    @Bindable var store: StoreOf<SetProfileFeature>

    // MARK: body
    var body: some View {
        VStack(spacing: 0) {

            Spacer().frame(height: 30)

            // 1. 단계 표시
            FinalIndicator()

            // 2. 메인 타이틀
            MainTitle(
                content: "\(store.userName)님의\n프로필 사진이에요."
            )

            Spacer().frame(height: 8)

            // 3. 서브 타이틀
            SubTitle(
                content: "수정하려면 사진을 탭하세요."
            )

            Spacer().frame(height: 50)

            // 4. 프로필 이미지
            ProfilePhotoPicker(
                onChange: { newImage in
                    store.send(.setProfileImage(newImage))
                }
            )

            Spacer()

            // 5. 하단 버튼
            SubmitButton(
                label: "그대로 가져가기",
                isValid: true,
                action: {
                    store.send(.submit)
                }
            )
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

fileprivate struct FinalIndicator: View {
    var body: some View {
        VStack(spacing: 0) {
            // 디자인 시안의 3-dot 스타일을 그대로 재현

            Text("Final")
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

fileprivate struct SubTitle: View {
    let content: String

    var body: some View {
        Text(content)
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
    }
}

fileprivate struct ProfilePhotoPicker: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var profileUIImage: UIImage? = nil
    
    let onChange: (Data) -> Void

    var body: some View {
        let profileUIImage = self.profileUIImage
        
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
            ZStack {
                if let profileUIImage {
                    Image(uiImage: profileUIImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    // Placeholder
                    Color.gray.opacity(0.15)
                        .overlay(
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .padding(26)
                                .foregroundColor(.gray.opacity(0.7))
                        )
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("프로필 사진 선택")
        .task(id: selectedItem) {
            guard let selectedItem else { return }

            // PhotosPicker에서 URL이 아니라 데이터/객체를 로딩합니다.
            if let data = try? await selectedItem.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                self.profileUIImage = uiImage

                // Feature에 이미지 데이터 전달 (프로젝트 액션명에 맞게 조정)
                onChange(data)
            }
        }
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
    SetProfileView(
        store: Store(initialState: SetProfileFeature.State(userName: "김철수")) {
            SetProfileFeature()
        }
    )
}
