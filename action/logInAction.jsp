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

    String idInput = request.getParameter("id"); 
    String pwInput = request.getParameter("pw"); 

    if (idInput == null || pwInput == null) {
        return;
    }

    Connection connect = null;
    PreparedStatement query = null;
    ResultSet result = null;

    Class.forName("com.mysql.jdbc.Driver");

    connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

    String sql = "SELECT * FROM account WHERE id= ? AND pw = ?";
	query = connect.prepareStatement(sql);
	query.setString(1, idInput);
    query.setString(2, pwInput);

    //return값을 저장해줌
    result = query.executeQuery();
    
    String logInCheck = "null";

    try {
        int accountIdx = 0;
        String pw = "null";
        String name = "null";
        String phonenumber = "null";
        String team = "null";
        String position = "null";

        // 입력한 값과 일치하는 데이터 레코드가 있는지 체크
        if(result.next()) {
            accountIdx = result.getInt(1);
            pw = result.getString(3);
            name = result.getString(4);
            phonenumber = result.getString(5);
            team = result.getString(6);
            position = result.getString(7);
            
            //세션에 값 설정
            session.setAttribute("accountIdx", accountIdx);
            session.setAttribute("id", idInput);
            session.setAttribute("name", name);
            session.setAttribute("pw", pw);
            session.setAttribute("phonenumber", phonenumber);
            session.setAttribute("team", team);
            session.setAttribute("position", position);
            logInCheck = "ok";
        }
        else {
            logInCheck = "notOk";
        }
    } 
    catch (SQLException e) {
        out.println("<div>예상치 못한 오류가 발생했습니다.</div>");
        e.printStackTrace();
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
            if (result != null) {
                result.close();
            } 
        }
        catch (SQLException e) {
            out.println("<div>예상치 못한 오류가 발생했습니다.</div>");
            return;
        }
    }
%>

    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
    </head>
    <body>
        <script>
            var logInCheck = "<%=logInCheck%>";
            if(logInCheck == "ok") {
                console.log(logInCheck);
                location.href = "../page/schedule.jsp";
            }
            else {
                console.log(logInCheck);
                alert("일치하는 계정정보가 존재하지 않습니다.")
                location.href = "../index.jsp";
            }
        </script>
    </body>