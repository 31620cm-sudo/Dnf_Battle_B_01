<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    }
    body { 
        background-color: var(--bg-color); color: var(--text-color);
        font-family: 'Segoe UI', sans-serif; margin: 0; padding: 40px;
        display: flex; flex-direction: column; align-items: center;
    }
    h2 { color: #fff; font-size: 26px; margin-bottom: 20px; }
    .card {
        background: var(--card-bg); border: 1px solid #30363d; 
        padding: 30px; border-radius: 12px; width: 450px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.5);
    }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; font-size: 14px; margin-bottom: 5px; color: #8b949e; }
    .form-group input, .form-group select {
        width: 100%; padding: 10px; background: #0d1117; border: 1px solid #30363d;
        color: #fff; border-radius: 6px; box-sizing: border-box;
    }
    .btn-submit {
        width: 100%; padding: 12px; background: var(--success); color: #fff;
        border: none; border-radius: 6px; font-weight: bold; cursor: pointer; font-size: 16px;
    }
    .btn-submit:hover { filter: brightness(1.1); }
    .result-box {
        margin-top: 20px; background: #1f242c; border: 1px solid var(--primary);
        padding: 20px; border-radius: 8px;
    }
    .stat-row { display: flex; justify-content: space-between; margin: 8px 0; font-size: 14px; }
    .stat-label { color: #8b949e; }
    .stat-value { color: #fff; font-weight: bold; }
    .btn-next {
        display: block; text-align: center; margin-top: 15px; padding: 10px;
        background: var(--primary); color: #fff; text-decoration: none; border-radius: 6px; font-weight: bold;
    }
    .error-box {
        margin-top: 20px; background: rgba(218,54,51,0.1); border: 1px solid var(--error);
        padding: 15px; border-radius: 8px; color: #ff7b72; font-size: 14px;
    }
</style>
</head>
<body>

<h2>🎮 CHARACTER CREATION LOUNGE</h2>

<div class="card">
    <form method="post" action="createCharacter.jsp">
        <div class="form-group">
            <label>플레이어 검증 ID (요구사항: "hero")</label>
            <input type="text" name="playerId" value="hero" required>
        </div>
        <div class="form-group">
            <label>캐릭터명</label>
            <input type="text" name="characterName" placeholder="원하는 닉네임을 입력하세요" required>
        </div>
        <div class="form-group">
            <label>직업 선택</label>
            <select name="job">
                <option value="전사">전사 (물리공격)</option>
                <option value="마법사">마법사 (마법공격)</option>
            </select>
        </div>
        <div class="form-group">
            <label>초기 설정 레벨</label>
            <input type="number" name="level" value="1" min="1" max="100" required>
        </div>
        <button type="submit" class="btn-submit">✨ 캐릭터 생성 및 전장 진입</button>
    </form>

<%
    // POST 요청 처리 (비즈니스 로직 연산)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        
        String playerId = request.getParameter("playerId");
        String characterName = request.getParameter("characterName");
        String job = request.getParameter("job");
        int level = Integer.parseInt(request.getParameter("level"));

        전투 battleControl = new 전투();
        // 플레이어 체크('hero') 후 직업별 상속 객체(전사/마법사) 동적 생성
        캐릭터 신규캐릭터 = battleControl.캐릭터생성(playerId, characterName, job, level);

        if (신규캐릭터 != null) {
            // 핵심 학습포인트: 세션에 생성된 캐릭터 객체와 정보를 바인딩하여 공유
            session.setAttribute("myCharacter", 신규캐릭터);
            session.setAttribute("playerId", playerId);
            session.setAttribute("jobName", job);
%>
            <div class="result-box">
                <h3 style="color: #56d364; margin-top:0; font-size: 16px;">고유 캐릭터 생성 성공!</h3>
                <div style="font-size:12px; color:#8b949e; margin-bottom:10px;">인벤토리 내부 구조 자동 활성화 (Composition)</div>
                <hr style="border:0; border-top:1px solid #30363d; margin:10px 0;">
                
                <div class="stat-row"><span class="stat-label">이름</span><span class="stat-value"><%= 신규캐릭터.get캐릭터명() %></span></div>
                <div class="stat-row"><span class="stat-label">직업</span><span class="stat-value" style="color:#ffa657;"><%= job %></span></div>
                <div class="stat-row"><span class="stat-label">레벨</span><span class="stat-value" style="color:var(--primary);"><%= 신규캐릭터.get레벨() %> Lv</span></div>
                <div class="stat-row"><span class="stat-label">생명력 (HP)</span><span class="stat-value" style="color:#ff7b72;"><%= 신규캐릭터.getHp() %></span></div>
                <div class="stat-row"><span class="stat-label">기본 공격력</span><span class="stat-value" style="color:#d2a8ff;"><%= 신규캐릭터.get공격력() %> (<%= 신규캐릭터.get공격속성() %>)</span></div>
                <div class="stat-row"><span class="stat-label">기본 가방칸</span><span class="stat-value" style="color:#79c0ff;"><%= 신규캐릭터.get인벤토리멤버().get최대용량() %>칸 (Empty)</span></div>
                
                <a href="attackMonster.jsp" class="btn-next">사냥터 및 시스템 검증 스테이지 이동 ➔</a>
            </div>
<%
        } else {
%>
            <div class="error-box">
                <h4 style="margin: 0 0 5px 0;">⚠️ 캐릭터 생성 실패</h4>
                <p style="margin: 0;">플레이어 체크에 실패했습니다. 유효한 플레이어 ID("hero")를 입력해 주십시오.</p>
            </div>
<%
        }
    }
%>
</div>

</body>
</html>