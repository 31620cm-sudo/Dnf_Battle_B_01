# 유스케이스 다이어그램

## 다이어그램

```mermaid
flowchart LR
    %% Actor Definition
    플레이어Actor(("플레이어 (Actor)"))

    %% System Boundary
    subgraph DnF_Battle_B_01 ["게임 시스템 (DnF_Battle_B_01)"]
        UC1(["캐릭터생성"])
        UC2(["몬스터공격"])
        UC3(["아이템획득"])
        UC4(["길드가입"])
        UC5(["플레이어체크"])
    end

    %% Relationships
    플레이어Actor --- UC1
    플레이어Actor --- UC2
    플레이어Actor --- UC3
    플레이어Actor --- UC4

    %% Include Relationships
    UC1 -. "«include»" .-> UC5
    UC2 -. "«include»" .-> UC5
    UC3 -. "«include»" .-> UC5
    UC4 -. "«include»" .-> UC5

## 구성 요소

### 액터 (Actor)
- **플레이어** : 시스템을 사용하는 외부 주체

### 유스케이스 (Use Case)
- **캐릭터생성** : 플레이어 ID, 캐릭터명, 직업, 레벨을 입력받아 캐릭터를 생성
- **몬스터 공격** : 직업별 스킬로 몬스터에게 데미지를 가함
- **플레이어체크** : 유효한 플레이어인지 검증 (보조 유스케이스)

### 관계 (Relationship)

| 관계 종류 | 표기법 | 적용 대상 |
| --- | --- | --- |
| 연관 (Association) | 실선 | 플레이어 ↔ 캐릭터생성, 플레이어 ↔ 몬스터 공격 |
| 포함 (Include) | 점선 + «include» | 캐릭터생성 → 플레이어체크, 몬스터 공격 → 플레이어체크 |

### 관계 설명
- 캐릭터생성과 몬스터 공격은 **반드시** 플레이어체크를 호출하므로 **«include»** 관계로 표현
- 화살표 방향: 포함하는 쪽(base) → 포함되는 쪽(included)
