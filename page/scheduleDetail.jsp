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
    
    //id정보 받아오기
    String pageId = request.getParameter("id"); 

    //클릭된 날짜 정보 받아오기
    String date = request.getParameter("date");   

    //세션값 받아줌
    int accountIdx = (Integer)session.getAttribute("accountIdx");

    Object idSession = session.getAttribute("id");
    String id = (String)idSession;

    Connection connect = null;

    PreparedStatement scheduleQuery = null;
    ResultSet scheduleResult = null;
    
    PreparedStatement pageIdQuery = null;
    ResultSet pageIdResult = null;

    ArrayList<Integer> scheduleIdxList = new ArrayList<Integer>();
    ArrayList<String> scheduleTimeList = new ArrayList<String>();
    ArrayList<String> scheduleTitleList = new ArrayList<String>();

    int pageMemberIdx = 0;
    String pageMemberName = "null";
    String memberPage = "false";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

        String scheduleSql = "SELECT * FROM schedule WHERE account_idx = ? AND date = ?";
        scheduleQuery = connect.prepareStatement(scheduleSql);
        
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
        scheduleQuery.setString(2,date);
        
        //return값을 저장해줌
        scheduleResult = scheduleQuery.executeQuery();

        while (scheduleResult.next()) {
            int scheduleIdx = scheduleResult.getInt(1);
            String scheduleTime = scheduleResult.getString(3);
            String scheduleTitle = scheduleResult.getString(4);

            scheduleIdxList.add(scheduleIdx);
            scheduleTimeList.add("\""+scheduleTime+"\"");
            scheduleTitleList.add("\""+scheduleTitle+"\"");
        }
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
        console.log(date);

        var memberPage = "<%=memberPage%>";
        var scheduleIdxList = <%=scheduleIdxList%>;
        var scheduleTimeList = <%=scheduleTimeList%>;
        var scheduleTitleList = <%=scheduleTitleList%>;

        var daySection = document.getElementById("daySection");
        daySection.innerHTML = date;
        

        var scheduleSection = document.getElementById("schduleSection");
            if (scheduleIdxList.length > 0) {
                for(var i=0; i<scheduleIdxList.length; i++){
                    var scheduleRow = document.createElement("div");
                    var scheduleTime = document.createElement("span");
                    var scheduleTitle = document.createElement("span");
                    var buttonSection = document.createElement("span");
                    
                    scheduleRow.className = "scheduleRow";
                    scheduleTime.className = "scheduleTime";
                    scheduleTime.innerHTML = scheduleTimeList[i];
                    scheduleTitle.className = "scheduleTitle";
                    scheduleTitle.innerHTML = scheduleTitleList[i];
                    buttonSection.className = "buttonSection";

            if(memberPage === "false") {
                var editButton = document.createElement("img");
                var deleteButton = document.createElement("img");
                editButton.className = "editButton";
                editButton.src = "../image/pencil.svg";
                editButton.addEventListener('click', function(index) {
                return function() {
                    var scheduleIdx = scheduleIdxList[index];
                    var currentScheduleTime = scheduleTimeList[index];
                    var currentScheduleTitle = scheduleTitleList[index];
                    
                    var scheduleTime = document.getElementsByClassName("scheduleTime")[index];
                    var scheduleTitle = document.getElementsByClassName("scheduleTitle")[index];
                    var buttonSection = document.getElementsByClassName("buttonSection")[index];
                    
                    // 시간과 내용을 input 모드로 전환하는 로직 추가
                    var scheduleTimeEdit = document.createElement("input");
                    scheduleTimeEdit.type = "time";
                    scheduleTimeEdit.value = currentScheduleTime;
            
                    var scheduleTitleEdit = document.createElement("input");
                    scheduleTitleEdit.type = "text";
                    scheduleTitleEdit.value = currentScheduleTitle;

                    // 기존의 span 요소를 input 요소로 교체
                    scheduleTime.replaceWith(scheduleTimeEdit);
                    scheduleTitle.replaceWith(scheduleTitleEdit);

                    
                    buttonSection.innerHTML = "";
                    var saveButton = document.createElement("button");
                    saveButton.innerHTML = "저장";
                    saveButton.addEventListener('click', function() {
                        return function() {}
                        editScheduleEvent(scheduleIdx, scheduleTimeEdit.value, scheduleTitleEdit.value);
                        locaion.href = "../action/editScheduleAction.jsp?date=" + date + "&scheduleIdx=" + scheduleIdx + "&scheduleTime=" + scheduleTimeEdit.value + "&scheduleTitle" + scheduleTitleEdit.value;
                    });

                    buttonSection.appendChild(saveButton);
                };
            }(i));

                deleteButton.className = "deleteButton";
                deleteButton.src = "../image/trashcan.svg";

                deleteButton.addEventListener('click', function(index) {
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
            }
                scheduleRow.appendChild(scheduleTime);
                scheduleRow.appendChild(scheduleTitle);
                scheduleRow.appendChild(buttonSection);

                scheduleSection.appendChild(scheduleRow);
            }
    }
    else {
        if(memberPage === "false") {
        schduleSection.innerText = "일정을 추가해주세요.";
        console.log("ok")
    }
}

if(memberPage === "true") {
    var scheduleInput = document.getElementById("scheduleInput");

    scheduleInput.style.display = "none";
}
        
        function scheduleEditEvent() {

        }
        function scheduleDeleteEvent() {

        }

        function nullCheckEvent() {
            var timeInput = document.getElementById("timeInput").value;
            var titleInput = document.getElementById("titleInput").value;
            var dateInput = document.getElementById("dateInput");
            dateInput.value = date;
            if (timeInput.trim() == "") {
                alert("일정시간을 입력해주세요.");
                return false;
            } 
            else if (titleInput.trim() == "") {
                alert("일정내용을 입력해주세요.");
                return false;
            }
        }

        // JavaScript를 사용하여 내용이 비어 있을 때 기본 텍스트를 추가
        
    </script>
</body>
</html>