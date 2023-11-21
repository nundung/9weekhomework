<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="../css/schedule.css">
</head>
<body>
    <div id="header">
        <img src="../image/home.svg" class="headerIcon">
        <p id="todayValue"></p>
        <img src="../image/menu.svg" class="headerIcon" onclick="toggleMenuEvent()">
    </div>

    <div id= "menuBar">
        <div id="menuBarHeader">
            <input type="button" value="로그아웃" id="logOutButton" onclick="logOutEvent()">
            <img src="../image/menu.svg" class="headerIcon" onclick="toggleMenuEvent()">
        </div>
        <div id="myInfo">
            <img src="../image/profile.svg" id="profile">
            <div id="detailInfo">
                <p id="department">개발부</p>
                <p id="position">팀원</p>
                <p id="name">홍길동</p>
            </div>
            <p id="phoneNumber">010-1234-5678</p>
            <input type="button" value="정보수정" id="editInfoButton" onclick="editInfoEvent()">
        </div>
        
    </div>

    <div id="year">
        <img src="../image/left.png" class="yearSelectButton" onclick="lastYearEvent()">
        <p id="yearValue"></p>
        <img src="../image/right.png" class="yearSelectButton" onclick="nextYearEvent()">
    </div>

    <div id="month">
    </div>
    <div id="calendar">
        <div id="calendarHeader">
            <p id="monthValue">5월</p>
        </div>
    </div>
    <script>

        //오늘 날짜 입력
        var today = new Date();
        var todayValue = document.getElementById("todayValue");
        var date = today.getFullYear()+ '.' +(today.getMonth()+1)+ '.' +today.getDate();
        todayValue.innerHTML = date;

        //메뉴바 토글 이벤트
        function toggleMenuEvent(event) {
            var menuBar = document.getElementById("menuBar");
            if (getComputedStyle(menuBar).right === "-230px") {
                menuBar.style.right = "0px";
            } 
            else{
                menuBar.style.right = "-230px";
            }
        }

        //올해 년도 입력
        var yearValue = document.getElementById("yearValue");
        var year = today.getFullYear()
        yearValue.innerHTML = year;

        //년도 선택 이벤트
        function lastYearEvent() {
            year--;
            updateYear();
        }
        function nextYearEvent() {
            year++;
            updateYear();
        }
        function updateYear() {
            yearValue.innerHTML = year;
        }

        //월 버튼 입력
        var month = document.getElementById("month")
        for (var i=0; i<12; i++) {
            var monthSelectButton = document.createElement("p")
            monthSelectButton.innerHTML = i+1;
            monthSelectButton.className = "monthSelectButton";
            monthSelectButton.addEventListener('click', monthSelectEvent);
            month.appendChild(monthSelectButton);
        }

        //월 선택 이벤트
        var monthValue = document.getElementById("monthValue");
        function monthSelectEvent(event) {
            var buttons = document.getElementsByClassName("monthSelectButton");
            for (var i = 0; i < buttons.length; i++) {
            buttons[i].classList.remove("selected");
            }
            var clickedMonthButton = event.target;
            var clickedMonthValue = clickedMonthButton.innerHTML;
            monthValue.innerHTML = null;
            monthValue.innerHTML = clickedMonthValue + '월';
            clickedMonthButton.classList.add("selected");
        }

        var calendar = document.getElementById("calendar");
        for (var i=0; i<31; i++) {
            var daySelectButton = document.createElement("div")
            daySelectButton.innerHTML = i+1;
            daySelectButton.className = "daySelectButton";
            daySelectButton.addEventListener('click', showDetailEvent);
            calendar.appendChild(daySelectButton);
        }


        function logOutEvent() {}

        function editInfoEvent() {
            location.href="editInfo.jsp";
        }

        function showDetailEvent() {
            let options = "toolbar=no, scrollbars=no, resizable=yes, status=no, menubar=no, width=600, height=400";
            var ret = window.open("scheduleDetail.jsp", "상세일정", options)
        }
    </script>
</body>
</html>