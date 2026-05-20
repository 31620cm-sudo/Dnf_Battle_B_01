package game;

public class 전사 extends 캐릭터 {
    public 전사(String 캐릭터명, int 레벨) {
        this.캐릭터명 = 캐릭터명;
        this.레벨 = 레벨;
        this.hp = 레벨 * 100;
        this.공격력 = 레벨 * 15;
        this.공격속성 = "물리공격";
    }

    @Override
    public float 스킬발동() {
        // 전사: "검 휘두르기" -> 데미지 = 공격력 * 1.5
        return this.공격력 * 1.5f;
    }
}