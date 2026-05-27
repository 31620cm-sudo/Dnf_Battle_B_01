package game;

public class 전투 {
    private 플레이어 플레이어엔티티 = new 플레이어();

    // 캐릭터 생성
    public 캐릭터 캐릭터생성(String 플레이어id, String 캐릭터명, String 직업, int 레벨) {
        if (!플레이어엔티티.플레이어체크(플레이어id)) {
            return null;
        }
        if ("전사".equals(직업)) {
            return new 전사(캐릭터명, 레벨);
        } else if ("마법사".equals(직업)) {
            return new 마법사(캐릭터명, 레벨);
        }
        return null;
    }

    // 몬스터 공격
    public String 몬스터공격(String 플레이어id, 캐릭터 공격자) {
        if (!플레이어엔티티.플레이어체크(플레이어id)) {
            return "공격 권한이 없습니다.";
        }
        if (공격자 == null) {
            return "공격할 캐릭터가 존재하지 않습니다.";
        }

        float 데미지 = 공격자.스킬발동();
        String 스킬명 = (공격자 instanceof 전사) ? "검 휘두르기" : "파이어볼";
        
        String 등급 = "";
        if (데미지 >= 200) {
            등급 = "S급 공격";
        } else if (데미지 >= 100) {
            등급 = "A급 공격";
        } else {
            등급 = "B급 공격";
        }

        return String.format("[%s] 발동! | 데미지: %.1f | 판정: %s", 스킬명, 데미지, 등급);
    }

    // [신규 기능 1] 아이템 획득 행위 구현
    public String 아이템획득(String 플레이어id, 캐릭터 대상캐릭터, String 아이템명, String 아이템타입, int 아이템가치) {
        // 1. 반드시 플레이어 체크를 한다.
        if (!플레이어엔티티.플레이어체크(플레이어id)) {
            return "보안 실패: 플레이어 권한이 없습니다.";
        }
        if (대상캐릭터 == null) {
            return "실패: 아이템을 적용할 캐릭터가 없습니다.";
        }

        // 2. 아이템 객체 생성 및 등급 자동 판정
        아이템 신규아이템 = new 아이템(아이템명, 아이템타입, 아이템가치);

        // 3. 캐릭터의 인벤토리에 아이템 추가 위임
        boolean 결과 = 대상캐릭터.get인벤토리멤버().아이템추가(신규아이템);

        if (결과) {
            return String.format("성공|%s|%s|%s", 신규아이템.get아이템명(), 신규아이템.get타입(), 신규아이템.get등급());
        } else {
            return "실패: 인벤토리가 가득 차서 아이템을 획득할 수 없습니다. (최대 10칸)";
        }
    }

    // [신규 기능 2] 길드 가입 행위 구현
    public String 길드가입(String 플레이어id, 캐릭터 대상캐릭터, 길드 대상길드) {
        // 1. 반드시 플레이어 체크를 한다.
        if (!플레이어엔티티.플레이어체크(플레이어id)) {
            return "보안 실패: 플레이어 권한이 없습니다.";
        }
        if (대상캐릭터 == null) {
            return "실패: 가입할 캐릭터가 생성되지 않았습니다.";
        }
        if (대상길드 == null) {
            return "실패: 가입하려는 길드가 존재하지 않습니다.";
        }

        // 2. 외부에서 생성되어 관리되는 길드 객체에 가입 요청 (Aggregation)
        boolean 결과 = 대상길드.캐릭터가입(대상캐릭터);

        if (결과) {
            return String.format("성공|%s 길드에 [%s] 캐릭터가 가입되었습니다. (현재원: %d/%d명)", 
                    대상길드.get길드명(), 대상캐릭터.get캐릭터명(), 대상길드.get캐릭터리스트().size(), 대상길드.get최대인원());
        } else {
            return String.format("실패: %s 길드의 정원이 가득 차서 가입할 수 없습니다. (최대 %d명)", 
                    대상길드.get길드명(), 대상길드.get최대인원());
        }
    }
}