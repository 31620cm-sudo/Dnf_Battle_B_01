package game;

public class 아이템 {
    private String 아이템명;
    private String 타입; // 무기, 방어구, 물약
    private int 가치;
    private String 등급; // 전설, 희귀, 일반

    public 아이템(String 아이템명, String 타입, int 가치) {
        this.아이템명 = 아이템명;
        this.타입 = 타입;
        this.가치 = 가치;
        this.등급 = 계산등급(가치);
    }

    private String 계산등급(int 가치) {
        if (가치 >= 1000) return "전설(Legendary)";
        if (가치 >= 500) return "희귀(Rare)";
        return "일반(Common)";
    }

    // Getter
    public String get아이템명() { return 아이템명; }
    public String get타입() { return 타입; }
    public int get가치() { return 가치; }
    public String get등급() { return 등급; }
}