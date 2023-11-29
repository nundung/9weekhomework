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
    
    //Input 정보 받아오기
    String yearString = request.getParameter("year"); 
    String monthString = request.getParameter("month"); 
    String dayString = request.getParameter("day"); 

    String time = request.getParameter("time"); 
    String title = request.getParameter("title"); 

    //값이 null값이 아닌지 체크
    if (yearString == null || monthString == null || dayString == null || time == null || title == null) {
        out.println("<div>입력값이 부족합니다.</div>");
        return;
    }
    
    int year = Integer.parseInt(yearString);
    int month = Integer.parseInt(monthString);
    int day = Integer.parseInt(dayString);


    //세션값 받아줌
    int accountIdxValue = (Integer)session.getAttribute("accountIdx");

    Object idSession = session.getAttribute("id");
    String id = (String)idSession;


    Connection connect = null;
    PreparedStatement query = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

        String sql = "INSERT INTO schedule (year, month, day, time, title, account_idx) VALUES (?, ?, ?, ?, ?, ?)";
        query = connect.prepareStatement(sql);
        query.setInt(1,year);
        query.setInt(2,month);
        query.setInt(3,day);
        query.setString(4,time);
        query.setString(5,title);
        query.setInt(6,accountIdxValue);

        //SQL 전송
        query.executeUpdate();
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
    <title>Document</title>
</head>
<body>
    <script>
        var year = "<%=year%>";
        var month = "<%=month%>";
        var day = "<%=day%>";
        var id = "<%=id%>";
        location.href = "../page/scheduleDetail.jsp?id=" + id + "&year=" + year + "&month=" + month + "&day=" + day;
    </script>
</body>
</html>