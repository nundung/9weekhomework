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

<%@ page import="java.util.regex.Pattern" %>

<%@ page import="java.util.regex.Matcher" %>

<%
	//전페이지에서 온 데이터에 대해서 인코딩 설정
	request.setCharacterEncoding("UTF-8");
    
	//값을 받아서 변수에 저장해 준다.
	//변수의 자료형을 String으로 지정
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String name = request.getParameter("name");
	String phonenumber = request.getParameter("phonenumber");
	String team = request.getParameter("team");
	String position = request.getParameter("position");

    if (id == null || pw == null || name == null || phonenumber == null || team == null || position == null) {
        out.println("<div>입력값이 부족합니다.</div>");
        return;
    }
    else {

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

        if (!pwMatcher.matches() || !nameMatcher.matches() || !phonenumberMatcher.matches()) {
            out.println("<div>유효하지 않은 값입니다.</div>");
        }

    }
	//데이터베이스 연결 코드
		// Connector 파일 찾는 부분
		Class.forName("com.mysql.jdbc.Driver");
		//데이터베이스 연결
		Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

	//SQL(쿼리문) 만들기
	//SQL문은 다른 프로그래밍 언어 기준에는 단순히 문자열임 따라서 String을 사용
	//미리 만들어놓은 test테이블에 입력받은 값을 넣도록 한다.
	String sql = "INSERT INTO account (id, pw, name, phonenumber, team, position) VALUES (?, ?, ?, ?, ?, ?)";
	PreparedStatement query = connect.prepareStatement(sql);
	query.setString(1, id);
	query.setString(2, pw);
	query.setString(3, name);
	query.setString(4, phonenumber);
	query.setString(5, team);
	query.setString(6, position);
    
        boolean signUpSuccess = false;
    
    try {
        //SQL 전송
        query.executeUpdate();
        signUpSuccess = true;
    }

    catch(SQLException e) {
        signUpSuccess = false;
        out.println("<div>예상치 못한 오류가 발생했습니다.</div>");
    }
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script>
        var signUpSuccess = "<%=signUpSuccess%>";
        if (signUpSuccess === "true") {
            alert("회원가입이 완료되었습니다.")
            location.href="../index.jsp"
        }
    </script>

</body>