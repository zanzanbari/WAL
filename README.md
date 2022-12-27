# 잔잔한 인생에 한줄기 소리, 왈!

📌  [AppStore 다운받기](~~~)  </br>
📌  [왈 소개 노션](https://www.notion.so/WAL-cde83326689247dfabaf712245f359fe) </br>
📌  [쟌쟌바리 인스타그램](https://www.instagram.com/zanzanbari_world/) </br>

<br>

## 🐶 왈 소개

> 기분이 축 쳐질 때, 열일하기 위한 자극이 필요할 때, </br>
누군가 당신의 곁에서 어떠한 말이라도 해주길 바란 적이 있나요? </br>
당신이 원하는 타입의 응원으로, 하루에 한 번쯤은 미소지어 보세요. </br>

- 개발기간 **:** 2022.04.08 ~ 2023.01.04
- 출시날짜 **:** 2023.01.04
- Figma, Notion 사용
- iOS 개발자 **:** 김루희, 김소연, 배은서, 최이준 

  - 김루희 : 로그인, 온보딩, 설정, Push Notification
  - 김소연 : 메인 
  - 배은서 : 왈소리 만들기
  - 최이준 : 왈소리 히스토리 

<br>


## 🐶 왈 기능 소개

|소셜로그인|온보딩|메인|왈소리 만들기|왈소리 히스토리|
|:-:|:-:|:-:|:-:|:-:|
|![IMG_7068](https://user-images.githubusercontent.com/59593430/209605046-d5be7125-9573-4815-90b7-f730767306c7.PNG)|![image 2](https://user-images.githubusercontent.com/59593430/209605499-4982a0a8-c3c0-4e38-b2b2-c8f3677c2fdb.png)|![IMG_7069](https://user-images.githubusercontent.com/59593430/209605075-9afda557-431a-4cb8-914b-50046599a1c2.PNG)|![IMG_7070](https://user-images.githubusercontent.com/59593430/209605087-469e8bf5-ec06-436c-a475-cc386d4b8fea.PNG)|![IMG_7071](https://user-images.githubusercontent.com/59593430/209605095-cc6e358f-bc05-4abe-bf0a-98f79398b761.PNG)|


- 소셜 로그인
  - 애플 로그인
  - 카카오 로그인
- 온보딩
  - UICollectionView를 사용하여 사용자 별 맞춤 옵션 설정 
- 메인
  - UICollectionView를 사용하여 UI 구현
  - enum을 통해 왈소리 도착, 도착 전, 오늘의 왈소리 모두 도착 등의 case 분기처리 
- 왈소리 만들기
  - UITextView를 통해 사용자의 입력값 관리
  - Calendar, UIPickerView를 사용하여 예약 날짜 및 시간 선택 
  
- 왈소리 히스토리(내역) 
  - UITableView의 section을 나눠 보내는 중, 완료의 경우 분기처리 
  - 탭 했을 때, 꾹 눌렀을 때 등의 사용자 인터랙션 대응 

<br>

## 🐶 왈 기술 스택 소개
- `UIKit` 
- `AutoLayout`
- `SPM` `Cocoapods`
- `Moya`
- `SnapKit` `Then`
- `WALKit`
- `Lottie` `Gifu`
- `KakaoSDK` 
- `Apple Login`
- `Firebase Push Notification`
- `RxSwift` `RxCocoa`

<br>

## 🐶 왈 트러블슈팅
### 🦋 김루희 🦋
> 사용자 액세스 토큰 및 온보딩 처리 상태에 따라 첫 시작화면 분기처리 고민
- 사용자가 왈 서비스에 가입했는지 (액세스토큰 발급)
    1. 자동로그인 - 액세스토큰 저장
    2. 로그아웃 - 액세스토큰 삭제
    3. 액세스 토큰 만료 - 재발급 API 호출 로직
    4. 재발급 토큰 만료 - 로그아웃 로직
    5. 탈퇴 - 사용자 정보 및 토큰 삭제
    
- 온보딩 과정을 완료했는지 즉, 완료 버튼을 누른 시점 or 메인 화면에 진입한 시점에 온보딩 과정을 완료했다고 인지하고 저장해야 한다.

위 과정들에 따라 첫 진입 화면이 달라서 그에 따른 경우의 수가 다르다.   
온보딩 완료까지 해서 메인 뷰에 진입한 유저를 기존 유저라고 할 때,

1. 액세스 토큰 X 
    1. 로그인 완료 X → 로그인 뷰
        1. 온보딩 완료 O → 메인 뷰 (로그아웃/토큰 만료 등의 이유)   
        
        2. 온보딩 완료 X → 온보딩 뷰 (첫 유저)
        
2. 액세스 토큰 O (자동로그인)
    1. 온보딩 완료 O → 메인 뷰 (기존 유저)
   
    2. 온보딩 완료 X → 온보딩 뷰

`SceneDelegate`와 `LoginViewController`에서 액세스토큰과 온보딩완료상태를 `UserDefaults`에 저장해 해당 값을 기준으로 분기처리해서 첫 진입 시점에 보여줄 시작 화면을 결정해줬다.


#### `SceneDelegate`
```

func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        // 액세스토큰 X -> 로그인 화면을 띄워줄 경우
        guard let accesstoken = UserDefaultsHelper.standard.accesstoken else { return }
        if accesstoken == "" {
            window?.rootViewController = LoginViewController()
        } else {
            // 액세스토큰 O -> 자동로그인 -> 근데 아직 온보딩화면을 완료X
            if UserDefaultsHelper.standard.complete == false {
                window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                window?.makeKeyAndVisible()
            } else {
                // 액세스토큰 O -> 자동로그인 -> 완료버튼을 눌러서 서버통신 성공인 경우에 -> 메인화면으로 이동
                window?.rootViewController = UINavigationController(rootViewController: MainViewController())
                window?.makeKeyAndVisible()
            }
        }
        window?.makeKeyAndVisible()
    }

```


#### `LoginViewController`

```
	private func pushToHome() {
        // 어쨌든 이 경우에는 액세스 토큰이 없어서 로그인 단계를 거치는 것
        if UserDefaultsHelper.standard.complete == false {
            let viewController = OnboardingViewController()
            transition(viewController, .presentFullNavigation)
        } else {
            // 로그인 -> 완료버튼을 눌러서 서버통신 성공인 경우에 -> 메인화면으로 이동
            let viewController = MainViewController()
            transition(viewController, .presentFullNavigation)
        }
    }
```


</br>

### 김소연

</br>

### 배은서

</br>

### 최이준 
  

<br>
<br>

## 🐶 왈 회고 
### 🦋 김루희 🦋
- 인증이라는 한 사이클을 체험해본 경험이 없었는데, 실제 서비스에서 인증이 중요하고 고려할 부분이 많은 단계라는 걸 알 수 있었다.
    - 사용자의 정보를 어떻게 저장하고 관리해야 하는지
    - 자동 로그인을 구현하기 위한 과정
    - 보안을 위해서 액세스 토큰 만료 기간의 적정기간과 그에 따른 로그아웃 처리 등을 배웠다.
    
- 특히, 종종 어떤 서비스를 사용하다가 일정 기간 앱을 들어가지 않으면 화면에 데이터가 뜨지 않는 경우를 보았는데 이 경우 **사용자로서 느끼는 경험이 부정적이고, 의문이 들 수 있다는 걸 바탕으로 왈을 개발하면서 고려**하고자 노력했다.
- **추후 개선하고 싶은 부분은** UserDefaults에 저장한 정보들을 **Keychain을 통해 저장해보자는 것**이다. 보안에 있어 민감한 액세스 토큰, 리프레시 토큰을 저장하기 적합하기 때문이다.

</br>

#### 김소연

</br>

#### 배은서

</br>

#### 최이준 
  
<br>
