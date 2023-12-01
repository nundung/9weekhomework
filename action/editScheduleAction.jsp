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
    
    //오늘 날짜 정보 받아오기
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

        String sql = "UPDATE scadule SET pw='****' WHERE id='test2';";
        query = connect.prepareStatement(sql);

        if(id.equals(pageId)) {
            scheduleQuery.setInt(1,accountIdx);
        }
        else {
            String pageIdSql = "SELECT * FROM account WHERE id = ?";
            pageIdQuery = connect.prepareStatement(pageIdSql);
            pageIdQuery.setString(1,pageId);

            //return값을 저장해줌
            pageIdResult = pageIdQuery.executeQuery();

            while(pageIdResult.next()) {
                pageMemberIdx = pageIdResult.getInt(1);
                pageMemberName = pageIdResult.getString(4);
            }
            scheduleQuery.setInt(1,pageMemberIdx);
            memberPage = "true";
        }
        scheduleQuery.setString(2,year);
        scheduleQuery.setString(3,month);

        //return값을 저장해줌
        scheduleResult = scheduleQuery.executeQuery();

        int scheduleIdx = 0;
        String scheduleDate = "null";


        while(scheduleResult.next()) {
            scheduleIdx = scheduleResult.getInt(1);
            scheduleDate = scheduleResult.getString(2);
            
            scheduleIdxList.add(scheduleIdx);
            scheduleDateList.add("\""+scheduleDate+"\"");
        }

        if(position.equals("팀장")){
            String memberSql = "SELECT * FROM account WHERE team = ? AND position = '팀원'";
            memberQuery = connect.prepareStatement(memberSql);
            memberQuery.setString(1,team);
    
            //return값을 저장해줌
            memberResult = memberQuery.executeQuery();
    
            while(memberResult.next()) {
                String memberId = memberResult.getString(2);
                String memberName = memberResult.getString(4);
                String memberPhonenumber = memberResult.getString(5);
    
                memberIdList.add("\""+memberId+"\"");
                memberNameList.add("\""+memberName+"\"");
                memberPhonenumberList.add("\""+memberPhonenumber+"\"");
            }
        }
    }
    catch (SQLException e) {
        out.println("<div>예상치 못한 오류가 발생했습니다.</div>");
        return;
    }

%>