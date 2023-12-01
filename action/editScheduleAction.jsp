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


<%
    //전페이지에서 온 데이터에 대해서 인코딩 설정
    request.setCharacterEncoding("UTF-8");
    

    //계정 id값 받아오기 
    String id = request.getParameter("id"); 

    //스케줄 정보 받아오기
    String scheduleIdxString = request.getParameter("scheduleIdx"); 
    String date = request.getParameter("date");
    String scheduleTime = request.getParameter("scheduleTime");
    String scheduleTitle = request.getParameter("scheduleTitle");

    if (scheduleIdxString == null) {
        out.println("<div>올바른 접근이 아닙니다.</div>");
        return;
    }
    //int로 변환
    int scheduleIdx = Integer.parseInt(scheduleIdxString);

    if (date == null || scheduleTime == null || scheduleTitle == null) {
        out.println("<div>입력값이 부족합니다.</div>");
        return;
    }

    //세션값 받아줌
    int accountIdx = (Integer)session.getAttribute("accountIdx");

    if (accountIdx == 0) {
        out.println("<div>올바른 접근이 아닙니다.</div>");
        return;
    }

    Connection connect = null;
    PreparedStatement query = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

        String sql = "UPDATE schedule SET time = ?, title = ? WHERE idx = ? AND account_idx = ?";
        query = connect.prepareStatement(sql);
        query.setString(1,scheduleTime);
        query.setString(2,scheduleTitle);
        query.setInt(3,scheduleIdx);
        query.setInt(4,accountIdx);

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
        var date = "<%=date%>";
        var id = "<%=id%>";
        location.href = "../page/scheduleDetail.jsp?id=" + id + "&date=" + date;
    </script>
</body>
</html>