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
        <img src="../image/home.svg" class="headerIcon" onclick="schedulePageEvent()">
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
        <div id="teamMemberList">

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
            <p id="monthValue"></p>
        </div>
    </div>
    <script>

        //홈 버튼 클릭시 새로고침
        function schedulePageEvent() {
            location.reload();
        }

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

        //로그아웃 이벤트
        function logOutEvent() {
            location.href = "../action/logOutAction.jsp"
        }

        //정보수정 이벤트
        function editInfoEvent() {
            location.href="editInfo.jsp";
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

        //월 선택 버튼 입력
        for (var i=0; i<12; i++) {
            var month = document.getElementById("month");
            var monthSelectButton = document.createElement("p")
            monthSelectButton.innerHTML = i+1;
            monthSelectButton.className = "monthSelectButton";
            monthSelectButton.addEventListener('click', monthSelectEvent);
            month.appendChild(monthSelectButton);
        }

        //페이지 새로고침시 이번달 달력 출력 함수 호출
        var thisMonth = today.getMonth() + 1;
        makeDaySelectButonEvent(thisMonth);

        //월 버튼 클릭 이벤트
        function monthSelectEvent(event) {
            var buttons = document.getElementsByClassName("monthSelectButton");
            for (var i = 0; i < buttons.length; i++) {
                buttons[i].classList.remove("selected");
            }
            var clickedMonthButton = event.target;
            var clickedMonthValue = clickedMonthButton.innerHTML;
            clickedMonthButton.classList.add("selected");

            //클릭된 달의 달력 출력 함수 호출
            makeDaySelectButonEvent(clickedMonthValue);
        }

        //클릭된 달의 달력 출력
        function makeDaySelectButonEvent(clickedMonthValue) {
            monthValue.innerHTML = clickedMonthValue + '월';
            var calendar = document.getElementById("calendar");
            var calendarHeader = document.getElementById("calendarHeader");
            calendar.innerHTML = "";
            calendar.appendChild(calendarHeader);
            var daysInMonth = new Date(today.getFullYear(), clickedMonthValue, 0).getDate();
            for (var i = 0; i < daysInMonth; i++) {
                    var daySelectButton = document.createElement("div");
                    daySelectButton.innerHTML = i + 1;
                    daySelectButton.id = i + 1;
                    daySelectButton.className = "daySelectButton";
                    if (thisMonth == clickedMonthValue && (i + 1) == today.getDate()) {
                        daySelectButton.id = "todayButton";
                    }                
                    daySelectButton.addEventListener('click', showDetailEvent);
                    calendar.appendChild(daySelectButton);
            
                }
        }

        var test = 7;
        makeScheldulesInDay(test);

        function makeScheldulesInDay(test) {
            var day = document.getElementById(test);
            var scheldulesInDay = document.createElement("div");
            scheldulesInDay.id = "scheldulesInDay";
            day.appendChild(scheldulesInDay);
        }
        var teamMemberList = document.getElementById("teamMemderList");

        function showDetailEvent() {
            let options = "toolbar=no, scrollbars=no, resizable=yes, status=no, menubar=no, width=600, height=400, top=200, left=500";
            var ret = window.open("scheduleDetail.jsp", "상세일정", options)
        }
    </script>
</body>
</html>

