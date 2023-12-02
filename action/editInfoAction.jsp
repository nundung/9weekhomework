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

	//값을 받아서 변수에 저장해 준다.
	//변수의 자료형을 String으로 지정
	String pw = request.getParameter("pw");
	String name = request.getParameter("name");
	String phonenumber = request.getParameter("phonenumber");
	String team = request.getParameter("team");
	String position = request.getParameter("position");

    //입력값 체크
    if (pw == null || name == null || phonenumber == null || team == null || position == null) {
        out.println("<div>올바르지 않은 접근입니다.</div>");
        return;
    }

    //세션으로 accountIdx값 받아줌
    int accountIdx = (Integer)session.getAttribute("accountIdx");

    if (accountIdx == 0) {
        out.println("<div>올바르지 않은 접근입니다.</div>");
        return;
    }

    Object idSession = session.getAttribute("id");
    String id = (String)idSession;


    //비밀번호 정규식
    String pwReg = "(?=.*[a-zA-z])(?=.*\\d)(?=.*[$`~!@$!%*#^?&\\\\(\\\\)\\-_=+]).{8,20}";
    Pattern pwPattern = Pattern.compile(pwReg);
    Matcher pwMatcher = pwPattern.matcher(pw);

    //이름 정규식
    String nameReg = "[가-힣]{2,4}";
    Pattern namePattern = Pattern.compile(nameReg);
    Matcher nameMatcher = namePattern.matcher(name);

    //전화번호 정규식
    String phonenumberReg = "01([0|1|6|7|8|9])-?([0-9]{4})-?([0-9]{4})";
    Pattern phonenumberPattern = Pattern.compile(phonenumberReg);
    Matcher phonenumberMatcher = phonenumberPattern.matcher(phonenumber);

    //정규식 확인
    if (!pwMatcher.matches() || !nameMatcher.matches() || !phonenumberMatcher.matches()) {
        out.println("<div>유효하지 않은 값입니다.</div>");
        return;
    }

    //부서 확인
    if (!("개발".equals(team) || "디자인".equals(team))) {
        out.println("<div>유효하지 않은 값입니다.</div>");
        return;
    }

    //직급 확인
    if (!("팀원".equals(position) || "팀장".equals(position))) {
        out.println("<div>유효하지 않은 값입니다.</div>");
        return;
    }
    

    Connection connect = null;
    PreparedStatement query = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

        //세션의 accountIdx값과 schedule테이블의 accountIdx값이 같은경우에만 쿼리문 전송 되도록
        String sql = "UPDATE account SET pw = ?, name = ?, phonenumber = ?, team = ?, position = ? WHERE idx = ?";
        query = connect.prepareStatement(sql);
        query.setString(1,pw);
        query.setString(2,name);
        query.setString(3,phonenumber);
        query.setString(4,team);
        query.setString(5,position);
        query.setInt(6,accountIdx);

        query.executeUpdate();

        //세션에 값 설정
        session.setAttribute("name", name);
        session.setAttribute("pw", pw);
        session.setAttribute("phonenumber", phonenumber);
        session.setAttribute("team", team);
        session.setAttribute("position", position);
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
        var id = "<%=id%>";
        var date = new Date();
        var year = date.getFullYear();
        var month = date.getMonth()+1;
        var day = date.getDate();
        location.href = "../page/schedule.jsp?id=" + id + "&year=" + year + "&month=" + month + "&day=" + day;
    </script>
</body>
</html>