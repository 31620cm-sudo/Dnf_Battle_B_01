package game;

public class 플레이어 {
    private String 플레이어id;

    public 플레이어() {
        this.플레이어id = "hero"; // 기본 타겟 검증 ID
    }

    // 다이어그램의 행위명 및 데이터타입 반영
    public boolean 플레이어체크(String 플레이어id) {
        return "hero".equals(플레이어id);
    }
}