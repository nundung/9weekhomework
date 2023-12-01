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
    
    //이 페이지의 일정들 불러오기
    PreparedStatement scheduleQuery = null;
    ResultSet scheduleResult = null;
    
    PreparedStatement pageIdQuery = null;
    ResultSet pageIdResult = null;

    ArrayList<Integer> scheduleIdxList = new ArrayList<Integer>();
    ArrayList<String> scheduleTimeList = new ArrayList<String>();
    ArrayList<String> scheduleTitleList = new ArrayList<String>();

    int pageMemberIdx = 0;
    String pageMemberName = "null";
    String memberPageCheck = "false";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        connect = DriverManager.getConnection("jdbc:mysql://localhost/9weekhomework","stageus","1234");

        //이 페이지날짜의 일정 불러오기
        String scheduleSql = "SELECT * FROM schedule WHERE account_idx = ? AND date = ?";
        scheduleQuery = connect.prepareStatement(scheduleSql);
        
        //내가 이 페이지의 주인일때 세션에서 받은 accountIdx 쿼리문에 입력
        if(id.equals(pageId)) {
            scheduleQuery.setInt(1,accountIdx);
        }

        //팀원의 페이지라면 팀원의 accountIdx 찾아서 쿼리문에 입력
        else {
            String pageIdSql = "SELECT * FROM account WHERE id = ?";
            pageIdQuery = connect.prepareStatement(pageIdSql);
            pageIdQuery.setString(1,pageId);
            
            pageIdResult = pageIdQuery.executeQuery();

            while(pageIdResult.next()) {
                pageMemberIdx = pageIdResult.getInt(1);
                pageMemberName = pageIdResult.getString(4);
            }
            scheduleQuery.setInt(1,pageMemberIdx);
            memberPageCheck = "true";
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
    <!-- 이 페이지의 날짜 출력 -->
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
        var id = "<%=id%>";
        var pageMemberName = "<%=pageMemberName%>";
        var memberPageCheck = "<%=memberPageCheck%>";
        
        var scheduleIdxList = <%=scheduleIdxList%>;
        var scheduleTimeList = <%=scheduleTimeList%>;
        var scheduleTitleList = <%=scheduleTitleList%>;


        //이 페이지의 날짜를 표시하는 영역
        var daySection = document.getElementById("daySection");
        daySection.innerHTML = date;
        
        //이 날짜의 일정들을 표시하는 영역
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

                //내가 이 페이지의 주인일 경우 수정, 삭제 버튼 추가
                if(memberPageCheck === "false") {
                    var editButton = document.createElement("img");
                    var deleteButton = document.createElement("img");
                    makeEditButton();
                    makeDeleteButton();
                    }
                    buttonSection.appendChild(editButton);
                    buttonSection.appendChild(deleteButton);
                }
                scheduleRow.appendChild(scheduleTime);
                scheduleRow.appendChild(scheduleTitle);
                scheduleRow.appendChild(buttonSection);
                scheduleSection.appendChild(scheduleRow);
            }
        else {
            if(memberPageCheck === "false") {
            schduleSection.innerText = "일정을 추가해주세요.";
            console.log("ok")
        }
    }
        //내가 이 페이지의 주인이 아닌 경우 input창 안보이게
        if(memberPageCheck === "true") {
            var scheduleInput = document.getElementById("scheduleInput");
            scheduleInput.style.display = "none";
        }
        //수정버튼 생성
        function makeEditButton() {
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
                    
                    // 시간과 내용 수정칸을 input type으로 생성
                    var scheduleTimeEdit = document.createElement("input");
                    scheduleTimeEdit.type = "time";
                    scheduleTimeEdit.value = currentScheduleTime;
            
                    var scheduleTitleEdit = document.createElement("input");
                    scheduleTitleEdit.type = "text";
                    scheduleTitleEdit.value = currentScheduleTitle;

                    // 수정버튼 클릭시 기존의 span 요소를 input 요소로 교체
                    scheduleTime.replaceWith(scheduleTimeEdit);
                    scheduleTitle.replaceWith(scheduleTitleEdit);

                    //버튼 구역의 수정, 삭제 버튼을 없애고 저장버튼 생성
                    buttonSection.innerHTML = "";
                    var saveButton = document.createElement("button");
                    saveButton.innerHTML = "저장";
                    saveButton.addEventListener('click', function() {
                        location.href = "../action/editScheduleAction.jsp?id=" + id + "&date=" + date + "&scheduleIdx=" + scheduleIdx + "&scheduleTime=" + scheduleTimeEdit.value + "&scheduleTitle=" + scheduleTitleEdit.value;
                    });
                buttonSection.appendChild(saveButton);
                };
            }(i));
        }
        //삭제버튼 생성
        function makeDeleteButton() {
            deleteButton.className = "deleteButton";
            deleteButton.src = "../image/trashcan.svg";
            deleteButton.addEventListener('click', function(index) {
                return function() {
                    var scheduleIdx = scheduleIdxList[index];
                    var confirmation = confirm("일정을 삭제하시겠습니까?");
                    if (confirmation) {
                        location.href = "../action/deleteScheduleAction.jsp?id=" + id + "&date=" + date + "&scheduleIdx=" + scheduleIdx;
                    } else {
                        
                    }
                };
            }(i));
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

    </script>
</body>
</html>