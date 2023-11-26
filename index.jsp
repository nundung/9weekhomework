<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>9weekhomework</title>
    <link rel="stylesheet" type="text/css" href="css/index.css">
    <link rel="stylesheet" type="text/css" href="css/common.css">
</head>
<body>
    <header>
        로그인
    </header>
    <main>
        <form action="action/logInAction.jsp" onsubmit="return exceptionCheckEvent()">
            <input type="text" class="input" name = "id" id="id" placeholder="아이디">
            <input type="text" class="input" name = "pw" id="pw" placeholder="비밀번호">
            <input type="submit" id="button" value="로그인">
        </form>
        <div id="menuBox">
            <span class="menu" onclick="findIdEvent()">아이디 찾기</span>
            |
            <span class="menu" onclick="findPwEvent()">비밀번호 찾기</span>
            |
            <span class="menu" onclick="signUpEvent()">회원가입</span>
        </div>
    </main>
    <script>
        //예외처리
        function exceptionCheckEvent() {
            var input = document.getElementsByClassName("input")
            for(var i=0; i < input.length; i++) {
                if (input[i].value == "") {
                    alert("모든값을 입력해주세요.")
                    return false;
                }

                //아이디 정규식
                var id = document.getElementById("id").value;
                var idReg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,18}$/;
                //id 문자열이 idReg로 정의된 정규 표현식과 일치하는지 체크
                if(!idReg.test(id)) {
                    alert("아이디는 영문, 숫자의 조합으로 6~18자로 입력해주세요.");
                    return false;
                }

                //비밀번호 정규식
                var pw = document.getElementById("pw").value;
                var pwReg = /^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,20}$/;
                if(!pwReg.test(pw)) {
                    alert("비밀번호는 영문, 숫자, 특수문자의 조합으로 8~20자로 입력해주세요.");
                    return false;
                }
            }
        }

        function findIdEvent() {
            location.href = "page/findId.jsp";
        }
        function findPwEvent() {
            location.href = "page/findPw.jsp";
        }
        function signUpEvent() {
            location.href = "page/signUp.jsp";
        }
    </script>
</body>