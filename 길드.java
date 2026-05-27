package game;

import java.util.ArrayList;
import java.util.List;

public class 길드 {
    private String 길드명;
    private List<캐릭터> 캐릭터리스트;
    private int 최대인원;

    public 길드(String 길드명) {
        this.길드명 = 길드명;
        this.캐릭터리스트 = new ArrayList<>();
        this.최대인원 = 5; // 길드 정원은 최대 5명
    }

    public boolean 캐릭터가입(캐릭터 대상캐릭터) {
        if (캐릭터리스트.size() >= 최대인원) {
            return false; // 길드 정원이 가득 차면 가입 불가
        }
        return 캐릭터리스트.add(대상캐릭터);
    }

    // Getter
    public String get길드명() { return 길드명; }
    public List<캐릭터> get캐릭터리스트() { return 캐릭터리스트; }
    public int get최대인원() { return 최대인원; }
}