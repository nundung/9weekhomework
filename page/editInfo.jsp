<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

<!-- 예외처리 -->
<%@ page import="java.sql.SQLException" %>


<%
    //전페이지에서 온 데이터에 대해서 인코딩 설정
    request.setCharacterEncoding("UTF-8");

    String id = null;
    String pw = null;
    String name = null;
    String phonenumber = null;
    Integer team = null;
    Integer position = null;
    
        //세션값 받아줌
        Integer idx = (Integer)session.getAttribute("idx");

        Object idSession = session.getAttribute("id");
        id = (String)idSession;

        Object pwSession = session.getAttribute("pw");
        pw = (String)pwSession;

        Object nameSession = session.getAttribute("name");
        name = (String)nameSession;

        Object phonenumberSession = session.getAttribute("phonenumber");
        phonenumber = (String)phonenumberSession;

        team = (Integer)session.getAttribute("team");

        position = (Integer)session.getAttribute("position");

        if (idx == null || id == null || name == null || phonenumber == null || team == null || position == null) {
            out.println("<div>올바르지 않은 접근입니다.</div>");
            return;
        }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>정보수정</title>
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
        <form action="../action/editInfoAction.jsp" onsubmit="return exceptionCheckEvent()">
            <section class="rows">
                <label for="id" class ="label">아이디</label>
                <p id="id"></p>
            </section>
            <section class="rows">
                <label for="pw" class ="label">비밀번호</label>
                <input type="password" class="input" name="pw" id="pw">
            </section>
            <section class="rows">
                <label for="pwCheck" class ="label">비밀번호 확인</label>
                <input type="password" class="input" id="pwCheck">
            </section>
            <section class="rows">
                <label for="name" class ="label">이름</label>
                <input type="text" class="input" id="nameId" name="name">
            </section>
            <section class="rows">
                <label for="phoneNumber" class ="label">전화번호</label>
                <input type="text" class="input" id="phonenumber" name="phonenumber" oninput="phonenumberAutoHyphenEvent()">
            </section>
            <section class="rows">
                <label for="team" class ="label">부서</label>
                <div class="radioInput">
                    <input type="radio" name="team" value="1" id="teamDev">개발
                    <input type="radio" name="team" value="2" id="teamDesign">디자인
                </div>
            </section>
            <section class="rows">
                <label for="position" class ="label">직급</label>
                <div class="radioInput">
                    <input type="radio" name="position" value="1" id="positionMember">팀원
                    <input type="radio" name="position" value="2" id="positionLeader">팀장
                </div>
            </section>
            <input type="submit" id="editButton" value="수정완료">
        </form>
    </main>
    
    <script>
        var idx = "<%=idx%>";
        var idValue = "<%=id%>";
        var pwValue = "<%=pw%>";
        var nameValue = "<%=name%>";
        var phonenumberValue = "<%=phonenumber%>";
        var teamValue = "<%=team%>";
        var positionValue = "<%=position%>";

        var date = new Date();
        var year = date.getFullYear();
        var month = date.getMonth()+1;
        var day = date.getDate();

        var idId = document.getElementById("id");
        var pwId = document.getElementById("pw");
        var pwCheckId = document.getElementById("pwCheck");
        var nameId = document.getElementById("nameId");
        var phonenumberId = document.getElementById("phonenumber");
        var teamDevId = document.getElementById("teamDev");
        var teamDesignId = document.getElementById("teamDesign");
        var positionMemberId = document.getElementById("positionMember");
        var positionLeaderId = document.getElementById("positionLeader");
        
        idId.innerHTML = idValue;
        pwId.value = pwValue;
        nameId.value = nameValue;
        phonenumberId.value = phonenumberValue;
        

        if (teamValue === "1") {
            teamDevId.checked = true;
        } else if (teamValue === "2") {
            teamDesignId.checked = true;
        }

        if (positionValue === "1") {
            positionMemberId.checked = true;
        } else if (positionValue === "2") {
            positionLeaderId.checked = true;
        }
        function schedulePageEvent() {
            location.href = "schedule.jsp?idx=" + idx + "&year=" + year + "&month=" + month + "&day=" + day;
        }

        
        //자동 하이픈 추가 이벤트
        var phonenumberAutoHyphenEvent =() => {
            var target = event.target || window.event.srcElement;
            target.value = target.value
            .replace(/[^0-9]/g, '')
            .replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3").replace(/(\-{1,2})$/g, "");
        }
        
        //예외 체크 이벤트
        function exceptionCheckEvent() {
            var input = document.getElementsByClassName("input")
            for(var i=0; i < input.length; i++) {
                if (input[i].value === "") {
                    alert("모든값을 입력해주세요.");
                    return false;
                }
            }
            //비밀번호 정규식
            var pwReg = /^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,20}$/;
            var pw = document.getElementById("pw").value;
            if(!pwReg.test(pw)) {
                alert("비밀번호는 영문, 숫자, 특수문자의 조합으로 8~20자로 입력해주세요.");
                return false;
            }
            //비밀번호 확인값 검사
            var pwCheck = document.getElementById("pwCheck").value;
            if(pw !== pwCheck) {
                alert("비밀번호 확인값이 일치하지 않습니다.");
                return false;
            }
            //이름 정규식
            var nameReg = /^[가-힣]{2,4}$/;
            var name = document.getElementById("name").value;
            if(!nameReg.test(name)) {
                alert("이름은 한글 2~4자로 입력해주세요.")
                return false;
            }
            //전화번호 정규식
            var phonenumberReg = /^01([0|1|6|7|8|9])-?([0-9]{4})-?([0-9]{4})$/;
            var phonenumber = document.getElementById("phonenumber").value;
            if(!phonenumberReg.test(phonenumber)) {
                alert("유효한 전화번호 값을 입력해주세요.")
                return false;
            }
            //라디오 버튼 선택값 체크
            var teamRadio = document.getElementsByName("team");
            var positionRadio = document.getElementsByName("position");
            var radioList = [teamRadio, positionRadio];
            
            for (var j = 0; j < radioList.length; j++) {
                var isChecked = false;
                for(var k = 0; k < radioList[j].length; k++)
                if (radioList[j][k].checked) {
                    isChecked = true;
                    break;
                }
            }
            if (!isChecked) {
                alert("부서와 직급을 선택해주세요.");
                return false;
            }
        }
    </script>
</body>
