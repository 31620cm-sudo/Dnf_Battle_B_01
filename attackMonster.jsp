<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="game.전투, game.캐릭터" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>RPG 대시보드 - 전투 공간</title>
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
        font-family: 'Segoe UI', sans-serif; margin: 0; padding: 40px;
        display: flex; flex-direction: column; align-items: center;
    }
    .wrapper { width: 500px; }
    .card { 
        background: var(--card-bg); border: 1px solid var(--border-color); 
        padding: 25px; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.5);
    }
    .status-title { font-size: 18px; font-weight: bold; margin-bottom: 15px; color: #fff; display: flex; justify-content: space-between; }
    .badge { background: #21262d; padding: 4px 10px; border-radius: 20px; font-size: 12px; color: #8b949e; border: 1px solid var(--border-color); }
    
    /* 게이지바 스타일에 그래픽 부여 */
    .gauge-container { background: #21262d; border-radius: 6px; height: 12px; width: 100%; margin: 8px 0 18px 0; overflow: hidden; border: 1px solid #30363d; }
    .gauge-fill { height: 100%; border-radius: 6px; background: linear-gradient(90deg, #ff7b72, #f25944); width: 100%; }
    
    .btn-attack { 
        width: 100%; padding: 15px; background: linear-gradient(135deg, #f25944, #be2612); color: #fff; 
        border: none; border-radius: 6px; font-size: 18px; font-weight: bold; cursor: pointer;
        box-shadow: 0 4px 12px rgba(242,89,68,0.3); transition: all 0.2s;
    }
    .btn-attack:hover { transform: translateY(-2px); box-shadow: 0 6px 18px rgba(242,89,68,0.5); }
    .btn-attack:active { transform: translateY(0); }
    
    /* 전투 로그 테마 */
    .battle-panel { 
        margin-top: 25px; background: #040609; border: 1px dashed #ffc107; padding: 20px; 
        border-radius: 12px; animation: hitShake 0.15s ease-in-out infinite alternate;
        animation-iteration-count: 1;
    }
    .rank-text { font-size: 24px; font-weight: 900; text-shadow: 0 0 10px currentColor; }
    .s-rank { color: #ff5e7e; }
    .a-rank { color: #ffbc42; }
    .b-rank { color: #38ef7d; }
    
    .error-box { margin-top:25px; background: rgba(218,54,51,0.1); border: 1px solid #da3633; padding: 20px; border-radius: 12px; }
    .back-link { display:inline-block; margin-top: 15px; color: #8b949e; text-decoration: none; font-size: 14px; }
    .back-link:hover { color: #fff; }

    @keyframes hitShake {
        0% { transform: translateX(-3px); }
        100% { transform: translateX(3px); }
    }
</style>
</head>
<body>

<div class="wrapper">
    <h2 style="text-align:center; color: #fff; margin-bottom: 30px;">⚔️ REAL-TIME BATTLE STAGE ⚔️</h2>

<%
    캐릭터 myChar = (캐릭터) session.getAttribute("myCharacter");
    String savedPlayerId = (String) session.getAttribute("playerId");
    String jobName = (String) session.getAttribute("jobName");

    if (myChar == null) {
%>
        <div class="card" style="text-align: center; padding: 40px 20px;">
            <p style="color:#8b949e; font-size:16px;">현재 전장에 진입한 스쿼드(캐릭터)가 존재하지 않습니다.</p>
            <a href="createCharacter.jsp" class="btn-attack" style="display:inline-block; text-decoration:none; margin-top:15px; font-size:15px; width:auto; padding:10px 20px;">로비로 돌아가 생성하기</a>
        </div>
<%
    } else {
%>
        <div class="card">
            <div class="status-title">
                <span><%= myChar.get캐릭터명() %> <span style="color:var(--primary); font-size:14px;">Lv.<%= myChar.get레벨() %></span></span>
                <span class="badge"><%= jobName %></span>
            </div>
            
            <div style="font-size:13px; color:#8b949e;">체력 (HP) 상태</div>
            <div class="gauge-container">
                <div class="gauge-fill"></div>
            </div>
            
            <form method="post" action="attackMonster.jsp">
                <div style="margin-bottom: 15px;">
                    <label style="display:block; font-size:12px; color:#8b949e; margin-bottom:5px;">보안 인증 ID 디버깅</label>
                    <input type="text" name="attackPlayerId" value="<%= savedPlayerId %>" style="background:#0d1117; border:1px solid #30363d; color:#fff; padding:8px; width:100%; box-sizing:border-box; border-radius:4px;">
                </div>
                <button type="submit" class="btn-attack">💥 SKILL CAST (몬스터 저격)</button>
            </form>
            <div style="text-align: center;"><a href="createCharacter.jsp" class="back-link">◀ 처음 화면(로비)으로 퇴각</a></div>
        </div>
<%
    }

    // 전투 액션 결과 연산
    if ("POST".equalsIgnoreCase(request.getMethod()) && myChar != null) {
        String attackPlayerId = request.getParameter("attackPlayerId");
        
        전투 battleControl = new 전투();
        String 공격결과 = battleControl.몬스터공격(attackPlayerId, myChar);

        if (공격결과.contains("없습니다") || 공격결과.contains("존재하지")) {
%>
            <div class="error-box">
                <h4 style="color:#ff7b72; margin:0 0 10px 0;">⚠️ ACTION DENIED</h4>
                <p style="margin:0; font-size:14px; color:#c9d1d9;"><%= 공격결과 %></p>
            </div>
<%
        } else {
            // 등급 텍스트에 색상 클래스를 입히기 위한 분기 추출
            String rankClass = "b-rank";
            if (공격결과.contains("S급")) rankClass = "s-rank";
            else if (공격결과.contains("A급")) rankClass = "a-rank";
%>
            <div class="battle-panel">
                <h4 style="color: #ffbc42; margin: 0 0 15px 0; letter-spacing: 1px;">⚡ COMBAT SYSTEM TRANSMISSION</h4>
                <div style="font-size: 15px; line-height: 1.6;">
                    <p style="margin: 5px 0;">● <b>공격 주체:</b> <span style="color:#fff;"><%= myChar.get캐릭터명() %></span></p>
                    <p style="margin: 5px 0;">● <b>데이터 연산:</b> <span style="color:#6e7681;"><%= 공격결과.split("\\|")[0] %> | <%= 공격결과.split("\\|")[1] %></span></p>
                    <p style="margin: 15px 0 5px 0; border-top: 1px dashed #30363d; padding-top:10px;">
                        ● <b>최종 타격 등급:</b> 
                        <span class="rank-text <%= rankClass %>"><%= 공격결과.split("판정: ")[1] %></span>
                    </p>
                </div>
            </div>
<%
        }
    }
%>
</div>

</body>
</html>