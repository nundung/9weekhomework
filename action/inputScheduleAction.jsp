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
    
    //이 페이지의 계정 id값 받아오기 
    String pageId = request.getParameter("id"); 

    String date = request.getParameter("date"); 
    String time = request.getParameter("time"); 
    String title = request.getParameter("title"); 

    //값이 null값이 아닌지 체크
    if (pageId == null || date == null || time == null || title == null) {
        out.println("<div>올바르지 않은 접근입니다.</div>");
        return;
    }

    //세션값 받아줌
    Integer accountIdx = (Integer)session.getAttribute("accountIdx");
    if (accountIdx == 0) {
        out.println("<div>올바르지 않은 접근입니다.</div>");
        return;
    }

    Object idSession = session.getAttribute("id");
    String id = (String)idSession;

    //내가 이 페이지의 주인이 맞는지 체크
    if(!id.equals(pageId)) {
        out.println("<div>올바르지 않은 접근입니다.</div>");
        return;
    }
    Connection connect = null;
    PreparedStatement query = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

        String sql = "INSERT INTO schedule (date, time, title, account_idx) VALUES (?, ?, ?, ?)";
        query = connect.prepareStatement(sql);
        query.setString(1,date);
        query.setString(2,time);
        query.setString(3,title);
        query.setInt(4,accountIdx);

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
        var date = "<%=date%>";
        var id = "<%=pageId%>";
        location.href = "../page/scheduleDetail.jsp?id=" + id + "&date=" + date;
    </script>
</body>
</html>