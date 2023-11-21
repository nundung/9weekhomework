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
    <form action="action/logInAction.jsp">
        <input type="text" class="inputBox" placeholder="아이디">
        <input type="text" class="inputBox" placeholder="비밀번호">
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