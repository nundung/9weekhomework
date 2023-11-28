<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

<!-- 데이터베이스 탐색 라이브러리 -->
<%@ page import="java.sql.DriverManager" %>

<!-- 데이터베이스 연결 -->
<%@ page import="java.sql.Connection" %>

<!-- SQL 전송가능한 쿼리문으로 바꿔주는 -->
<%@ page import="java.sql.PreparedStatement" %>

<!-- DB데이터 받아오기-->
<%@ page import="java.sql.ResultSet" %>

<!-- 리스트 -->
<%@ page import="java.util.ArrayList" %>

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
    int accountIdx = (Integer)session.getAttribute("accountIdx");

    Object nameSession = session.getAttribute("name");
    String myName = (String)nameSession;

    Object phonenumberSession = session.getAttribute("phonenumber");
    String phonenumber = (String)phonenumberSession;
    
    Object teamSession = session.getAttribute("team");
    String team = (String)teamSession;
    
    Object positionSession = session.getAttribute("position");
    String position = (String)positionSession;
    
    if (accountIdx == 0) {
        out.println("<div>올바른 접근이 아닙니다.</div>");
        return;
    }

    Connection connect = null;
    PreparedStatement scheduleQuery = null;
    ResultSet scheduleResult = null;

    PreparedStatement accountQuery = null;
    ResultSet accountResult = null;

    ArrayList<String> memberNameList = new ArrayList<String>();
    ArrayList<String> memberPhonenumberList = new ArrayList<String>();
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

        String scheduleSql = "SELECT * FROM schedule WHERE account_idx = ?";
        scheduleQuery = connect.prepareStatement(scheduleSql);
        scheduleQuery.setInt(1,accountIdx);

        //return값을 저장해줌
        scheduleResult = scheduleQuery.executeQuery();

        int scheduleIdx = 0;
        String scheduleName = "null";
        String scheduleDate = "null";

        if(scheduleResult.next()) {
            scheduleIdx = scheduleResult.getInt(1);
            scheduleName = scheduleResult.getString(2);
            scheduleDate = scheduleResult.getString(3);
        }

        if("팀장".equals(position)){
            String accountSql = "SELECT * FROM account WHERE team = ? AND position = '팀원'";
            accountQuery = connect.prepareStatement(accountSql);
            accountQuery.setString(1,team);
    
            //return값을 저장해줌
            accountResult = accountQuery.executeQuery();
    
            while (accountResult.next()) {
                String memberName = accountResult.getString(4);
                String memberPhonenumber = accountResult.getString(5);
    
                memberNameList.add("\""+memberName+"\"");
                memberPhonenumberList.add("\""+memberPhonenumber+"\"");
            }
        }
    }
    catch (SQLException e) {
        out.println("<div>예상치 못한 오류가 발생했습니다.</div>");
        return;
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
        <section id="memberList"></section>
    </nav>

    <script>
        var memberNameList = <%=memberNameList%>;
        var memberPhonenumberList = <%=memberPhonenumberList%>;
        console.log(memberNameList,memberPhonenumberList);

        var myNameValue = "<%=myName%>";
        var phonenumberValue = "<%=phonenumber%>";
        var teamValue = "<%=team%>";
        var positionValue = "<%=position%>";
        var myName = document.getElementById("name");
        var phonenumber = document.getElementById("phonenumber");
        var team = document.getElementById("team");
        var position = document.getElementById("position");


        myName.innerHTML = myNameValue;
        phonenumber.innerHTML = phonenumberValue;
        team.innerHTML = teamValue + "부";
        position.innerHTML = positionValue

        //Parameter로 받은 날짜 정보
        var year = "<%=year%>";
        var month = "<%=month%>";
        var day = "<%=day%>";
        
        //실제 오늘 날짜
        var date = new Date();
        var thisYear = date.getFullYear();
        var thisMonth = date.getMonth() + 1;
        var thisDay = date.getDate();
        
        
        //달력 
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

        //팀원목록
        var memberList = document.getElementById("memberList");
        for(var i=0; i<memberNameList.length; i++){
        var memberRow = document.createElement("div");
        memberRow.className = "memberRow";
        memberRow.innerHTML = memberNameList[i];
        memberList.appendChild(memberRow);

        }
        var test = 7;

        makeScheldulesInDay(test);

        function makeScheldulesInDay(test) {
            var day = document.getElementById(test);
            var scheldulesInDay = document.createElement("div");
            scheldulesInDay.id = "scheldulesInDay";
            day.appendChild(scheldulesInDay);
        }

        function showDetailEvent() {
            var clickedDay = event.target.innerHTML;
            var clickedDate = year+"-"+month+"-"+clickedDay;
            let options = "toolbar=no, scrollbars=no, resizable=yes, status=no, menubar=no, width=600, height=400, top=200, left=500";
            var ret = window.open("scheduleDetail.jsp?date=" + clickedDate, "상세일정", options)
        }
    </script>
    <script src="../js/schedule.js"></script>
</body>
</html>
