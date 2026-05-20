package game;

public abstract class 캐릭터 {
    // 다이어그램의 속성명 및 데이터타입 반영
    protected String 캐릭터명;
    protected int 레벨;
    protected int hp;
    protected int 공격력;
    protected String 공격속성;

    // Getter
    public String get캐릭터명() { return 캐릭터명; }
    public int get레벨() { return 레벨; }
    public int getHp() { return hp; }
    public int get공격력() { return 공격력; }
    public String get공격속성() { return 공격속성; }

    // 다이어그램의 추상 메서드 반영
    public abstract float 스킬발동();
}