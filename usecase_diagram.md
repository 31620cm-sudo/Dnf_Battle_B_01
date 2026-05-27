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
