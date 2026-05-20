<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="game.전투, game.캐릭터" %>
<!DOCTYPE html>
<html>
<head>
<title>게임 시스템 - 캐릭터 생성</title>
<style>
    body { font-family: sans-serif; margin: 30px; }
    .box { border: 1px solid #ccc; padding: 20px; border-radius: 5px; width: 450px; background: #f9f9f9; }
    .result { margin-top: 20px; padding: 15px; border-left: 5px solid #007bff; background: #f0f7ff; width: 450px; }
    .error { margin-top: 20px; padding: 15px; border-left: 5px solid #dc3545; background: #fff5f5; width: 450px; }
    input, select { margin-bottom: 10px; padding: 6px; width: 95%; }
</style>
</head>
<body>

<h2>[UC1] 캐릭터 생성 UI</h2>
<div class="box">
    <form method="post" action="createCharacter.jsp">
        <label>플레이어 ID (성공 조건: hero)</label><br>
        <input type="text" name="playerId" value="hero" required><br>
        
        <label>캐릭터명</label><br>
        <input type="text" name="charName" value="레오" required><br>
        
        <label>직업 선택</label><br>
        <select name="job">
            <option value="전사">전사</option>
            <option value="마법사">마법사</option>
        </select><br>
        
        <label>레벨 (공격력/스킬 등급 계산용)</label><br>
        <input type="number" name="level" value="10" min="1" required><br>
        
        <button type="submit" style="width:100%; padding:8px; background:#007bff; color:#fff; border:none; cursor:pointer;">캐릭터 생성 요청</button>
    </form>
</div>

<%
    // POST 요청 시 시권스 다이어그램 로직 처리
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String playerId = request.getParameter("playerId");
        String charName = request.getParameter("charName");
        String job = request.getParameter("job");
        int level = Integer.parseInt(request.getParameter("level"));

        전투 battleControl = new 전투();
        // 시퀀스 다이어그램 2번선: 캐릭터생성 호출
        캐릭터 신규캐릭터 = battleControl.캐릭터생성(playerId, charName, job, level);

        if (신규캐릭터 != null) {
            // 세션에 캐릭터를 저장하여 몬스터 공격 페이지로 넘겨줍니다.
            session.setAttribute("myCharacter", 신규캐릭터);
            session.setAttribute("playerId", playerId);
%>
            <div class="result">
                <h3>캐릭터 생성 완료 (성공)</h3>
                <hr>
                <ul>
                    <li><b>캐릭터명:</b> <%= 신규캐릭터.get캐릭터명() %></li>
                    <li><b>직업:</b> <%= job %></li>
                    <li><b>레벨:</b> <%= 신규캐릭터.get레벨() %> Lv</li>
                    <li><b>기본 HP:</b> <%= 신규캐릭터.getHp() %></li>
                    <li><b>기본 공격력:</b> <%= 신규캐릭터.get공격력() %> (<%= 신규캐릭터.get공격속성() %>)</li>
                </ul>
                <p style="color: green; font-weight: bold;">✔ 다음 단계로 이동하여 공격력을 테스트하세요!</p>
                <button onclick="location.href='attackMonster.jsp'" style="padding: 5px 10px; background: #28a745; color: white; border: none; cursor: pointer;">[UC2] 몬스터 공격 화면으로 이동</button>
            </div>
<%
        } else {
%>
            <div class="error">
                <h3>캐릭터 생성 실패</h3>
                <hr>
                <p style="color: red; font-weight: bold;">❌ 올바르지 않은 플레이어 ID입니다. (플레이어체크 실패)</p>
            </div>
<%
        }
    }
%>

</body>
</html>