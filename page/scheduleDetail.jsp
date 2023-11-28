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
    
    //클릭된 날짜 정보 받아오기
    String date = request.getParameter("date"); 

    //세션값 받아줌
    int accountIdxValue = (Integer)session.getAttribute("accountIdx");

    Connection connect = null;
    PreparedStatement query = null;
    ResultSet result = null;

    ArrayList<Integer> scheduleIdxList = new ArrayList<Integer>();
    ArrayList<String> scheduleTimeList = new ArrayList<String>();
    ArrayList<String> scheduleTitleList = new ArrayList<String>();

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

        String sql = "SELECT * FROM schedule WHERE account_idx = ? AND date = ?";
        query = connect.prepareStatement(sql);
        query.setInt(1,accountIdxValue);
        query.setString(2,date);
        
        //return값을 저장해줌
        result = query.executeQuery();

        while (result.next()) {
            int scheduleIdx = result.getInt(1);
            String scheduleTime = result.getString(3);
            String scheduleTitle = result.getString(4);

            scheduleIdxList.add(scheduleIdx);
            scheduleTimeList.add("\""+scheduleTime+"\"");
            scheduleTitleList.add("\""+scheduleTitle+"\"");
        }
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


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상세일정</title>
    <link rel="stylesheet" type="text/css" href="../css/scheduleDetail.css">
    <link rel="stylesheet" type="text/css" href="../css/common.css">
</head>
<body>
    <!-- 해당날짜를 출력 -->
    <header id="daySection"></header>

    <!-- 해당날짜의 일정 리스트 출력 -->
    <main id="schduleSection">
    </main>

    <!-- 일정 입력창 -->
    <form action = "../action/inputScheduleAction.jsp" onsubmit = "return nullCheckEvent()">
        <div id="scheduleInput">
            <input type="hidden" name="date" id="dateInput">
            <input type="time" name="time" id="timeInput">
            <input type="text" name="title" id="titleInput">
            <input type="submit" id="scheduleInputButton">
        </div>
    </form>
    <script>
        var date = "<%=date%>";
        var scheduleIdxList = <%=scheduleIdxList%>;
        var scheduleTimeList = <%=scheduleTimeList%>;
        var scheduleTitleList = <%=scheduleTitleList%>;

        var daySection = document.getElementById("daySection");
        daySection.innerHTML = date;
        
        var dateInput = document.getElementById("dateInput");
        dateInput.value = date;

        var scheduleSection = document.getElementById("schduleSection");

        if (scheduleIdxList.length > 0) {
            for(var i=0; i<scheduleIdxList.length; i++){
                var scheduleRow = document.createElement("div");
                var scheduleTime = document.createElement("span");
                var scheduleTitle = document.createElement("span");
                var buttonSection = document.createElement("span");
                var editButton = document.createElement("img");
                var deleteButton = document.createElement("img");
                
                scheduleRow.className = "scheduleRow";
                scheduleTime.className = "scheduleTime";
                scheduleTime.innerHTML = scheduleTimeList[i];
                scheduleTitle.className = "scheduleTitle";
                scheduleTitle.innerHTML = scheduleTitleList[i];

                buttonSection.className = "buttonSection";

                editButton.className = "editButton";
                editButton.src = "../image/pencil.svg";
                editButton.addEventListener('click', scheduleEditEvent);

                deleteButton.className = "deleteButton";
                deleteButton.src = "../image/trashcan.svg";

                deleteButton.addEventListener("click", function(index) {
                    return function() {
                        var scheduleIdx = scheduleIdxList[index];
                        var confirmation = confirm("일정을 삭제하시겠습니까?");
                    
                        if (confirmation) {
                            location.href = "../action/deleteScheduleAction.jsp?date=" + date + "&scheduleIdx=" + scheduleIdx;
                        } else {
                            
                        }
                    };
                }(i));

                buttonSection.appendChild(editButton);
                buttonSection.appendChild(deleteButton);

                scheduleRow.appendChild(scheduleTime);
                scheduleRow.appendChild(scheduleTitle);
                scheduleRow.appendChild(buttonSection);

                scheduleSection.appendChild(scheduleRow);
            }
        }
        function scheduleEditEvent() {

        }
        function scheduleDeleteEvent() {

        }

        function nullCheckEvent() {
            var timeInput = document.getElementById("timeInput").value;
            var titleInput = document.getElementById("titleInput").value;
            var dateInput = document.getElementById("dateInput");
            if (timeValue.trim() == "") {
                alert("일정시간을 입력해주세요.");
                return false;
            } 
            else if (titleInput.trim() == "") {
                alert("일정내용을 입력해주세요.");
                return false;
            }
        }

        // JavaScript를 사용하여 내용이 비어 있을 때 기본 텍스트를 추가
        if (schduleSection.innerHTML.trim() == '') {
            schduleSection.innerText = "일정을 추가해주세요.";
            console.log("ok")
        }
    </script>
</body>
</html>