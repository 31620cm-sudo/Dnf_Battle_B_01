package game;

public abstract class 캐릭터 {
    protected String 캐릭터명;
    protected int 레벨;
    protected int hp;
    protected int 공격력;
    protected String 공격속성;
    
    // 캐릭터 생성 시 빈 인벤토리가 자동으로 함께 생성됨 (Composition)
    protected 인벤토리 인벤토리멤버 = new 인벤토리();

    // Getter
    public String get캐릭터명() { return 캐릭터명; }
    public int get레벨() { return 레벨; }
    public int getHp() { return hp; }
    public int get공격력() { return 공격력; }
    public String get공격속성() { return 공격속성; }
    public 인벤토리 get인벤토리멤버() { return 인벤토리멤버; }

    // 추상 메서드
    public abstract float 스킬발동();
}