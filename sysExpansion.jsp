<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="game.전투, game.캐릭터, game.아이템, game.길드, java.util.List" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>RPG 확장 모듈 - 시스템 연산 공간</title>
<style>
    :root {
        --bg-color: #0d1117;
        --card-bg: #161b22;
        --text-color: #c9d1d9;
        --primary: #58a6ff;
        --success: #2ea44f;
        --purple: #a371f7;
        --border-color: #30363d;
    }
    body { 
        background-color: var(--bg-color); color: var(--text-color);
        font-family: 'Segoe UI', sans-serif; margin: 0; padding: 20px 40px;
        display: flex; flex-direction: column; align-items: center;
    }
    .wrapper { width: 600px; }
    .card { 
        background: var(--card-bg); border: 1px solid var(--border-color); 
        padding: 25px; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.5);
        margin-bottom: 25px;
    }
    .status-title { font-size: 16px; font-weight: bold; margin-bottom: 15px; color: #fff; }
    .btn-action { width: 100%; padding: 12px; color: #fff; border: none; border-radius: 6px; font-size: 15px; font-weight: bold; cursor: pointer; }
    .btn-item { background: linear-gradient(135deg, #58a6ff, #0969da); }
    .btn-guild { background: linear-gradient(135deg, #ab7df6, #6f34e3); }
    .btn-action:hover { filter: brightness(1.1); }
    .battle-panel { margin-top: 15px; background: #040609; border: 1px solid var(--primary); padding: 15px; border-radius: 12px; }
    .panel-guild { border-color: var(--purple); }
    .error-box { margin-top:15px; background: rgba(218,54,51,0.1); border: 1px solid #da3633; padding: 15px; border-radius: 12px; }
    .sub-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 10px; }
    .sub-grid input, .sub-grid select { width:100%; padding:8px; background:#0d1117; border:1px solid #30363d; color:#fff; border-radius:4px; box-sizing:border-box; }
    .inventory-list { background: #0d1117; padding: 10px; border-radius: 6px; font-size: 13px; max-height: 150px; overflow-y: auto; margin-top: 10px; border: 1px solid #30363d;}
    .nav-links { display: flex; justify-content: space-between; margin-top: 20px; }
    .back-link { color: #8b949e; text-decoration: none; font-size: 14px; }
    .back-link:hover { color: #fff; }
</style>
</head>
<body>

<div class="wrapper">
    <h2 style="text-align:center; color: #fff; margin-bottom: 20px;">📦 SYSTEM EXPANSION DASHBOARD 📦</h2>

<%
    캐릭터 myChar = (캐릭터) session.getAttribute("myCharacter");
    String savedPlayerId = (String) session.getAttribute("playerId");

    // 공용 테스트 인스턴스인 가상 길드 생성 및 세션 바인딩
    길드 testGuild = (길드) session.getAttribute("globalGuild");
    if (testGuild == null) {
        testGuild = new game.길드("아라드 수호대");
        session.setAttribute("globalGuild", testGuild);
    }

    if (myChar == null) {
%>
        <div class="card" style="text-align: center; padding: 40px 20px;">
            <p style="color:#8b949e; font-size:16px;">활성화된 캐릭터 데이터가 세션에 없습니다.</p>
            <a href="createCharacter.jsp" class="btn-action" style="display:inline-block; text-decoration:none; margin-top:15px; width:auto; background:var(--primary);">로비에서 먼저 생성하기</a>
        </div>
<%
    } else {
%>
        <div class="card">
            <div class="status-title" style="color:var(--primary);">📦 요구사항 추가 기능 1: 실시간 아이템 획득 연산</div>
            <form method="post" action="sysExpansion.jsp">
                <input type="hidden" name="actionType" value="GET_ITEM">
                <div class="sub-grid">
                    <div>
                        <label style="font-size:12px; color:#8b949e; display:block; margin-bottom:4px;">플레이어 ID 검증</label>
                        <input type="text" name="itemPlayerId" value="<%= savedPlayerId %>">
                    </div>
                    <div>
                        <label style="font-size:12px; color:#8b949e; display:block; margin-bottom:4px;">아이템 명칭</label>
                        <input type="text" name="itemName" value="집행자의 대검" required>
                    </div>
                </div>
                <div class="sub-grid">
                    <div>
                        <label style="font-size:12px; color:#8b949e; display:block; margin-bottom:4px;">아이템 타입</label>
                        <select name="itemType">
                            <option value="무기">무기</option>
                            <option value="방어구">방어구</option>
                            <option value="물약">물약</option>
                        </select>
                    </div>
                    <div>
                        <label style="font-size:12px; color:#8b949e; display:block; margin-bottom:4px;">아이템 가치(Gold)</label>
                        <input type="number" name="itemValue" value="1200" min="1">
                    </div>
                </div>
                <button type="submit" class="btn-action btn-item">📥 ITEM ACQUIRE (인벤토리 주입)</button>
            </form>

            <div style="font-size:13px; font-weight:bold; margin-top:15px; color:#fff;">🎒 현재 캐릭터 실시간 가방 모니터링 (<%= myChar.get인벤토리멤버().get아이템리스트().size() %> / 10)</div>
            <div class="inventory-list">
                <%
                    List<아이템> inv = myChar.get인벤토리멤버().get아이템리스트();
                    if(inv.isEmpty()) {
                        out.print("<span style='color:#8b949e;'>인벤토리가 비어 있습니다. 아이템을 주입해 주세요.</span>");
                    } else {
                        for(아이템 i : inv) {
                %>
                            <div style="padding: 4px 0; border-bottom:1px solid #21262d; display:flex; justify-content:space-between;">
                                <span>• <b><%= i.get아이템명() %></b> (<%= i.get타입() %>)</span>
                                <span style="color:#ffa657;"><%= i.get등급() %></span>
                            </div>
                <%
                        }
                    }
                %>
            </div>
        </div>

        <div class="card">
            <div class="status-title" style="color:var(--purple);">🏰 요구사항 추가 기능 2: 길드 가입 신청 연산</div>
            <div style="font-size:13px; margin-bottom:15px;">
                🏰 <b>현재 타겟 길드:</b> <span style="color:var(--purple); font-weight:bold;"><%= testGuild.get길드명() %></span><br>
                👥 <b>길드 인원 현황:</b> <%= testGuild.get캐릭터리스트().size() %>명 / 최대 <%= testGuild.get최대인원() %>명 제한
            </div>
            <form method="post" action="sysExpansion.jsp">
                <input type="hidden" name="actionType" value="JOIN_GUILD">
                <div class="sub-grid">
                    <div>
                        <label style="font-size:12px; color:#8b949e; display:block; margin-bottom:4px;">플레이어 ID 검증</label>
                        <input type="text" name="guildPlayerId" value="<%= savedPlayerId %>">
                    </div>
                    <div>
                        <label style="font-size:12px; color:#8b949e; display:block; margin-bottom:4px;">요청 길드 서버</label>
                        <input type="text" name="guildName" value="<%= testGuild.get길드명() %>" readonly style="background:#21262d; color:#8b949e;">
                    </div>
                </div>
                <button type="submit" class="btn-action btn-guild">🤝 GUILD JOIN (소속 결합 컴포넌트)</button>
            </form>
        </div>

<%
        // 백엔드 비즈니스 로직 분기 처리기
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            request.setCharacterEncoding("UTF-8");
            String actionType = request.getParameter("actionType");
            전투 battleControl = new 전투();

            if ("GET_ITEM".equals(actionType)) {
                String itemPlayerId = request.getParameter("itemPlayerId");
                String itemName = request.getParameter("itemName");
                String itemType = request.getParameter("itemType");
                int itemValue = Integer.parseInt(request.getParameter("itemValue"));

                // 전투.java 백엔드 설계 명세 호출
                String 아이템결과 = battleControl.아이템획득(itemPlayerId, myChar, itemName, itemType, itemValue);

                if(아이템결과.startsWith("성공")) {
                    response.sendRedirect("sysExpansion.jsp"); // 세션 갱신을 위해 리다이렉트
                } else {
%>
                    <div class="error-box">
                        <h4 style="color:#ff7b72; margin:0 0 5px 0;">⚠️ ITEM ACQUIRE DENIED</h4>
                        <p style="margin:0; font-size:14px;"><%= 아이템결과 %></p>
                    </div>
<%
                }
            } 
            else if ("JOIN_GUILD".equals(actionType)) {
                String guildPlayerId = request.getParameter("guildPlayerId");
                String 길드결과 = battleControl.길드가입(guildPlayerId, myChar, testGuild);

                if(길드결과.startsWith("성공")) {
%>
                    <div class="battle-panel panel-guild">
                        <h4 style="color: var(--purple); margin: 0 0 10px 0;">🏰 GUILD MEMBERSHIP VERIFIED</h4>
                        <p style="margin:0; font-size:14px; color:#fff;"><%= 길드결과.substring(3) %></p>
                    </div>
<%
                } else {
%>
                    <div class="error-box">
                        <h4 style="color:#ff7b72; margin:0 0 5px 0;">⚠️ GUILD JOIN DENIED</h4>
                        <p style="margin:0; font-size:14px;"><%= 길드결과 %></p>
                    </div>
<%
                }
            }
        }
%>
        <div class="nav-links">
            <a href="attackMonster.jsp" class="back-link">◀ 몬스터 격전지 사냥터 이동</a>
        </div>
<%
    }
%>
</div>

</body>
</html>