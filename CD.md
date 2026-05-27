```mermaid
classDiagram
    %% Boundary Classes (UI 공간)
    class 캐릭터생성_화면 {
        <<boundary>>
    }
    class 몬스터공격_화면 {
        <<boundary>>
    }
    class 아이템획득_화면 {
        <<boundary>>
    }
    class 길드가입_화면 {
        <<boundary>>
    }

    %% Control Class (비즈니스 로직 중재)
    class 전투 {
        -플레이어엔티티 : 플레이어
        +캐릭터생성(플레이어id : String, 캐릭터명 : String, 직업 : String, 레벨 : int) 캐릭터
        +몬스터공격(플레이어id : String, 공격자 : 캐릭터) String
        +아이템획득(플레이어id : String, 공격자 : 캐릭터, 아이템명 : String, 타입 : String, 가치 : int) String
        +길드가입(플레이어id : String, 가입캐릭터 : 캐릭터, 가입길드 : 길드) String
    }

    %% Entity Classes
    class 플레이어 {
        -플레이어id : String
        +플레이어체크(플레이어id : String) boolean
    }

    class 캐릭터 {
        <<abstract>>
        #캐릭터명 : String
        #레벨 : int
        #hp : int
        #공격력 : int
        #공격속성 : String
        -인벤토리엔티티 : 인벤토리
        +스킬발동()* float
        +get인벤토리() 인벤토리
    }

    class 전사 {
        +스킬발동() float
    }

    class 마법사 {
        +스킬발동() float
    }

    class 인벤토리 {
        -아이템리스트 : List~아이템~
        -최대용량 : int
        +아이템추가(신규아이템 : 아이템) boolean
    }

    class 아이템 {
        -아이템명 : String
        -타입 : String
        -가치 : int
        -등급 : String
    }

    class 길드 {
        -길드명 : String
        -캐릭터리스트 : List~캐릭터~
        -최대인원 : int
        +캐릭터가입(가입캐릭터 : 캐릭터) boolean
    }

    %% 핵심 학습포인트: 복합객체 관계 정의
    캐릭터 "1" *-- "1" 인벤토리 : 캐릭터 삭제 시 인벤토리도 삭제 (Composition)
    인벤토리 "1" *-- "*" 아이템 : 인벤토리 삭제 시 아이템도 삭제 (Composition)
    길드 "1" o-- "*" 캐릭터 : 길드가 해체되어도 캐릭터는 존재 (Aggregation)

    %% 일반 상속 및 연관 관계 정의
    캐릭터 <|-- 전사 : 상속
    캐릭터 <|-- 마법사 : 상속
    전투 ..> 플레이어 : 플레이어체크 위임
    전투 ..> 캐릭터 : 생성 및 조작 조율
    전투 ..> 길드 : 가입 제어 인터랙션

    %% UI 컴포넌트가 컨트롤러를 호출하는 의존 관계
    캐릭터생성_화면 ..> 전투 : 캐릭터 생성 요청
    몬스터공격_화면 ..> 전투 : 몬스터 공격 요청
    아이템획득_화면 ..> 전투 : 아이템 획득 요청
    길드가입_화면 ..> 전투 : 길드 가입 요청