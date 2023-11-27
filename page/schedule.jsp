<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

<!-- 데이터베이스 탐색 라이브러리 -->
<%@ page import="java.sql.DriverManager" %>

<!-- 데이터베이스 연결 -->
<%@ page import="java.sql.Connection" %>

<!-- SQL 전송가능한 쿼리문으로 바꿔주는 -->
<%@ page import="java.sql.PreparedStatement" %>

<!-- DB데이터 받아오기-->
<%@ page import="java.sql.ResultSet" %>

<!-- 예외처리 -->
<%@ page import="java.sql.SQLException" %>

<!-- 정규식 -->
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>


<%
    //전페이지에서 온 데이터에 대해서 인코딩 설정
    request.setCharacterEncoding("UTF-8");
    
    //오늘 날짜 정보 받아오기
    String year = request.getParameter("year"); 
    String month = request.getParameter("month"); 
    String day = request.getParameter("day"); 


    //세션값 받아줌
    int accountIdxValue = (Integer)session.getAttribute("accountIdx");

    Object nameSession = session.getAttribute("name");
    String nameValue = (String)nameSession;

    Object phonenumberSession = session.getAttribute("phonenumber");
    String phonenumberValue = (String)phonenumberSession;
    
    Object teamSession = session.getAttribute("team");
    String teamValue = (String)teamSession;
    
    Object positionSession = session.getAttribute("position");
    String positionValue = (String)positionSession;
    
    //예외처리
    if (accountIdxValue == 0) {
        out.println("<div>올바른 접근이 아닙니다.</div>");
        return;
    }
    
    Connection connect = null;
    PreparedStatement query = null;
    ResultSet result = null;

    Class.forName("com.mysql.jdbc.Driver");
    connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

    String sql = "SELECT * FROM schedule WHERE account_idx = ?";
	query = connect.prepareStatement(sql);
	query.setInt(1,accountIdxValue);

    //return값을 저장해줌
    result = query.executeQuery();

    int scheduleIdx = 0;
    String scheduleName = "null";
    String scheduleDate = "null";
    
    boolean schedule = false;

    try {
        // 입력한 값과 일치하는 데이터 레코드가 있는지 체크
        if(result.next()) {
            scheduleIdx = result.getInt(1);
            scheduleName = result.getString(2);
            scheduleDate = result.getString(3);
            schedule = true;
        }
        else {
            schedule = false;
        }
    }
    catch (SQLException e) {
        out.println("<div>예상치 못한 오류가 발생했습니다.</div>");
        e.printStackTrace();
        return;
    }
    finally {
        try {
            if (connect != null) {
                connect.close();
        }
            if (query != null) {
                query.close();
        }
            if (result != null) {
                result.close();
            } 
        }
        catch (SQLException e) {
            out.println("<div>예상치 못한 오류가 발생했습니다.</div>");
            return;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스케줄</title>
    <link rel="stylesheet" type="text/css" href="../css/schedule.css">
    <link rel="stylesheet" type="text/css" href="../css/scheduleNav.css">
    <link rel="stylesheet" type="text/css" href="../css/common.css">
</head>
<body>
    <!-- 상단헤더 -->
    <header>
        <img src="../image/home.svg" class="headerIcon" onclick="reloadEvent()">
        <p id="todaySection"></p>
        <img src="../image/menu.svg" class="headerIcon" onclick="toggleMenuEvent()">
    </header>
    <main>
        <!-- year 선택 버튼 -->
        <section id="yearSection">
            <img src="../image/left.png" class="yearSelectButton" onclick="lastYearEvent()">
            <p id="yearValue"></p>
            <img src="../image/right.png" class="yearSelectButton" onclick="nextYearEvent()">
        </section>

        <!-- month 선택 버튼 -->
        <section id="monthSelectSection">
        </section>
        <div id="calendar">
            <div id="calendarHeader">
                <p id="monthValue"></p>
            </div>
        </div>
    </main>
    
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
    <script>

        var year = "<%=year%>";
        var month = "<%=month%>";
        var day = "<%=day%>";

        var nameValue = "<%=nameValue%>";
        var phonenumberValue = "<%=phonenumberValue%>";
        var teamValue = "<%=teamValue%>";
        var positionValue = "<%=positionValue%>";

        var nameId = document.getElementById("name");
        var phonenumber = document.getElementById("phonenumber");
        var team = document.getElementById("team");
        var position = document.getElementById("position");
        
        nameId.innerHTML = nameValue;
        phonenumber.innerHTML = phonenumberValue;
        team.innerHTML = teamValue + "부";
        position.innerHTML = positionValue
        
        var date = new Date();
        var thisYear = date.getFullYear();
        var thisMonth = date.getMonth() + 1;
        var thisDay = date.getDate();

        //헤더 중앙부에 오늘 날짜 입력
        var todaySection = document.getElementById("todaySection");
        var today = thisYear + '.' + thisMonth + '.' + thisDay;
        todaySection.innerHTML = today;

        //홈 버튼 클릭시 이번달 달력 표시
        function reloadEvent() {
            location.href = "schedule.jsp?year=" + thisYear + "&month=" + thisMonth + "&day=" + thisDay;
        }
        //올해 년도 입력
        var yearValue = document.getElementById("yearValue");
        yearValue.innerHTML = year;

        //년도 선택 이벤트
        function lastYearEvent() {
            year = parseInt(year) - 1;
            location.href = "schedule.jsp?year=" + year + "&month=" + month + "&day=" + day;
        }
        function nextYearEvent() {
            year = parseInt(year) + 1;
            location.href = "schedule.jsp?year=" + year + "&month=" + month + "&day=" + day;
        }

        //월 선택 버튼 입력
        for (var i=0; i<12; i++) {
            var monthSelectSection = document.getElementById("monthSelectSection");
            var monthSelectButton = document.createElement("p")
            monthSelectButton.innerHTML = i+1;
            monthSelectButton.className = "monthSelectButton";
            monthSelectButton.addEventListener('click', monthSelectEvent);
            monthSelectSection.appendChild(monthSelectButton);
        }

        //월 버튼 클릭 이벤트
        function monthSelectEvent(event) {
            var clickedMonth = event.target.innerHTML;
            location.href = "schedule.jsp?year=" + year + "&month=" + clickedMonth + "&day=" + day;
        }

        var calendar = document.getElementById("calendar");
        var calendarHeader = document.getElementById("calendarHeader");
        calendarHeader.innerHTML = month + '월';
        calendar.appendChild(calendarHeader);
        var daysInMonth = new Date(year, month, 0).getDate();
        for (var i = 0; i < daysInMonth; i++) {
                var daySelectButton = document.createElement("div");
                daySelectButton.innerHTML = i + 1;
                daySelectButton.id = i + 1;
                daySelectButton.className = "daySelectButton";

                if (year == thisYear && month == thisMonth && (i + 1) === thisDay) {
                    daySelectButton.id = "todayButton";
                }
                daySelectButton.addEventListener('click', showDetailEvent);
                calendar.appendChild(daySelectButton);
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
            var clickedDay = event.target.innerHTML
            let options = "toolbar=no, scrollbars=no, resizable=yes, status=no, menubar=no, width=600, height=400, top=200, left=500";
            var ret = window.open("scheduleDetail.jsp?year=" + year + "&month=" + month +"&day="+ clickedDay, "상세일정", options)
        }

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
    </script>
</body>
</html>

