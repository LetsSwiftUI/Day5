#  TCA

## Navigation

### 1. Tree Type
### 2. Stack Type
> 우리의 화면은 depth가 깊지 않기 때문에 tree base가 아닌 stack base로 진행

#### Under iOS 16 에서 사용 가능한 navigationLink
- ifLet + NavigationLink(_,tag:,selection:)
```swift
          NavigationLink(
            "Load optional counter that starts from \(row.count)",
            tag: row.id,
            selection: viewStore.binding(
              get: \.selection?.id,
              send: { .setNavigation(selection: $0) }
            )
          ) {
            IfLetStore(self.store.scope(state: \.selection?.value, action: \.counter)) {
              CounterView(store: $0)
            } else: {
              ProgressView()
            }
          }
```

- ifLet + NavigationLink(),isActive:)
```swift
      NavigationLink(
        "Load optional counter",
        isActive: $store.isNavigationActive.sending(\.setNavigation)
      ) {
        if let store = store.scope(state: \.optionalCounter, action: \.optionalCounter) {
          CounterView(store: store)
        } else {
          ProgressView()
        }
      }
```

#### iOS 17+ 에서 사용 가능한 navigation
```swift

    .navigationDestination(
      item: $store.scope(state: \.destination?.drillDown, action: \.destination.drillDown)
    ) { store in
      CounterView(store: store)
    }
```

#### ios 16+ 에서 사용 가능한 NavigationStack [채택]
> 타협안, 16 이하에서는 앞서 기재한 전략을 사용하고 16 이상에 대해서는 이 방법으로 화면 이동을 하겠다.
swift-composable-architecture의 casestudies에서 04-NavigationStack 참고

- 1.공통으로 필요한 것

1-1. Reducer의 enum Path
    - 이 enum을 NavigationStack의 destination에서 switch 문으로 다음 뷰를 선언
    - 이 enum을 State, Action의 Type으로 사용함
    - 자식 뷰의 reducer 타입을 프로토콜 처럼 선언해두었기 때문에 tca가 주입해줄 수 있는 것으로 보임
```swift
@Reducer(state: .equatable)
enum Path {
    case nextView1(SubReducer1)
    case nextView2(SubReducer2)
    //...
}
```

1-2. State의 path
    - 자식 뷰의 state를 Stack으로 들고있음
    - 이 stack에 append하면 navigation stack에 들어가고 화면에 appear 됨
    - 이 stack에 pop하면 마지막부터 disappear 됨
```swift
@ObservableState
struct State: Equatable {
    var path = StackState<Path.State>()
}
```

1-3. Action의 case path(StackActionOf<Path>)
    - 자식 뷰의 action을 Stack으로 들고있음
    - 자식에서 action이 발생한 후 부모로 포워딩 되는 것을 받을 수 있음
    - 자식 뷰에서 버튼 클릭이 발생한 후 부모 뷰에서 어떻게 처리할 지 결정할 수 있음
    - action 안에서 switch 문으로 자식 뷰로 붙어 받은 action을 분기하여 처리할 수 있음
```swift
Reduce { state, action in
    switch action {
        case let .path(action):
            switch action {
                case .element(id: _, action: .nextView1(.nextView1Action1)):
                    // 하위 nextView1의 nextViewAction1이 send되고 난 후 포워딩
                    return .none
                case .element(id: _, action: .nextView2(.nextView2Action3))
                case .default
            }
            return .none
    }
}
}
```
1-4. Reducer에 붙는 forEach
- 이 forEach를 통해 자식 뷰의 state와 action이 embeding 된다.
```
} // reducer의 끝
.forEach(\.path, action: \.path)
```

##### [참고] 포워딩 받은 후에 자식 state를 결과로 공유 받고 싶다면?
(1) action에 던져진 parameter는 forwarding 될 때 같이 전달되는 점을 이용한다.
- action에 전달되는 값이 아니라 다른 state 값을 원한다면 2번 사용
```swift
switch action {
    case let .element(id: _, action: .screenB(.forwardingToParamToParent(args))):
        return .none
    case let .element
```
(2) @Shared 사용
- 부모의 state에서 @Shared state를 선언하고 path에 append할 때 넘기도록 하자.
- 02-SharedState-Onboarding 참고
```swift
  @ObservableState
  struct State {
    var path = StackState<Path.State>()
    @Shared var signUpData: SignUpData
  }
  //...
    Reduce { state, action in
      switch action {
      case .path(.element(id: _, action: .topics(.delegate(.stepFinished)))):
        state.path.append(.summary(SummaryFeature.State(signUpData: state.$signUpData)))
        return .none
        }
    }
```

    
2. 선택 가능한 것
2-1. NavigationLink 사용하기
```swift
NavigationLink(state: Feature.Path.State.case1(Feature.State){
    NextView()
}
```

2-2. Button action에서 Reducer로 넘기고 Reducer 안에서 path.append()하기 
```swift
//view
Button(action: {
    store.send(.tapLink(param))
}) {
    buttonView()
}

//reducer
case let .tapLink(param):
    state.path.append(Feature.State)
```

