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
    
    //클릭된 날짜 정보 받아오기
    String title = request.getParameter("title"); 
    String date = request.getParameter("date");
    String time = request.getParameter("time"); 

    //세션값 받아줌
    int accountIdxValue = (Integer)session.getAttribute("accountIdx");

    Connection connect = null;
    PreparedStatement query = null;

    Class.forName("com.mysql.jdbc.Driver");
    connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

    if (title == null || date == null || time == null) {
        out.println("<div>입력값이 부족합니다.</div>");
        return;
    }

    String sql = "INSERT INTO schedule (title, date, time, account_idx) VALUES (?, ?, ?, ?)";
	query = connect.prepareStatement(sql);
	query.setString(1,title);
	query.setString(2,date);
	query.setString(3,time);
	query.setInt(4,accountIdxValue);

    boolean scheduleInputSuccess = false;
    
    try {
        //SQL 전송
        query.executeUpdate();
        scheduleInputSuccess = true;
    }

    catch(SQLException e) {
        scheduleInputSuccess = false;
        out.println("<div>예상치 못한 오류가 발생했습니다.</div>");
    }

    finally {
        try {
            if (connect != null) {
                connect.close();
            }
            if (query != null) {
                query.close();
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
    <title>Document</title>
</head>
<body>
    <script>
        alert("완");
    </script>
</body>
</html>