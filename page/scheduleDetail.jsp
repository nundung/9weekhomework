<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

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
    <header id="dayValue"></header>
    <main>
        <div id="scheduleList">
            <div id="scheduleRow">
                <span>시간</span>
                <span id="schedule">일정</span>
                <span id="buttonBox">
                    <img src="../image/pencil.svg" id="editButton">
                    <img src="../image/trashcan.svg" id="deleteButton">
                </span>
            </div>
        </div>
        <div id="scheduleList">
            <div id="scheduleRow">
                <span>시간</span>
                <span id="schedule">일정</span>
                <span id="buttonBox">
                    <img src="../image/pencil.svg" id="editButton">
                    <img src="../image/trashcan.svg" id="deleteButton">
                </span>
            </div>
        </div>
    </main>
    <form action = "../action/scheduleInputAction.jsp" onsubmit = "return nullCheckEvent()">
        <div id="scheduleInput">
            <input type="time" id="timeValue">
            <input type="text" id="scheduleValue">
            <input type="submit" id="scheduleInputButton">
        </div>
    </form>

    <script>
        function nullCheckEvent() {
            var timeValue = document.getElementById("timeValue").value;
            var scheduleValue = document.getElementById("scheduleValue").value;
            if (timeValue.trim() == "") {
                alert("일정시간을 입력해주세요.");
                return false;
            } 
            else if (scheduleValue.trim() == "") {
                alert("일정내용을 입력해주세요.");
                return false;
            }
        }

        // JavaScript를 사용하여 내용이 비어 있을 때 기본 텍스트를 추가
        var scheduleList = document.getElementById("scheduleList");
        if (scheduleList.innerHTML.trim() == '') {
            scheduleList.innerText = "일정을 추가해주세요.";
            console.log("ok")
        }
    </script>
</body>
</html>