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

<!-- 타임스탬프 -->
<%@ page import="java.sql.Timestamp" %>

<%
    //전페이지에서 온 데이터에 대해서 인코딩 설정
    request.setCharacterEncoding("UTF-8");

    Connection connect = null;
    PreparedStatement query = null;

    Integer idx = null;
    String date = null;

    try {
        //이 페이지의 날짜 정보 받아오기
        date = request.getParameter("date"); 

        //스케줄 정보 받아오기
        String scheduleIdxString = request.getParameter("scheduleIdx"); 
        String time = request.getParameter("time");
        String title = request.getParameter("title");

        if (scheduleIdxString == null || date == null || scheduleIdxString == null || time == null || title == null) {
            out.println("<div>올바르지 않은 접근입니다.</div>");
            return;
        }

        String[] dateParts = date.split(". ");
        Integer year = Integer.parseInt(dateParts[0]);
        Integer month = Integer.parseInt(dateParts[1]);
        Integer day = Integer.parseInt(dateParts[2]);
        Integer scheduleIdx = Integer.parseInt(scheduleIdxString);

        //세션값 받아줌
        idx = (Integer)session.getAttribute("idx");
        if (idx == null) {
            out.println("<div>올바르지 않은 접근입니다.</div>");
            return;
        }

        //이 부분은 생략해도 됨
        //이 페이지의 계정 idx값 받아오기 
        String pageIdxString = request.getParameter("idx");
        Integer pageIdx = Integer.parseInt(pageIdxString);
        //내가 이 페이지의 주인이 맞는지 체크
        if(idx != pageIdx) {
            out.println("<div>올바르지 않은 접근입니다.</div>");
            return;
        }

        String dateTime = year + "-" + month + "-" + day + " " + time + ":00";
        Timestamp timestamp = Timestamp.valueOf(dateTime);

        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

        //세션의 accountIdx값과 schedule테이블의 accountIdx값이 같은경우에만 쿼리문 전송 되도록
        String sql = "UPDATE schedule SET time = ?, title = ? WHERE idx = ? AND account_idx = ? ";
        query = connect.prepareStatement(sql);
        query.setTimestamp(1, timestamp);
        query.setString(2, title);
        query.setInt(3, scheduleIdx);
        query.setInt(4, idx);

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
        var idx = <%=idx%>;
        var date = "<%=date%>";
        
        location.href = "../page/scheduleDetail.jsp?idx=" + idx + "&date=" + date;
    </script>
</body>
</html>