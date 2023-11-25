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

<!-- 정규 표현식의 패턴을 컴파일하고 저장 -->
<%@ page import="java.util.regex.Pattern" %>

<!-- 아이디 정규식 일치 확인-->
<%@ page import="java.util.regex.Matcher" %>

<% 
    //전페이지에서 온 데이터에 대해서 인코딩 설정
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id"); 

    //id값이 null값일 경우 기본값 설정
    if(id == null || id.isEmpty()) {
        out.println("<div>아이디값을 입력해주세요.</div>");
    }
    else {
        //정규식 검사
        String idReg = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,18}$";
        Pattern pattern = Pattern.compile(idReg);
        Matcher matcher = pattern.matcher(id);

        if (!matcher.matches()) {
            out.println("<div>잘못된 형식의 아이디입니다.</div>");
        } 
        else {
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

                if (result.next()) {
                    id = "0";
                    out.println("<script>window.opener.checkedId = false;</script>");
                    out.println("<div>이미 존재하는 아이디입니다.</div>");
                }
                else {
                    out.println("<script>window.opener.checkedId = true;</script>");
                    out.println("<div>사용가능한 아이디입니다.</div>");
                    
                } 
            }
            catch (Exception e) {
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
                if (result != null) {
                    result.close();
                } 
            } 
            catch (SQLException e) {
                out.println("<div>예상치 못한 오류가 발생했습니다.</div>");
            }
        }
    }
}
%>


<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디 중복체크</title>
</head>
<body>
    <div id="messageArea">

    </div>
    <script>
        var id = "<%= id %>";
        if (id == 0) {
            alert("사용불가한 아이디입니다.");
            window.opener.checkedId = false; 
        } else {
            alert("사용가능한 아이디입니다.");
            window.opener.checkedId = true;
        }
        window.close(); // 팝업 창 닫기
    </script>
</body>
</html>