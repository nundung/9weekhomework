
        //헤더 중앙부에 오늘 날짜 입력
        var todaySection = document.getElementById("todaySection");
        var today = thisYear + '.' + thisMonth + '.' + thisDay;
        todaySection.innerHTML = today;

        if(memberPage == "true") {
            var memberNameSection = document.getElementById("memberNameSection");
            memberNameSection.innerHTML = "팀원 " + pageMemberName;
        }

        //홈 버튼 클릭시 이번달 달력 표시
        function reloadEvent() {
            location.href = "schedule.jsp?id=" + id + "&year=" + thisYear + "&month=" + thisMonth + "&day=" + thisDay;
        }

        //올해 년도 입력
        var yearValue = document.getElementById("yearValue");
        yearValue.innerHTML = year;

        //년도 선택 이벤트
        function lastYearEvent() {
            year = parseInt(year) - 1;
            location.href = "schedule.jsp?id=" + pageId + "&year=" + year + "&month=" + month + "&day=" + day;
        }
        function nextYearEvent() {
            year = parseInt(year) + 1;
            location.href = "schedule.jsp?id=" + pageId + "&year=" + year + "&month=" + month + "&day=" + day;
        }
        
        //월 선택 버튼 입력
        for (var i=0; i<12; i++) {
            var monthSelectSection = document.getElementById("monthSelectSection");
            var monthSelectButton = document.createElement("p")
            monthSelectButton.innerHTML = i+1;
            monthSelectButton.className = "monthSelectButton";
            monthSelectButton.addEventListener('click', monthSelectEvent);
            monthSelectSection.appendChild(monthSelectButton);
        }
        
        //월 버튼 클릭 이벤트
        function monthSelectEvent(event) {
            var clickedMonth = event.target.innerHTML;
            location.href = "schedule.jsp?id=" + pageId + "&year=" + year + "&month=" + clickedMonth + "&day=" + day;
        }

        //메뉴바 토글 이벤트
        function toggleMenuEvent(event) {
            var menuBar = document.getElementById("menuBar");
            if (getComputedStyle(menuBar).right === "-240px") {
                menuBar.style.right = "0px";
            } 
            else{
                menuBar.style.right = "-240px";
            }
        }


        //로그아웃 이벤트
        function logOutEvent() {
            location.href = "../action/logOutAction.jsp"
        }

        //정보수정 이벤트
        function editInfoEvent() {
            location.href="editInfo.jsp";
        }