package game;

import java.util.ArrayList;
import java.util.List;

public class 인벤토리 {
    private List<아이템> 아이템리스트;
    private int 최대용량;

    public 인벤토리() {
        this.아이템리스트 = new ArrayList<>();
        this.최대용량 = 10; // 인벤토리 최대 용량은 10칸
    }

    public boolean 아이템추가(아이템 신규아이템) {
        if (아이템리스트.size() >= 최대용량) {
            return false; // 인벤토리가 가득 차면 획득 불가
        }
        return 아이템리스트.add(신규아이템);
    }

    // Getter
    public List<아이템> get아이템리스트() { return 아이템리스트; }
    public int get최대용량() { return 최대용량; }
}