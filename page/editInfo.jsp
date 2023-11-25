<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/editInfo.css">
</head>
<body id="body">
    <div id="header">
        <img src="../image/home.svg" class="headerIcon" onclick="schedulePageEvent()">
        <p id="title">정보수정</p>
        <div id="empty"></div>
    </div>
    <form action="../action/editInfoAction.jsp">
        <div id="rows">
            <label for="id" class ="column">아이디</label>
            <div id="id">
                아이디값
            </div>
            <label for="pw" class ="column">비밀번호</label>
            <input type="text" class="inputBox" name="pw">

            <label for="pwCheck" class ="column">비밀번호 확인</label>
            <input type="text" class="inputBox">

            <label for="name" class ="column">이름</label>
            <input type="text" class="inputBox" placeholder="이름">

            <label for="phoneNumber" class ="column">전화번호</label>
            <input type="text" class="inputBox" placeholder="전화번호">

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
        <input type="submit" id="editButton" value="수정완료">
    </form>
    <script>
        function schedulePageEvent() {
            location.href = "schedule.jsp";
        }
    </script>
</body>
