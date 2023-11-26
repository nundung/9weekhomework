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

    String name = request.getParameter("name"); 
    String id = request.getParameter("id"); 
    String phonenumber = request.getParameter("phonenumber"); 

    if (name == null || id == null || phonenumber == null) {
        out.println("<div>입력값이 부족합니다.</div>");
        return;
    }
    else {
        //이름 정규식
        String nameReg = "[가-힣]{2,4}";
        Pattern namePattern = Pattern.compile(nameReg);
        Matcher nameMatcher = namePattern.matcher(name);

        //아이디 정규식
        String idReg = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,18}$";
        Pattern idPattern = Pattern.compile(idReg);
        Matcher idMatcher = idPattern.matcher(id);

        //전화번호 정규식
        String phonenumberReg = "01([0|1|6|7|8|9])-?([0-9]{4})-?([0-9]{4})";
        Pattern phonenumberPattern = Pattern.compile(phonenumberReg);
        Matcher phonenumberMatcher = phonenumberPattern.matcher(phonenumber);

        if (!nameMatcher.matches() || !phonenumberMatcher.matches()) {
            out.println("<div>유효하지 않은 값입니다.</div>");
        }
    }
    

    Connection connect = null;
    PreparedStatement query = null;
    ResultSet result = null;

    Class.forName("com.mysql.jdbc.Driver");
    connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

    String sql = "SELECT * FROM account WHERE name= ? AND id = ? AND phonenumber = ?";
	query = connect.prepareStatement(sql);
	query.setString(1, name);
    query.setString(2, id);
    query.setString(3, phonenumber);

    //return값을 저장해줌
    result = query.executeQuery();

    boolean pwFind = false;
    String pw = "null";

    try {
        // 입력한 값과 일치하는 데이터 레코드가 있는지 체크
        if(result.next()) {
            pw = result.getString(3);
            pwFind = true;
        }
        else {
            pwFind = false;
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


<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script>
        var pwFind = "<%=pwFind%>";
        var pw = "<%=pw%>";

        if(pwFind === "true") {
            alert("회원님의 비밀번호는" + pw + "입니다.");
            location.href = "../index.jsp";
        }
        else {
            alert("일치하는 계정정보가 존재하지 않습니다.")
            location.href = "../page/findPw.jsp";
        }
    </script>
</body>