<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="game.전투, game.캐릭터" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>RPG 대시보드 - 실시간 전투 스테이지</title>
<style>
    :root {
        --bg-color: #0d1117;
        --card-bg: #161b22;
        --text-color: #c9d1d9;
        --primary: #58a6ff;
        --action: #f25944;
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
    .status-title { font-size: 18px; font-weight: bold; margin-bottom: 15px; color: #fff; display: flex; justify-content: space-between; }
    .badge { background: #21262d; padding: 4px 10px; border-radius: 20px; font-size: 12px; color: #8b949e; border: 1px solid var(--border-color); }
    .gauge-container { background: #21262d; border-radius: 6px; height: 12px; width: 100%; margin: 8px 0 18px 0; overflow: hidden; border: 1px solid #30363d; }
    .gauge-fill { height: 100%; border-radius: 6px; background: linear-gradient(90deg, #ff7b72, #f25944); width: 100%; }
    .btn-action { width: 100%; padding: 12px; color: #fff; border: none; border-radius: 6px; font-size: 15px; font-weight: bold; cursor: pointer; transition: all 0.2s; }
    .btn-attack { background: linear-gradient(135deg, #f25944, #be2612); }
    .btn-action:hover { transform: translateY(-1px); filter: brightness(1.1); }
    .battle-panel { margin-top: 15px; background: #040609; border: 1px dashed #ffc107; padding: 15px; border-radius: 12px; }
    .rank-text { font-size: 18px; font-weight: 900; }
    .s-rank { color: #ff5e7e; }
    .a-rank { color: #ffbc42; }
    .b-rank { color: #38ef7d; }
    .error-box { margin-top:15px; background: rgba(218,54,51,0.1); border: 1px solid #da3633; padding: 15px; border-radius: 12px; }
    .nav-links { display: flex; justify-content: space-between; margin-top: 20px; }
    .back-link { color: #8b949e; text-decoration: none; font-size: 14px; }
    .back-link:hover { color: #fff; }
    .next-link { color: var(--primary); text-decoration: none; font-size: 14px; font-weight: bold; }
    .next-link:hover { text-decoration: underline; }
</style>
</head>
<body>

<div class="wrapper">
    <h2 style="text-align:center; color: #fff; margin-bottom: 20px;">⚔️ REAL-TIME BATTLE STAGE ⚔️</h2>

<%
    캐릭터 myChar = (캐릭터) session.getAttribute("myCharacter");
    String savedPlayerId = (String) session.getAttribute("playerId");
    String jobName = (String) session.getAttribute("jobName");

    if (myChar == null) {
%>
        <div class="card" style="text-align: center; padding: 40px 20px;">
            <p style="color:#8b949e; font-size:16px;">현재 전장에 진입한 캐릭터가 존재하지 않습니다.</p>
            <a href="createCharacter.jsp" class="btn-action" style="display:inline-block; text-decoration:none; margin-top:15px; width:auto; background: var(--primary);">로비로 돌아가 생성하기</a>
        </div>
<%
    } else {
%>
        <div class="card">
            <div class="status-title">
                <span><%= myChar.get캐릭터명() %> <span style="color:var(--primary); font-size:14px;">Lv.<%= myChar.get레벨() %></span></span>
                <span class="badge"><%= jobName %></span>
            </div>
            <div style="font-size:13px; color:#8b949e; margin-bottom: 5px;">전투 체력 (HP) 상태</div>
            <div class="gauge-container">
                <div class="gauge-fill"></div>
            </div>

            <form method="post" action="attackMonster.jsp">
                <input type="hidden" name="actionType" value="ATTACK">
                <div style="margin-bottom: 15px;">
                    <label style="display:block; font-size:12px; color:#8b949e; margin-bottom:3px;">보안 인증 플레이어 ID 디버깅</label>
                    <input type="text" name="attackPlayerId" value="<%= savedPlayerId %>" style="background:#0d1117; border:1px solid #30363d; color:#fff; padding:8px; width:100%; box-sizing:border-box; border-radius:4px;">
                </div>
                <button type="submit" class="btn-action btn-attack">💥 SKILL CAST (몬스터 공격)</button>
            </form>
        </div>

<%
        // 전투 비즈니스 연산 분기 핸들러
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            request.setCharacterEncoding("UTF-8");
            String attackPlayerId = request.getParameter("attackPlayerId");
            전투 battleControl = new 전투();
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
%>
        <div class="nav-links">
            <a href="createCharacter.jsp" class="back-link">◀ 처음 화면(로비)으로 퇴각</a>
            <a href="sysExpansion.jsp" class="next-link">📦 신규 연산 전용 화면(아이템/길드) 이동 ▶</a>
        </div>
<%
    }
%>
</div>

</body>
</html>