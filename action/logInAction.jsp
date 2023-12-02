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

<!-- 정규식 -->
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>


<% 
    //전페이지에서 온 데이터에 대해서 인코딩 설정
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id"); 
    String pw = request.getParameter("pw"); 

    if (id == null || pw == null) {
        out.println("<div>올바르지 않은 접근입니다.</div>");
        return;
    }
    else {
        //아이디 정규식
        String idReg = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,18}$";
        Pattern idPattern = Pattern.compile(idReg);
        Matcher idMatcher = idPattern.matcher(id);

        //비밀번호 정규식
        String pwReg = "(?=.*[a-zA-z])(?=.*\\d)(?=.*[$`~!@$!%*#^?&\\\\(\\\\)\\-_=+]).{8,20}";
        Pattern pwPattern = Pattern.compile(pwReg);
        Matcher pwMatcher = pwPattern.matcher(pw);

        if (!idMatcher.matches() || !pwMatcher.matches()) {
            out.println("<div>유효하지 않은 값입니다.</div>");
        return;
        }
    }

    Connection connect = null;
    PreparedStatement query = null;
    ResultSet result = null;

    Class.forName("com.mysql.jdbc.Driver");
    connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

    String sql = "SELECT * FROM account WHERE id= ? AND pw = ?";
	query = connect.prepareStatement(sql);
	query.setString(1, id);
    query.setString(2, pw);

    //return값을 저장해줌
    result = query.executeQuery();

    boolean logInSuccess = false;

    try {
        int accountIdx = 0;
        String name = "null";
        String phonenumber = "null";
        String team = "null";
        String position = "null";

        if(result.next()) {
            accountIdx = result.getInt(1);
            name = result.getString(4);
            phonenumber = result.getString(5);
            team = result.getString(6);
            position = result.getString(7);
            
            //세션에 값 설정
            session.setAttribute("accountIdx", accountIdx);
            session.setAttribute("id", id);
            session.setAttribute("name", name);
            session.setAttribute("pw", pw);
            session.setAttribute("phonenumber", phonenumber);
            session.setAttribute("team", team);
            session.setAttribute("position", position);
            logInSuccess = true;
        }
    } 
    catch (SQLException e) {
        out.println("<div>예상치 못한 오류가 발생했습니다.</div>");
        e.printStackTrace();
        return;
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
        var logInSuccess = "<%=logInSuccess%>";
        var id = "<%=id%>";
        var date = new Date();
        var year = date.getFullYear();
        var month = date.getMonth()+1;
        var day = date.getDate();
        if(logInSuccess === "true") {
            location.href = "../page/schedule.jsp?id=" + id + "&year=" + year + "&month=" + month + "&day=" + day;
        }
        else {
            alert("일치하는 계정정보가 존재하지 않습니다.")
            location.href = "../index.jsp";
        }
    </script>
</body>