<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="game.전투, game.캐릭터" %>
<!DOCTYPE html>
<html>
<head>
<title>게임 시스템 - 몬스터 공격</title>
<style>
    body { font-family: sans-serif; margin: 30px; }
    .box { border: 1px solid #ccc; padding: 20px; border-radius: 5px; width: 450px; background: #fdfdfd; }
    .battle-log { margin-top: 20px; padding: 15px; border-left: 5px solid #ffc107; background: #fffbeb; width: 450px; font-family: monospace; }
    .error { margin-top: 20px; padding: 15px; border-left: 5px solid #dc3545; background: #fff5f5; width: 450px; }
</style>
</head>
<body>

<h2>[UC2] 몬스터 공격 UI</h2>

<%
    // 세션으로부터 이전 페이지에서 생성된 캐릭터 정보를 획득합니다.
    캐릭터 myChar = (캐릭터) session.getAttribute("myCharacter");
    String savedPlayerId = (String) session.getAttribute("playerId");

    if (myChar == null) {
%>
        <div class="error">
            <p>보유 중인 캐릭터가 없습니다. 먼저 캐릭터를 생성해주세요.</p>
            <button onclick="location.href='createCharacter.jsp'">캐릭터 생성하러 가기</button>
        </div>
<%
    } else {
%>
        <div class="box">
            <h3>현재 대기 중인 캐릭터 정보</h3>
            <ul>
                <li><b>이름(레벨):</b> <%= myChar.get캐릭터명() %> (<%= myChar.get레벨() %> Lv)</li>
                <li><b>현재 공격력:</b> <%= myChar.get공격력() %></li>
            </ul>
            
            <form method="post" action="attackMonster.jsp">
                <label>플레이어 검증 ID 검사 (임의 수정 가능):</label>
                <input type="text" name="attackPlayerId" value="<%= savedPlayerId %>" style="width:90%; padding:5px;"><br><br>
                <button type="submit" style="width:100%; padding:10px; background:#dc3545; color:#fff; border:none; font-weight:bold; cursor:pointer;">⚔ 몬스터 공격 (스킬 발동)</button>
            </form>
            <br>
            <button onclick="location.href='createCharacter.jsp'" style="width:100%; padding:5px; background:#6c757d; color:#fff; border:none; cursor:pointer;">처음으로 돌아가기</button>
        </div>
<%
    }

    // 공격 버튼 클릭(POST) 시 시퀀스 처리
    if ("POST".equalsIgnoreCase(request.getMethod()) && myChar != null) {
        String attackPlayerId = request.getParameter("attackPlayerId");
        
        전투 battleControl = new 전투();
        // 시퀀스 다이어그램 2번선: 몬스터공격 호출
        String 공격결과 = battleControl.몬스터공격(attackPlayerId, myChar);

        if (공격결과.contains("없습니다") || 공격결과.contains("존재하지")) {
%>
            <div class="error">
                <h3>몬스터 공격 실패</h3>
                <hr>
                <p style="color:red; font-weight:bold;">❌ <%= 공격결과 %></p>
            </div>
<%
        } else {
%>
            <div class="battle-log">
                <h3>⚔ 전투 로그 (Battle Log)</h3>
                <hr>
                <p><b>공격자:</b> <%= myChar.get캐릭터명() %></p>
                <p><b>수행 내역:</b> <%= 공격결과 %></p>
                <p style="color: blue; font-weight: bold;">✔ 데미지 연산 및 등급 판정이 정상 완료되었습니다.</p>
            </div>
<%
        }
    }
%>

</body>
</html>