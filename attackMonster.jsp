<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="game.전투, game.캐릭터, game.아이템, game.길드, java.util.List" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>RPG 대시보드 - 실시간 연산 및 검증 스테이지</title>
<style>
    :root {
        --bg-color: #0d1117;
        --card-bg: #161b22;
        --text-color: #c9d1d9;
        --primary: #58a6ff;
        --action: #f25944;
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
        background: var(--card-bg);
        border: 1px solid var(--border-color); 
        padding: 25px; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.5);
        margin-bottom: 25px;
    }
    .status-title { font-size: 18px; font-weight: bold; margin-bottom: 15px; color: #fff; display: flex; justify-content: space-between; }
    .badge { background: #21262d; padding: 4px 10px; border-radius: 20px; font-size: 12px; color: #8b949e; border: 1px solid var(--border-color); }
    
    .gauge-container { background: #21262d; border-radius: 6px; height: 12px; width: 100%; margin: 8px 0 18px 0; overflow: hidden; border: 1px solid #30363d; }
    .gauge-fill { height: 100%; border-radius: 6px; background: linear-gradient(90deg, #ff7b72, #f25944); width: 100%; }
    
    .btn-action { 
        width: 100%; padding: 12px; color: #fff; border: none; border-radius: 6px; font-size: 15px; font-weight: bold; cursor: pointer; transition: all 0.2s;
    }
    .btn-attack { background: linear-gradient(135deg, #f25944, #be2612); }
    .btn-item { background: linear-gradient(135deg, #58a6ff, #0969da); }
    .btn-guild { background: linear-gradient(135deg, #ab7df6, #6f34e3); }
    .btn-action:hover { transform: translateY(-1px); filter: brightness(1.1); }
    
    .battle-panel { 
        margin-top: 15px; background: #040609; border: 1px dashed #ffc107; padding: 15px; border-radius: 12px; 
    }
    .panel-item { border-color: var(--primary); }
    .panel-guild { border-color: var(--purple); }

    .rank-text { font-size: 18px; font-weight: 900; }
    .s-rank { color: #ff5e7e; }
    .a-rank { color: #ffbc42; }
    .b-rank { color: #38ef7d; }
    
    .error-box { margin-top:15px; background: rgba(218,54,51,0.1); border: 1px solid #da3633; padding: 15px; border-radius: 12px; }
    .back-link { display:inline-block; margin-top: 15px; color: #8b949e; text-decoration: none; font-size: 14px; }
    .back-link:hover { color: #fff; }
    
    .sub-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 10px; }
    .inventory-list { background: #0d1117; padding: 10px; border-radius: 6px; font-size: 13px; max-height: 150px; overflow-y: auto; margin-top: 10px; border: 1px solid #30363d;}
</style>
</head>
<body>

<div class="wrapper">
    <h2 style="text-align:center; color: #fff; margin-bottom: 20px;">⚔️ REAL-TIME BATTLE & SYSTEM DASHBOARD ⚔️</h2>

<%
    캐릭터 myChar = (캐릭터) session.getAttribute("myCharacter");
    String savedPlayerId = (String) session.getAttribute("playerId");
    String jobName = (String) session.getAttribute("jobName");

    // 글로벌 혹은 세션 범위의 가상 길드 매니저 구성 (테스트용 고정 객체화)
    길드 testGuild = (길드) session.getAttribute("globalGuild");
    if (testGuild == null) {
        testGuild = new game.길드("아라드 수호대");
        session.setAttribute("globalGuild", testGuild);
    }

    if (myChar == null) {
%>
        <div class="card" style="text-align: center; padding: 40px 20px;">
            <p style="color:#8b949e; font-size:16px;">현재 전장에 진입한 캐릭터가 존재하지 않습니다.</p>
            <a href="createCharacter.jsp" class="btn-action btn-item" style="display:inline-block; text-decoration:none; margin-top:15px; width:auto;">로비로 돌아가 생성하기</a>
        </div>
<%
    } else {
%>
        <div class="card">
            <div class="status-title">
                <span><%= myChar.get캐릭터명() %> <span style="color:var(--primary); font-size:14px;">Lv.<%= myChar.get레벨() %></span></span>
                <span class="badge"><%= jobName %></span>
            </div>
            <div style="font-size:13px; color:#8b949e; margin-bottom: 5px;">체력 (HP) 상태 및 가입 정보</div>
            <div class="gauge-container">
                <div class="gauge-fill"></div>
            </div>
            <div style="font-size: 13px; color: #c9d1d9; margin-bottom: 10px;">
                🏰 <b>소속 길드:</b> 
                <%
                    boolean 가입여부 = false;
                    for(캐릭터 c : testGuild.get캐릭터리스트()){
                        if(c.get캐릭터명().equals(myChar.get캐릭터명())) 가입여부 = true;
                    }
                    out.print(가입여부 ? "<span style='color:var(--purple); font-weight:bold;'>" + testGuild.get길드명() + "</span>" : "<span style='color:#8b949e;'>무소속</span>");
                %> 
                (길드 동접자수: <%= testGuild.get캐릭터리스트().size() %> / <%= testGuild.get최대인원() %>명)
            </div>

            <form method="post" action="attackMonster.jsp">
                <input type="hidden" name="actionType" value="ATTACK">
                <div style="margin-bottom: 10px;">
                    <label style="display:block; font-size:12px; color:#8b949e; margin-bottom:3px;">보안 인증 ID 디버깅</label>
                    <input type="text" name="attackPlayerId" value="<%= savedPlayerId %>" style="background:#0d1117; border:1px solid #30363d; color:#fff; padding:6px; width:100%; box-sizing:border-box; border-radius:4px;">
                </div>
                <button type="submit" class="btn-action btn-attack">💥 SKILL CAST (몬스터 저격)</button>
            </form>
        </div>

        <div class="card">
            <div class="status-title" style="font-size:16px; color:var(--primary);">📦 신규 기능 1: 실시간 아이템 획득 연산</div>
            <form method="post" action="attackMonster.jsp">
                <input type="hidden" name="actionType" value="GET_ITEM">
                <div class="sub-grid">
                    <div>
                        <label style="font-size:12px; color:#8b949e;">플레이어 ID</label>
                        <input type="text" name="itemPlayerId" value="<%= savedPlayerId %>" style="padding:6px; font-size:13px;">
                    </div>
                    <div>
                        <label style="font-size:12px; color:#8b949e;">아이템 명칭</label>
                        <input type="text" name="itemName" value="집행자의 대검" required style="padding:6px; font-size:13px;">
                    </div>
                </div>
                <div class="sub-grid">
                    <div>
                        <label style="font-size:12px; color:#8b949e;">아이템 타입</label>
                        <select name="itemType" style="padding:6px; font-size:13px;">
                            <option value="무기">무기</option>
                            <option value="방어구">방어구</option>
                            <option value="물약">물약</option>
                        </select>
                    </div>
                    <div>
                        <label style="font-size:12px; color:#8b949e;">아이템 가치(Gold)</label>
                        <input type="number" name="itemValue" value="1200" min="1" style="padding:6px; font-size:13px;">
                    </div>
                </div>
                <button type="submit" class="btn-action btn-item">📥 ITEM ACQUIRE (인벤토리 삽입)</button>
            </form>

            <div style="font-size:13px; font-weight:bold; margin-top:15px; color:#fff;">🎒 현재 캐릭터 인벤토리 실시간 모니터 (<%= myChar.get인벤토리멤버().get아이템리스트().size() %> / 10)</div>
            <div class="inventory-list">
                <%
                    List<아이템> inv = myChar.get인벤토리멤버().get아이템리스트();
                    if(inv.isEmpty()) {
                        out.print("<span style='color:#8b949e;'>인벤토리가 텅 비어있습니다.</span>");
                    } else {
                        for(아이템 i : inv) {
                %>
                            <div style="padding: 3px 0; border-bottom:1px solid #21262d; display:flex; justify-content:space-between;">
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
            <div class="status-title" style="font-size:16px; color:var(--purple);">🏰 신규 기능 2: 길드 가입 신청 연산 (Aggregation)</div>
            <form method="post" action="attackMonster.jsp">
                <input type="hidden" name="actionType" value="JOIN_GUILD">
                <div class="sub-grid">
                    <div>
                        <label style="font-size:12px; color:#8b949e;">플레이어 ID</label>
                        <input type="text" name="guildPlayerId" value="<%= savedPlayerId %>" style="padding:6px; font-size:13px;">
                    </div>
                    <div>
                        <label style="font-size:12px; color:#8b949e;">요청 길드명</label>
                        <input type="text" name="guildName" value="<%= testGuild.get길드명() %>" readonly style="padding:6px; font-size:13px; background:#21262d; color:#8b949e;">
                    </div>
                </div>
                <button type="submit" class="btn-action btn-guild">🤝 GUILD JOIN (정원 체크 연산)</button>
            </form>
        </div>

        <div style="text-align: center;"><a href="createCharacter.jsp" class="back-link">◀ 처음 화면(로비)으로 퇴각</a></div>
<%
    }

    // --- 비즈니스 및 파싱 연산 분기 핸들러 ---
    if ("POST".equalsIgnoreCase(request.getMethod()) && myChar != null) {
        request.setCharacterEncoding("UTF-8");
        String actionType = request.getParameter("actionType");
        전투 battleControl = new 전투();

        if ("ATTACK".equals(actionType)) {
            String attackPlayerId = request.getParameter("attackPlayerId");
            String 공격결과 = battleControl.몬스터공격(attackPlayerId, myChar);

            if (공격결과.contains("권한이") || 공격결과.contains("존재하지")) {
%>
                <div class="error-box">
                    <h4 style="color:#ff7b72; margin:0 0 5px 0;">⚠️ ACTION DENIED</h4>
                    <p style="margin:0; font-size:14px;"><%= 공격결과 %></p>
                </div>
<%
            } else {
                String rankClass = "b-rank";
                if (공격결과.contains("S급")) rankClass = "s-rank";
                else if (공격결과.contains("A급")) rankClass = "a-rank";
%>
                <div class="battle-panel">
                    <h4 style="color: #ffbc42; margin: 0 0 10px 0;">⚡ COMBAT SYSTEM TRANSMISSION</h4>
                    <div style="font-size: 14px; line-height: 1.5;">
                        <p style="margin: 3px 0;">● <b>데이터 연산 결과:</b> <span style="color:#fff;"><%= 공격결과.split("\\|")[0] %> | <%= 공격결과.split("\\|")[1] %></span></p>
                        <p style="margin: 8px 0 0 0; border-top: 1px dashed #30363d; padding-top:5px;">
                            ● <b>최종 타격 등급 판정:</b> <span class="rank-text <%= rankClass %>"><%= 공격결과.split("판정: ")[1] %></span>
                        </p>
                    </div>
                </div>
<%
            }
        } 
        else if ("GET_ITEM".equals(actionType)) {
            String itemPlayerId = request.getParameter("itemPlayerId");
            String itemName = request.getParameter("itemName");
            String itemType = request.getParameter("itemType");
            int itemValue = Integer.parseInt(request.getParameter("itemValue"));

            String 아이템결과 = battleControl.아이템획득(itemPlayerId, myChar, itemName, itemType, itemValue);

            if(아이템결과.startsWith("성공")) {
                String[] 데이터 = 아이템결과.split("\\|");
%>
                <div class="battle-panel panel-item">
                    <h4 style="color: var(--primary); margin: 0 0 10px 0;">📦 ITEM ACQUISITION SUCCESS</h4>
                    <div style="font-size: 14px; line-height: 1.5;">
                        <p style="margin: 3px 0;">● <b>획득 아이템:</b> <span style="color:#fff;"><%= 데이터[1] %></span> (<%= 데이터[2] %>)</p>
                        <p style="margin: 3px 0;">● <b>최종 판정 등급:</b> <span style="color:#ffa657; font-weight:bold;"><%= 데이터[3] %></span></p>
                    </div>
                </div>
<%
                // 리프레시를 통해 실시간 인벤토리 로그 리스트에 동적 바인딩 처리
                response.sendRedirect("attackMonster.jsp");
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
</div>

</body>
</html>