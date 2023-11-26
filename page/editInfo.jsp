<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>


<%
    Object idSession = session.getAttribute("id");
    String idValue = (String)idSession;

    Object pwSession = session.getAttribute("pw");
    String pwValue = (String)pwSession;

    Object nameSession = session.getAttribute("name");
    String nameValue = (String)nameSession;

    Object phonenumberSession = session.getAttribute("phonenumber");
    String phonenumberValue = (String)phonenumberSession;
    
    Object teamSession = session.getAttribute("team");
    String teamValue = (String)teamSession;
    
    Object positionSession = session.getAttribute("position");
    String positionValue = (String)positionSession;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/editInfo.css">
    <link rel="stylesheet" type="text/css" href="../css/common.css">
</head>
<body>
    <header>
        <img src="../image/home.svg" class="headerIcon" onclick="schedulePageEvent()">
        <p id="title">정보수정</p>
        <div id="empty"></div>
    </header>
    <main>
        <form action="../action/editInfoAction.jsp">
            <section class="rows">
                <label for="id" class ="label">아이디</label>
                <p id="id"></p>
            </section>
            <section class="rows">
                <label for="pw" class ="label">비밀번호</label>
                <input type="text" class="input" name="pw" id="pw">
            </section>
            <section class="rows">
                <label for="pwCheck" class ="label">비밀번호 확인</label>
                <input type="text" class="input">
            </section>
            <section class="rows">
                <label for="name" class ="label">이름</label>
                <input type="text" class="input" id="nameId">
            </section>
            <section class="rows">
                <label for="phoneNumber" class ="label">전화번호</label>
                <input type="text" class="input" id="phonenumber">
            </section>
            <section class="rows">
                <label for="team" class ="label">부서</label>
                <div class="radioInput">
                    <input type="radio" name="team" value="개발" id="teamDev">개발
                    <input type="radio" name="team" value="디자인" id="teamDesign">디자인
                </div>
            </section>
            <section class="rows">
                <label for="position" class ="label">직급</label>
                <div class="radioInput">
                    <input type="radio" name="position" value="팀원" id="positionMember">팀원
                    <input type="radio" name="position" value="팀장" id="positionLeader">팀장
                </div>
            </section>
            <input type="submit" id="editButton" value="수정완료">
        </form>
    </main>
    
    <script>
        var idValue = "<%=idValue%>";
        var pwValue = "<%=pwValue%>";
        var nameValue = "<%=nameValue%>";
        var phonenumberValue = "<%=phonenumberValue%>";
        var teamValue = "<%=teamValue%>";
        var positionValue = "<%=positionValue%>";

        var id = document.getElementById("id");
        var pw = document.getElementById("pw");
        var pwCheck = document.getElementById("pwCheck");
        var nameId = document.getElementById("nameId");
        var phonenumber = document.getElementById("phonenumber");
        var teamDev = document.getElementById("teamDev");
        var teamDesign = document.getElementById("teamDesign");
        var positionMember = document.getElementById("positionMember");
        var positionLeader = document.getElementById("positionLeader");
        
        id.innerHTML = idValue;
        pw.value = pwValue;
        nameId.value = nameValue;
        phonenumber.value = phonenumberValue;
        
        
        function maskPw() {
            // 비밀번호 입력 필드에 값이 있다면 마스킹
            if (pw.value.length > 0) {
                var maskedPw = "*".repeat(pw.value.length);
                pw.value = maskedPw;
            }

            // 비밀번호 확인 필드도 마찬가지로 마스킹
            if (pwCheck.value.length > 0) {
                var maskedPwCheck = "*".repeat(pwCheck.value.length);
                pwCheck.value = maskedPwCheck;
            }
        }

        window.onload = maskPw;

        if (teamValue === "개발") {
            teamDev.checked = true;
        } else if (teamValue === "디자인") {
            teamDesign.checked = true;
        }

        if (positionValue === "팀원") {
            positionMember.checked = true;
        } else if (positionValue === "팀장") {
            positionLeader.checked = true;
        }
        function schedulePageEvent() {
            location.href = "schedule.jsp";
        }
    </script>
</body>
