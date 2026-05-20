```mermaid
classDiagram
    %% Boundary Classes
    class Create_Character_UI {
        <<boundary>>
    }
    class Attack_Monster_UI {
        <<boundary>>
    }

    %% Entity & Control Classes
    class 플레이어 {
        -플레이어id : String
        +플레이어체크(플레이어id : String)  boolean
    }

    class 캐릭터 {
        <<abstract>>
        #캐릭터명 : String
        #레벨 : int
        #hp : int
        #공격력 : int
        #공격속성 : String
        +스킬발동()*  float
    }

    class 전사 {
        +스킬발동()  float
    }

    class 마법사 {
        +스킬발동() float
    }

    class 전투 {
        <<control>>
        +캐릭터생성(플레이어id : String, 캐릭터명 : String, 직업 : String, 레벨 : int)  캐릭터
        +몬스터공격(플레이어id : String, 공격자 : 캐릭터) String
        -등급부여(대미지 : float)  String
    }

    %% Relationships
    캐릭터 <|-- 전사 : 상속
    캐릭터 <|-- 마법사 : 상속
    
    Create_Character_UI ..> 전투 : 캐릭터 생성 요청
    Attack_Monster_UI ..> 전투 : 몬스터 공격 요청
    
    전투 ..> 플레이어 : <<include>> UC3 실체화
    전투 ..> 캐릭터 : 생성 및 조작

    