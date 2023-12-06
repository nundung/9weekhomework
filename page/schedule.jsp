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


<%
    //전페이지에서 온 데이터에 대해서 인코딩 설정
    request.setCharacterEncoding("UTF-8");

    Connection connect = null;

    //이 페이지의 일정리스트 불러오기
    PreparedStatement scheduleQuery = null;
    ResultSet scheduleResult = null;

    //이 페이지가 만약 팀장이 보는 팀원의 페이지라면 팀원의 idx를 불러오기
    PreparedStatement pageIdQuery = null;
    ResultSet pageIdResult = null;

    //팀장일 경우 팀원리스트 불러오기
    PreparedStatement memberQuery = null;
    ResultSet memberResult = null;

    Integer pageIdx = null;
    String year = null;
    String month = null;
    String day = null;

    Integer idx = null;
    String name = null;
    String phonenumber = null;
    Integer team = null;
    Integer position = null;

    int pageMemberIdx = 0;
    String pageMemberName = null;
    boolean memberPageCheck = false;
    boolean leaderCheck = false;

    ArrayList<String> scheduleDateList = new ArrayList<String>();
    ArrayList<String> memberNameList = new ArrayList<String>();
    ArrayList<String> memberPhonenumberList = new ArrayList<String>();
    ArrayList<Integer> memberIdxList = new ArrayList<Integer>();

    try {
        //이 페이지의 idx정보 받아오기
        String pageIdxString = request.getParameter("idx");
        
        //오늘 날짜 정보 받아오기
        year = request.getParameter("year"); 
        month = request.getParameter("month"); 
        day = request.getParameter("day"); 

        //입력값 null체크
        if (pageIdxString == null || year == null || month == null || day == null) {
            out.println("<div>올바르지 않은 접근입니다.</div>");
            return;
        }
        pageIdx = Integer.parseInt(pageIdxString);


        //세션값 받아줌
        idx = (Integer)session.getAttribute("idx");

        Object nameSession = session.getAttribute("name");
        name = (String)nameSession;

        Object phonenumberSession = session.getAttribute("phonenumber");
        phonenumber = (String)phonenumberSession;

        team = (Integer)session.getAttribute("team");

        position = (Integer)session.getAttribute("position");

        if (idx == null || name == null || phonenumber == null || team == null || position == null) {
            out.println("<div>올바르지 않은 접근입니다.</div>");
            return;
        }

        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

        //이 페이지의 일별 일정개수 불러오기
        String scheduleSql = "SELECT * FROM schedule WHERE account_idx = ? AND YEAR(time) = ? AND MONTH(time) = ?";
        scheduleQuery = connect.prepareStatement(scheduleSql);

        //내가 이 페이지의 주인일때 세션에서 받은 idx 쿼리문에 입력
        if(pageIdx == idx) {
            scheduleQuery.setInt(1,idx);
        }
        //팀원의 페이지라면 팀원의 idx를 입력하고 팀원의 이름 찾아오기
        else {
            String pageIdSql = "SELECT * FROM account WHERE idx = ?";
            pageIdQuery = connect.prepareStatement(pageIdSql);
            pageIdQuery.setInt(1,pageIdx);

            //return값을 저장해줌
            pageIdResult = pageIdQuery.executeQuery();

            while(pageIdResult.next()) {
                pageMemberName = pageIdResult.getString(4);
            }
            scheduleQuery.setInt(1,pageIdx);
            memberPageCheck = true;
        }
        //이 페이지의 year값과 month값도 쿼리문에 입력
        scheduleQuery.setString(2,year);
        scheduleQuery.setString(3,month);

        //return값을 저장해줌
        scheduleResult = scheduleQuery.executeQuery();

        while(scheduleResult.next()) {
            String scheduleDate = scheduleResult.getString(2);
            scheduleDateList.add("\""+scheduleDate+"\"");
        }

        //내 직급이 팀장일 경우 팀원 목록을 불러오기
        if(position == 2){
            String memberSql = "SELECT * FROM account WHERE team_idx = ? AND position_idx = 1";
            memberQuery = connect.prepareStatement(memberSql);
            memberQuery.setInt(1,team);
    
            //return값을 저장해줌
            memberResult = memberQuery.executeQuery();
    
            while(memberResult.next()) {
                Integer memberIdx = memberResult.getInt(1);
                String memberName = memberResult.getString(4);
                String memberPhonenumber = memberResult.getString(5);
    
                memberIdxList.add(memberIdx);
                memberNameList.add("\""+memberName+"\"");
                memberPhonenumberList.add("\""+memberPhonenumber+"\"");
            }
            leaderCheck = true;
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
        <img src="../image/home.svg" class="headerIcon" onclick="homeButtonEvent()">
        <section id = "headerMid">
            <p id="memberNameSection"></p>
            <p id="todaySection"></p>
        </section>
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
        <section id="monthSelectSection"></section>
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
        <input type="button" value="돌아가기" id="comeBackButton" onclick="comeBackEvent()">
        <section id="memberList"></section>
    </nav>

    <script>
        var pageIdx = <%=pageIdx%>;
        var idx = <%=idx%>;

        var nameValue = "<%=name%>";
        var phonenumberValue = "<%=phonenumber%>";
        var team = "<%=team%>";
        var teamValue = null;
        if(team == 1) {
            var teamValue = "개발";
        }
        else if(team == 2) {
            var teamValue = "디자인";
        }

        var position = "<%=position%>";
        var positionValue = null;
        if(position == 1) {
            var positionValue = "팀원";
        }
        else if(position == 2) {
            var positionValue = "팀장";
        }

        var memberPageCheck = "<%=memberPageCheck%>";
        var leaderCheck = "<%=leaderCheck%>";
        var pageMemberName = "<%=pageMemberName%>";

        var scheduleDateList = <%=scheduleDateList%>;
        var memberIdxList = <%=memberIdxList%>;
        var memberNameList = <%=memberNameList%>;
        var memberPhonenumberList = <%=memberPhonenumberList%>;

        console.log(scheduleDateList);
        //현재 페이지의 날짜
        var year = "<%=year%>";
        var month = "<%=month%>";
        var day = "<%=day%>";
        
        //실제 오늘 날짜
        var date = new Date();
        var thisYear = date.getFullYear();
        var thisMonth = date.getMonth() + 1;
        var thisDay = date.getDate();
        
        var month0 = String(month).padStart(2, '0');
        var day0 = String(day).padStart(2, '0');
        
        //map : 배열의 각 요소에 대해 주어진 함수를 호출하고, 그 함수가 반환하는 결과를 모아 새로운 배열을 생성
        //스케줄 날짜 리스트에서 일(day)값만 추출
        const extractedDays = scheduleDateList.map(function(scheduleDate) {
            const date = new Date(scheduleDate);
            const day = date.getDate();
            return day;
        });

        //홈 버튼 클릭 이벤트
        //내 페이지로 이동
        function homeButtonEvent() {
            location.href = "schedule.jsp?idx=" + idx + "&year=" + thisYear + "&month=" + thisMonth + "&day=" + thisDay;
        }

        //년도 선택 버튼 클릭 이벤트
        //해당 년도 페이지로 이동
        function lastYearEvent() {
            year = parseInt(year) - 1;
            location.href = "schedule.jsp?idx=" + pageIdx + "&year=" + year + "&month=" + month + "&day=" + day;
        }
        function nextYearEvent() {
            year = parseInt(year) + 1;
            location.href = "schedule.jsp?idx=" + pageIdx + "&year=" + year + "&month=" + month + "&day=" + day;
        }

        //월 버튼 클릭 이벤트
        //해당 월 페이지로 이동
        function monthSelectEvent(event) {
            var clickedMonth = event.target.innerHTML;
            location.href = "schedule.jsp?idx=" + pageIdx + "&year=" + year + "&month=" + clickedMonth + "&day=" + day;
        }
        
        //팀원 버튼 클릭 이벤트
        //해당 팀원의 페이지로 이동
        function showTemMemberScheduleEvent(event) {
            var clickedIndex = event.target.dataset.index;
            var memberIdx = memberIdxList[clickedIndex];
            location.href = "schedule.jsp?idx=" + memberIdx + "&year=" + year + "&month=" + month + "&day=" + day;
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

        //내 페이지로 돌아가는 이벤트
        function comeBackEvent() {
            location.href = "schedule.jsp?idx=" + idx + "&year=" + year + "&month=" + month + "&day=" + day;
    }

        //상세일정 팝업 오픈 이벤트
        function showDetailEvent(event) {
            var clickedDay = parseInt(event.target.innerHTML);
            var clickedDate = year + '. ' + month + '. ' + clickedDay;
            let options = "toolbar=no, scrollbars=no, resizable=yes, status=no, menubar=no, width=600, height=400, top=200, left=500";
            var pop = window.open("scheduleDetail.jsp?idx=" + pageIdx + "&date=" + clickedDate, "상세일정", options);
            pop.onload = function() {
                pop.onunload = function() {
                    location.reload();
                }
            }
        }

        //문서와 모든 자원(img)이 완전히 로드되었을 때 실행되는 함수
        window.onload = function() {
            makeCalendar();
            for (var i=0; i<extractedDays.length; i++) {
                var day = extractedDays[i];
                makeSchedulesInDay(day);
            }
        }
    </script>
    <script src="../js/schedule.js"></script>
</body>
</html>
