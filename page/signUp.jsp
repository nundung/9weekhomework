<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="../css/signUp.css">
</head>
<body id="body">
    <div id="title">
        회원가입
    </div>
    <form action="../action/signUpAction.jsp" onsubmit=" return exceptionHandlingEvent()">
        <div id="idRow">
            <label for="id" id="idColumn">아이디</label>
            <input type="text" id="idInputBox" name="id" >
            <input type="button" id="duplicateCheckButton" onclick="duplicateCheckEvent()" value="아이디 중복체크">
        </div>
        <div id="rows">
            <label for="pw" class ="column">비밀번호</label>
            <input type="text" class="inputBox" name="pw" id="pw">

            <label for="pwCheck" class ="column">비밀번호 확인</label>
            <input type="text" class="inputBox">

            <label for="name" class ="column">이름</label>
            <input type="text" class="inputBox" name="name">

            <label for="phonenumber" class ="column">전화번호</label>
            <input type="text" class="inputBox" name="phonenumber">

            <label for="department" class ="column">부서</label>
            <div class="radioBox">
                <input type="radio" name="department" value="개발">개발
                <input type="radio" name="department" value="디자인">디자인
            </div>
            <label for="position" class ="column">직급</label>
            <div class="radioBox">
                <input type="radio" name="position" value="팀원">팀원
                <input type="radio" name="position" value="팀장">팀장
            </div>
        </div>
        <input type="submit" id="signUpButton" value="회원가입">
    </form>
        <script>
            
            //예외처리
            function exceptionHandlingEvent() {
                var inputBox = document.getElementsByClassName("inputBox")
                for(var i=0; i < inputBox.length; i++) {
                    if (inputBox[i].value == "") {
                        alert("모든값을 입력해주세요.")
                        return false;
                    }
                }
                var pwValue = document.getElementById("pw").value;
                if(pwValue.length < 8 || pwValue.length > 20) {
                    alert("비밀번호는 8자 이상 20자 이하로 입력해주세요.")
                    return false;
                }
            }

            //아이디 중복체크
            function duplicateCheckEvent() {
                var id = document.getElementById("idInputBox").value;

                //아이디 유효성 검사
                
                if(id.trim() == "") {
                    alert("아이디값을 입력해주세요.");
                    return false;
                }

                var idReg = /^[A-Za-z0-9]{6,18}$/;
                if(!idReg.test(id)) {
                    alert("아이디는 6자 이상 18자 이하의 영문과 숫자의 조합으로 입력해주세요.");
                    return false;
                }

                let options = "toolbar=no, scrollbars=no, resizable=yes, status=no, menubar=no, width=600, height=400";
                var ret = window.open("../action/checkIdAction.jsp?id="+ id, "아이디중복체크", options)

            }
        </script>
</body>