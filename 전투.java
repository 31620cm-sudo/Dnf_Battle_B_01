package game;

public class 전투 {
    private 플레이어 플레이어엔티티 = new 플레이어();

    // 다이어그램의 캐릭터생성 행위 구현
    public 캐릭터 캐릭터생성(String 플레이어id, String 캐릭터명, String 직업, int 레벨) {
        // 1. 플레이어체크 수행
        if (!플레이어엔티티.플레이어체크(플레이어id)) {
            return null; // 검증 실패 시 null 반환
        }

        // 2. 직업에 따른 캐릭터 객체 생성 및 반환
        if ("전사".equals(직업)) {
            return new 전사(캐릭터명, 레벨);
        } else if ("마법사".equals(직업)) {
            return new 마법사(캐릭터명, 레벨);
        }
        return null;
    }

    // 다이어그램의 몬스터공격 행위 구현
    public String 몬스터공격(String 플레이어id, 캐릭터 공격자) {
        // 1. 플레이어체크 수행
        if (!플레이어엔티티.플레이어체크(플레이어id)) {
            return "공격 권한이 없습니다.";
        }

        if (공격자 == null) {
            return "공격할 캐릭터가 존재하지 않습니다.";
        }

        // 2. 스킬 발동 및 데미지 계산
        float 데미지 = 공격자.스킬발동();
        String 스킬명 = (공격자 instanceof 전사) ? "검 휘두르기" : "파이어볼";
        
        // 3. 데미지에 따른 등급 판정
        String 등급 = "";
        if (데미지 >= 200) {
            등급 = "S급 공격";
        } else if (데미지 >= 100) {
            등급 = "A급 공격";
        } else {
            등급 = "B급 공격";
        }

        // 결과 문자열 반환 (UI단에서 파싱 혹은 출력용 부가정보 포함)
        return String.format("[%s] 발동! | 데미지: %.1f | 판정: %s", 스킬명, 데미지, 등급);
    }
}