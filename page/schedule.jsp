<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>


<%
    Object accountIdxSession = session.getAttribute("id");
    String accountIdxValue = (String)accountIdxSession;

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
    <title>스케줄</title>
    <link rel="stylesheet" type="text/css" href="../css/schedule.css">
    <link rel="stylesheet" type="text/css" href="../css/common.css">
</head>
<body>
    <!-- 상단헤더내용 -->
    <header>
        <img src="../image/home.svg" class="headerIcon" onclick="reloadEvent()">
        <p id="todayValue"></p>
        <img src="../image/menu.svg" class="headerIcon" onclick="toggleMenuEvent()">
    </header>
    <!-- 메뉴내용 -->
    <nav id= "menuBar">
        <section id="menuBarHeader">
            <input type="button" value="로그아웃" id="logOutButton" onclick="logOutEvent()">
            <img src="../image/menu.svg" class="headerIcon" onclick="toggleMenuEvent()">
        </section>
        <section class="myInfo">
            <img src="../image/profile.svg" id="profile">
            <div id="detailInfo">
                <p id="team"></p>
                <p id="position"></p>
                <p id="name"></p>
            </div>
        </section>
        <section class="myInfo">
            <p id="phonenumber"></p>
        </section>
        <input type="button" value="정보수정" id="editInfoButton" onclick="editInfoEvent()">
        <section id="teamMemberList"></section>
    </nav>

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
        var nameValue = "<%=nameValue%>";
        var phonenumberValue = "<%=phonenumberValue%>";
        var teamValue = "<%=teamValue%>";
        var positionValue = "<%=positionValue%>";

        var nameId = document.getElementById("name");
        var phonenumber = document.getElementById("phonenumber");
        var team = document.getElementById("team");
        var position = document.getElementById("position");
        
        console.log(nameValue);
        nameId.innerHTML = nameValue;
        phonenumber.innerHTML = phonenumberValue;
        team.innerHTML = teamValue + "부";
        position.innerHTML = positionValue

        
        //홈 버튼 클릭시 새로고침
        function reloadEvent() {
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
            if (getComputedStyle(menuBar).right === "-240px") {
                menuBar.style.right = "0px";
            } 
            else{
                menuBar.style.right = "-240px";
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

