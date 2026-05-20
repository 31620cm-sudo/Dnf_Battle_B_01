<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="game.전투, game.캐릭터" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>RPG 대시보드 - 캐릭터 생성</title>
<style>
    :root {
        --bg-color: #0d1117;
        --card-bg: #161b22;
        --text-color: #c9d1d9;
        --primary: #58a6ff;
        --success: #2ea44f;
        --error: #da3633;
        --neon-glow: 0 0 15px rgba(88, 166, 255, 0.5);
    }
    body { 
        background-color: var(--bg-color); 
        color: var(--text-color);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        margin: 0; padding: 40px;
        display: flex; flex-direction: column; align-items: center;
    }
    h2 { color: #fff; font-size: 28px; text-shadow: 0 0 10px rgba(255,255,255,0.2); margin-bottom: 30px; }
    .card { 
        background: var(--card-bg); border: 1px solid #30363d; 
        padding: 30px; border-radius: 12px; width: 450px; 
        box-shadow: 0 8px 24px rgba(0,0,0,0.5); transition: all 0.3s ease;
    }
    .card:hover { border-color: var(--primary); box-shadow: var(--neon-glow); }
    .form-group { margin-bottom: 20px; }
    label { display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #8b949e; }
    input, select { 
        background: #0d1117; border: 1px solid #30363d; color: #fff;
        padding: 12px; width: 100%; box-sizing: border-box; border-radius: 6px;
        font-size: 15px; transition: border 0.2s;
    }
    input:focus, select:focus { border-color: var(--primary); outline: none; }
    .btn-submit { 
        width: 100%; padding: 14px; background: var(--primary); color: #fff; 
        border: none; border-radius: 6px; font-size: 16px; font-weight: bold; 
        cursor: pointer; transition: background 0.2s; margin-top: 10px;
    }
    .btn-submit:hover { background: #1f6feb; }
    
    /* 결과 템플릿 */
    .result-box { 
        margin-top: 30px; padding: 25px; border-radius: 12px; width: 450px; box-sizing: border-box;
        animation: fadeIn 0.5s ease-out;
    }
    .success-box { background: rgba(46, 164, 79, 0.15); border: 1px solid var(--success); }
    .error-box { background: rgba(218, 54, 51, 0.15); border: 1px solid var(--error); }
    .stat-row { display: flex; justify-content: space-between; margin: 10px 0; font-size: 15px; }
    .stat-label { color: #8b949e; }
    .stat-value { color: #fff; font-weight: bold; }
    .btn-next {
        display: block; text-align: center; width: 100%; box-sizing: border-box;
        padding: 12px; background: var(--success); color: #fff; text-decoration: none;
        border-radius: 6px; font-weight: bold; margin-top: 20px; transition: opacity 0.2s;
    }
    .btn-next:hover { opacity: 0.9; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
</style>
</head>
<body>

<h2>⚔️ HERO RPG : 캐릭터 생성 ⚔️</h2>

<div class="card">
    <form method="post" action="createCharacter.jsp">
        <div class="form-group">
            <label>플레이어 검증 ID</label>
            <input type="text" name="playerId" value="hero" placeholder="ID를 입력하세요" required>
        </div>
        <div class="form-group">
            <label>캐릭터 이름</label>
            <input type="text" name="charName" value="네오 크루세이더" required>
        </div>
        <div class="form-group">
            <label>클래스(직업)</label>
            <select name="job">
                <option value="전사">전사 (Warrior)</option>
                <option value="마법사">마법사 (Mage)</option>
            </select>
        </div>
        <div class="form-group">
            <label>초기 설정 레벨</label>
            <input type="number" name="level" value="15" min="1" max="99" required>
        </div>
        <button type="submit" class="btn-submit">새로운 모험 시작하기</button>
    </form>
</div>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String playerId = request.getParameter("playerId");
        String charName = request.getParameter("charName");
        String job = request.getParameter("job");
        int level = Integer.parseInt(request.getParameter("level"));

        전투 battleControl = new 전투();
        캐릭터 신규캐릭터 = battleControl.캐릭터생성(playerId, charName, job, level);

        if (신규캐릭터 != null) {
            session.setAttribute("myCharacter", 신규캐릭터);
            session.setAttribute("playerId", playerId);
            session.setAttribute("jobName", job);
%>
            <div class="result-box success-box">
                <h3 style="color: #56d364; margin-top:0;">고유 캐릭터 생성 성공!</h3>
                <hr style="border: 0; border-top: 1px solid rgba(255,255,255,0.1); margin: 15px 0;">
                <div class="stat-row"><span class="stat-label">이름</span><span class="stat-value"><%= 신규캐릭터.get캐릭터명() %></span></div>
                <div class="stat-row"><span class="stat-label">직업</span><span class="stat-value" style="color:#ffa657;"><%= job %></span></div>
                <div class="stat-row"><span class="stat-label">레벨</span><span class="stat-value" style="color:var(--primary);"><%= 신규캐릭터.get레벨() %> Lv</span></div>
                <div class="stat-row"><span class="stat-label">생명력 (HP)</span><span class="stat-value" style="color:#ff7b72;"><%= 신규캐릭터.getHp() %></span></div>
                <div class="stat-row"><span class="stat-label">기본 공격력</span><span class="stat-value" style="color:#d2a8ff;"><%= 신규캐릭터.get공격력() %> (<%= 신규캐릭터.get공격속성() %>)</span></div>
                
                <a href="attackMonster.jsp" class="btn-next">몬스터 사냥터로 진입 ➔</a>
            </div>
<%
        } else {
%>
            <div class="result-box error-box">
                <h3 style="color: #ff7b72; margin-top:0;">시스템 가동 실패</h3>
                <hr style="border: 0; border-top: 1px solid rgba(255,255,255,0.1); margin: 15px 0;">
                <p style="margin:0; font-size:14px;">보안 검증 오류: 올바르지 않은 플레이어 ID입니다. 권한을 확인하세요.</p>
            </div>
<%
        }
    }
%>

</body>
</html>