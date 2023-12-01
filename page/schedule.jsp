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
    
    //id정보 받아오기
    String pageId = request.getParameter("id");
    
    //오늘 날짜 정보 받아오기
    String year = request.getParameter("year"); 
    String month = request.getParameter("month"); 
    String day = request.getParameter("day"); 


    //세션값 받아줌
    int accountIdx = (Integer)session.getAttribute("accountIdx");

    if (accountIdx == 0) {
        out.println("<div>올바른 접근이 아닙니다.</div>");
        return;
    }

    Object idSession = session.getAttribute("id");
    String id = (String)idSession;

    Object nameSession = session.getAttribute("name");
    String name = (String)nameSession;

    Object phonenumberSession = session.getAttribute("phonenumber");
    String phonenumber = (String)phonenumberSession;

    Object teamSession = session.getAttribute("team");
    String team = (String)teamSession;

    Object positionSession = session.getAttribute("position");
    String position = (String)positionSession;



    Connection connect = null;

    //이 페이지의 일별 일정개수 불러오기
    PreparedStatement scheduleQuery = null;
    ResultSet scheduleResult = null;

    //이 페이지가 만약 팀장이 보는 팀원의 페이지라면 팀원의 accountIdx를 불러오기
    PreparedStatement pageIdQuery = null;
    ResultSet pageIdResult = null;

    //팀장일 경우 팀원리스트 불러오기
    PreparedStatement memberQuery = null;
    ResultSet memberResult = null;


    ArrayList<String> scheduleDateList = new ArrayList<String>();

    ArrayList<String> memberNameList = new ArrayList<String>();
    ArrayList<String> memberPhonenumberList = new ArrayList<String>();
    ArrayList<String> memberIdList = new ArrayList<String>();

    int pageMemberIdx = 0;
    String pageMemberName = "null";
    String memberPageCheck = "false";
    String leaderCheck = "false";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

        //이 페이지의 일별 일정개수 불러오기
        String scheduleSql = "SELECT * FROM schedule WHERE account_idx = ? AND YEAR(date) = ? AND MONTH(date) = ?";
        scheduleQuery = connect.prepareStatement(scheduleSql);

        //내가 이 페이지의 주인일때 세션에서 받은 accountIdx 쿼리문에 입력
        if(id.equals(pageId)) {
            scheduleQuery.setInt(1,accountIdx);
        }

        //팀원의 페이지라면 팀원의 accountIdx 찾아서 쿼리문에 입력
        else {
            String pageIdSql = "SELECT * FROM account WHERE id = ?";
            pageIdQuery = connect.prepareStatement(pageIdSql);
            pageIdQuery.setString(1,pageId);

            //return값을 저장해줌
            pageIdResult = pageIdQuery.executeQuery();

            while(pageIdResult.next()) {
                pageMemberIdx = pageIdResult.getInt(1);
                pageMemberName = pageIdResult.getString(4);
            }
            scheduleQuery.setInt(1,pageMemberIdx);
            memberPageCheck = "true";
        }
        //이 페이지의 year값과 month값 쿼리문에 입력
        scheduleQuery.setString(2,year);
        scheduleQuery.setString(3,month);

        //return값을 저장해줌
        scheduleResult = scheduleQuery.executeQuery();

        while(scheduleResult.next()) {
            String scheduleDate = scheduleResult.getString(2);
            
            scheduleDateList.add("\""+scheduleDate+"\"");
        }

        //내 직급이 팀장일 경우 팀원 목록을 불러오기
        if(position.equals("팀장")){
            String memberSql = "SELECT * FROM account WHERE team = ? AND position = '팀원'";
            memberQuery = connect.prepareStatement(memberSql);
            memberQuery.setString(1,team);
    
            //return값을 저장해줌
            memberResult = memberQuery.executeQuery();
    
            while(memberResult.next()) {
                String memberId = memberResult.getString(2);
                String memberName = memberResult.getString(4);
                String memberPhonenumber = memberResult.getString(5);
    
                memberIdList.add("\""+memberId+"\"");
                memberNameList.add("\""+memberName+"\"");
                memberPhonenumberList.add("\""+memberPhonenumber+"\"");
            }
            leaderCheck = "true";
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
        var id = "<%=id%>";
        var pageId = "<%=pageId%>";
        var memberPageCheck = "<%=memberPageCheck%>";
        var pageMemberName = "<%=pageMemberName%>";
        var leaderCheck = "<%=leaderCheck%>";

        var scheduleDateList = <%=scheduleDateList%>;

        var memberIdList = <%=memberIdList%>;
        var memberNameList = <%=memberNameList%>;
        var memberPhonenumberList = <%=memberPhonenumberList%>;

        var nameValue = "<%=name%>";
        var phonenumberValue = "<%=phonenumber%>";
        var teamValue = "<%=team%>";
        var positionValue = "<%=position%>";
        var nameSection = document.getElementById("name");
        var phonenumberSection = document.getElementById("phonenumber");
        var teamSection = document.getElementById("team");
        var positionSection = document.getElementById("position");

        //Parameter로 받은 날짜 정보
        var year = "<%=year%>";
        var month = "<%=month%>";
        var day = "<%=day%>";
        
        //실제 오늘 날짜
        var date = new Date();
        var thisYear = date.getFullYear();
        var thisMonth = date.getMonth() + 1;
        var thisDay = date.getDate();
        

        //문서와 모든 자원이 완전히 로드되었을 때 실행되는 함수
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
