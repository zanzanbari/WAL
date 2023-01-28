# 잔잔한 인생에 한줄기 소리, 왈!
> 기분이 축 쳐질 때, 열일하기 위한 자극이 필요할 때,누군가 당신의 곁에서 어떠한 말이라도 해주길 바란 적이 있나요?     
당신이 원하는 타입의 응원으로, 하루에 한 번쯤은 미소지어 보세요.


![start](https://user-images.githubusercontent.com/63235947/215273033-395fceba-44a4-43c4-8cca-9c982c80b365.png)
![GUI](https://user-images.githubusercontent.com/63235947/215273380-7dba23fa-548a-4f7e-bddb-beab70d13347.png)
![GUI-1](https://user-images.githubusercontent.com/63235947/215273398-728df95c-cf35-421e-b6c0-b770900d445f.png)
![GUI-2](https://user-images.githubusercontent.com/63235947/215273389-95b0d91e-062b-4f6d-b5fc-04953332e865.png)
![GUI-3](https://user-images.githubusercontent.com/63235947/215273386-5a646e0c-0776-44e4-997f-a42a9679a581.png)
   


<br>

## 1️⃣ 소개


#### 1) 개발기간 : 2022.04.08~2023.02.
#### 2) 출시날짜 : 2023.02
#### 3) Figma, Notion, Slack, Zoom, GoogleMeet 사용

#### 🟠 [앱스토어에서 다운받기](~~~)
#### 🟡 [소개 노션 보러가기](https://www.notion.so/WAL-cde83326689247dfabaf712245f359fe)
#### 🟢 [@zanzanbari_world 인스타그램 보러가기](https://www.instagram.com/zanzanbari_world/) 

<br>


## 2️⃣ 기능 및 개발 담당

|왈 iOS 개발자|기능 담당|
|:-:|:-:|
|김루희|로그인/온보딩/설정/푸시|
|김소연|메인|
|배은서|왈소리 만들기|
|최이준|왈소리 히스토리|


|소셜로그인|온보딩|메인|왈소리 만들기|왈소리 히스토리|
|:-:|:-:|:-:|:-:|:-:|
|![IMG_7068](https://user-images.githubusercontent.com/59593430/209605046-d5be7125-9573-4815-90b7-f730767306c7.PNG)|![image 2](https://user-images.githubusercontent.com/59593430/209605499-4982a0a8-c3c0-4e38-b2b2-c8f3677c2fdb.png)|![IMG_7069](https://user-images.githubusercontent.com/59593430/209605075-9afda557-431a-4cb8-914b-50046599a1c2.PNG)|![IMG_7070](https://user-images.githubusercontent.com/59593430/209605087-469e8bf5-ec06-436c-a475-cc386d4b8fea.PNG)|![IMG_7071](https://user-images.githubusercontent.com/59593430/209605095-cc6e358f-bc05-4abe-bf0a-98f79398b761.PNG)|
|애플 로그인 <br> 카카오 로그인|UICollectionView를 사용하여 사용자 별 맞춤 옵션 설정|1. UICollectionView를 사용하여 UI 구현 <br> 2. enum을 통해 왈소리 도착, 도착 전, 오늘의 왈소리 모두 도착 등의 case 분기처리 | 1. UITextView를 통해 사용자의 입력값 관리 <br> 2. Calendar, UIPickerView를 사용하여 예약 날짜 및 시간 선택 | 1. UITableView의 section을 나눠 보내는 중, 완료의 경우 분기처리 <br> 2. 탭 했을 때, 꾹 눌렀을 때 등의 사용자 인터랙션 대응 |


<br>

## 3️⃣ 기술 스택
| 사용 기술 스택 |이유|
|:-:|:-:|
|`UIKit`|iOS Framework|
|`RxSwift` `RxCocoa`|비동기 처리|
|`SnapKit`| 코드 기반 오토레이아웃 |
|`Then`| 간결한 인스턴스 선언 |
|`Moya`| 서버통신 |
|`WALKit`| 디자인시스템 및 컴포넌트 SPM으로 관리|
|`Lottie` `Gifu`|런치스크린 및 로딩뷰|
|`KakaoSDK` `Apple Login`| 소셜로그인|
|`FCM` |푸시알림 구현|
|`SPM` `Cocoapods`|의존성 관리 도구|

<br>

## 4️⃣ 폴더링 및 컨벤션
![쟌쟌 iOS-1](https://user-images.githubusercontent.com/63235947/215274379-03bffae2-a149-4d86-8ef6-bab6dc7a8564.png)
![쟌쟌 iOS](https://user-images.githubusercontent.com/63235947/215274385-a359dd0d-c76d-44be-8c62-6f6802aeaae9.png)

## 5️⃣ 트러블슈팅
#### 김루희

> 사용자 액세스 토큰 및 온보딩 처리 상태에 따라 첫 시작화면 분기처리 고민

- 다양한 경우들이 존재
    1. 자동로그인 → 액세스토큰 저장
    2. 로그아웃 → 액세스토큰 삭제
    3. 액세스 토큰 만료 → 재발급 API 호출 로직
    4. 재발급 토큰 만료 → 로그아웃 로직
    5. 탈퇴 → 사용자 정보 및 토큰 삭제

- **사용자가 왈 서비스에 가입했는지 (액세스토큰 발급)**
- **온보딩 과정을 완료했는지 (완료했다면 닉네임이 로그인 API 응답값으로 옴)**

위 과정들에 따라 첫 진입 화면이 달라서 그에 따른 경우의 수가 다르다. 온보딩 완료까지 해서 메인 뷰에 진입한 유저를 기존 유저라고 할 때,

1. 닉네임 O → 메인

2. 닉네임 X, 액세스토큰 O → 온보딩

3. 닉네임 X, 액세스토큰 O → 로그인

SceneDelegate와 LoginViewController에서 **액세스토큰과 닉네임을 `UserDefaults`에 저장해** 해당 값을 기준으로 분기처리해서 첫 진입 시점에 보여줄 시작 화면을 결정해줬다.

`SceneDelegate`

```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    
    // 닉네임O, 액세스토큰 O -> 자동로그인 -> 메인
    guard let nickname = UserDefaultsHelper.standard.nickname else { return }
    guard let accesstoken = UserDefaultsHelper.standard.accesstoken else { return }
    if nickname != "" {
        window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        window?.makeKeyAndVisible()
    } else {
        // 닉네임X, 액세스토큰 O -> 온보딩
        if accesstoken != "" {
            window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
            window?.makeKeyAndVisible()
        } else { // 닉네임X, 액세스토큰 X -> 로그인
            window?.rootViewController = LoginViewController()
        }
    }
    window?.makeKeyAndVisible()
}
```

`LoginViewController`

```swift
private func pushToHome() {
    guard let nickname = UserDefaultsHelper.standard.nickname else { return }
    if nickname == "" {
        transition(OnboardingViewController(), .presentFullNavigation)
    } else {
        // 로그인 -> 완료버튼을 눌러서 서버통신 성공인 경우에 -> 메인화면으로 이동
        transition(MainViewController(), .presentFullNavigation)
    }
}
```

</br>
<hr>

#### 김소연
> 동적 레이아웃(메인화면의 경우 사용자에 따라서, 상황에 따라서 여러 UI가 보여지게 되었다.)의 대응 
  - 아침, 점심, 저녁 왈소리를 어떻게 선택했는가? 
  - 예약한 왈소리가 있는가?
  - 현재 확인할 수 있는 왈소리/확인한 왈소리는 몇개인가?
  - 오늘 도착한 왈소리를 모두 읽었는가? 

</br>

위의 상황들을 포함한 여러 상황에 동적으로 UI가 변경되는 화면이었기에, 이를 **enum의 case로 관리**
1. 왈소리 데이터 타입 (아침/점심/저녁/사용자 직접 작성)
```
enum WALDataType {
    case morning
    case lunch
    case evening
    case special
    
    var image: UIImage {
        switch self {
        case .morning, .lunch, .evening:
            return WALIcon.imgPawActive.image
        case .special:
            return WALIcon.imgPawSpecial.image
        }
    }
    
    var color: UIColor {
        switch self {
        case .morning, .lunch, .evening:
            return UIColor.orange100
        case .special:
            return UIColor.mint100
        }
    }
}
```

</br>

2. 왈소리 컨텐츠의 타입 (드립/주접/위로/꾸중)
```
enum WALContentType: Int {
    case special = -1
    case fun = 0
    case love = 1
    case cheer = 2
    case angry = 3
    
    var walImage: UIImage {
        switch self {
        case .special:
            return WALIcon.imgWalbbongSpecial.image
        case .fun:
            return WALIcon.imgWallbbongFun.image
        case .love:
            return WALIcon.imgWallbbongLove.image
        case .cheer:
            return WALIcon.imgWallbbongCheer.image
        case .angry:
            return WALIcon.imgWallbbongAngry.image
        }
    }
}
```

</br>

3. 메인 화면 캐릭터/타이틀 분기처리
```
enum WALStatus {
    case sleeping
    case arrived
    case checkedAvailable
    case checkedAll
    
    var subTitle: String {
        switch self {
        case .sleeping:
            return "왈뿡이가 자는 시간이에요. 아침에 만나요!"
        case .arrived, .checkedAvailable, .checkedAll:
            return "다들 밥 잘 먹어! 난 뼈다구가 젤루 좋아"
        }
    }
    
    var content: String {
        switch self {
        case .sleeping:
            return ""
        case .arrived:
            return "왈소리가 도착했어요\n발바닥을 눌러 확인해주세요"
        case .checkedAvailable:
            return "왈소리가 열심히 달려오고 있어요"
        case .checkedAll:
            return "오늘의 왈소리가 전부 도착했어요"
        }
    }
    
    var walImage: UIImage {
        switch self {
        case .sleeping:
            return WALIcon.imgWalBBongSleeping.image
        case .arrived:
            let walArrivedImageList: [UIImage] = [WALIcon.imgWalBBongArrive1.image,
                                                  WALIcon.imgWalBBongArrive2.image,
                                                  WALIcon.imgWalBBongArrive3.image]
            return walArrivedImageList.randomElement() ?? WALIcon.imgWalBBongArrive1.image
        case .checkedAll, .checkedAvailable:
            return WALIcon.imgWalBBongWaiting.image
        }
    }
}
```

</br>

> 오늘의 왈소리 중 확인할 수 있는/확인한 왈소리의 분기
`PATCH`를 통해 확인한 경우, 서버의 DB에서 확인한 왈소리로 업데이트 구현 
```
    var path: String {
        switch self {
        case .main:
            return "/main"
        case .mainItem(let param):
            return "/main/\(param)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .main:
            return .get
        case .mainItem:
            return .patch
        }
    }
```

<hr>
<br>

## 5️⃣ 회고 
#### 김루희
- 인증이라는 한 사이클을 체험해본 경험이 없었는데, 실제 서비스에서 인증이 중요하고 고려할 부분이 많은 단계라는 걸 알 수 있었다.
    - 사용자의 정보를 어떻게 저장하고 관리해야 하는지
    - 자동 로그인을 구현하기 위한 과정
    - 보안을 위해서 액세스 토큰 만료 기간의 적정기간과 그에 따른 로그아웃 처리 등을 배웠다.
    
- 특히, 종종 어떤 서비스를 사용하다가 일정 기간 앱을 들어가지 않으면 화면에 데이터가 뜨지 않는 경우를 보았는데 이 경우 **사용자로서 느끼는 경험이 부정적이고, 의문이 들 수 있다는 걸 바탕으로 왈을 개발하면서 고려**하고자 노력했다.
- **추후 개선하고 싶은 부분은** UserDefaults에 저장한 정보들을 **Keychain을 통해 저장해보자는 것**이다. 보안에 있어 민감한 액세스 토큰, 리프레시 토큰을 저장하기 적합하기 때문이다.

<hr>

#### 김소연
- 코드를 개선하는 과정 속에서 enun을 사용하게 되었다. 
  - enum으로 나타날 수 있는 경우의 수를 case로 나눠서 그에 맞는 Image, Color, Constraints 등을 관리하는 방법에 대해 알게 되었다. 

- QA를 진행하면서 기획, 디자인에 대해 꼼꼼하게 이해하고 정리한 뒤, 개발을 진행할 때 보다 많은 경우의 수를 고려하면서 구현할 수 있다는 것을 알게 되었다. 
- 꼼꼼한 확인이 보다 유연한 사고의 확장으로 이어진다는 것을 배웠다. 

- 개선하고 싶은 부분은 아직까지도 로우한 값으로 관리되고 있는 부분들에 대해서 좀 더 추상화된 방법으로 코드를 작성하고 싶다.
- 또한, 기획이 변경될 경우에 대비해서 enum의 case로 관리하는 것보다 더 유연한 대처 방법을 찾고 싶다. (아침, 점심, 저녁이 아니라 다른 상황에 왈소리가 추가되는 경우 등이 있을 수 있으므로)

<br>
<hr>
