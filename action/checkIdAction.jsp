<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

//데이터베이스 탐색 라이브러리
<%@ page import="java.sql.DriverManager" %>

//데이터베이스 연결 라이브러리
<%@ page import="java.sql.Connection" %>

//SQL 전송가능한 쿼리문으로 바꿔주는 라이브러리
<%@ page import="java.sql.PreparedStatement" %>

//DB데이터 받아오기 라이브러리
<%@ page import="java.sql.ResultSet" %>

//리스트 라이브러리
<%@ page import="java.util.ArrayList" %>

//예외처리
<%@ page import="java.sql.SQLException" %>

<% 
    //전페이지에서 온 데이터에 대해서 인코딩 설정
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id"); 
    
    //id값이 null값일 경우 기본값 설정
    if(id == null) {
        id = "0";
    }

    //변수 선언
    Connection connect = null;
    PreparedStatement query = null;
    ResultSet result = null;
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");
        String sql = "SELECT * FROM account WHERE id = ?";
        query = connect.prepareStatement(sql);
        query.setString(1, id);
        result = query.executeQuery();
    }
    catch (Exception e) {
        e.printStackTrace();
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
            e.printStackTrace();
        }
    }
%>


<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디 중복체크</title>
</head>
<body>
    <script>
        var id = "<%= id %>";
        console.log(id);
    </script>
</body>
</html>