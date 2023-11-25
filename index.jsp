<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>9weekhomework</title>
    <link rel="stylesheet" type="text/css" href="css/index.css">
</head>
<body id="body">
    <div id="title">
        로그인
    </div>
    <form action="action/logInAction.jsp" onsubmit="return exceptionCheckEvent()">
        <input type="text" class="input" name = "id"  placeholder="아이디">
        <input type="text" class="input" name = "pw"  placeholder="비밀번호">
        <input type="submit" id="Button" value="로그인">
    </form>
    <div id="menuBox">
        <span class="menu" onclick="findIdEvent()">아이디 찾기</span>
        |
        <span class="menu" onclick="findPwEvent()">비밀번호 찾기</span>
        |
        <span class="menu" onclick="signUpEvent()">회원가입</span>
    </div>
    <script>
        //예외처리
        function exceptionCheckEvent() {
            var input = document.getElementsByClassName("input")
            for(var i=0; i < input.length; i++) {
                if (input[i].value == "") {
                    alert("모든값을 입력해주세요.")
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