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
    
    String date = request.getParameter("date"); 
    String scheduleIdxString = request.getParameter("scheduleIdx"); 

    if (scheduleIdxString == null) {
        out.println("<div>올바른 접근이 아닙니다.</div>");
        return;
    }
    
    int scheduleIdx = Integer.parseInt(scheduleIdxString);

    //세션값 받아줌
    int accountIdx = (Integer)session.getAttribute("accountIdx");

    Connection connect = null;
    PreparedStatement query = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

        String sql = "DELETE FROM schedule WHERE idx = ? ";
        query = connect.prepareStatement(sql);
        query.setInt(1,scheduleIdx);
        
        query.executeUpdate();
    }
    catch (SQLException e) {
        out.println("<div>예상치 못한 오류가 발생했습니다.</div>");
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
        var date = "<%=date%>";
        location.href="../page/scheduleDetail.jsp?date="+date;
    </script>
</body>
</html>