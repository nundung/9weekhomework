
        //헤더 중앙부에 오늘 날짜 입력
        var todaySection = document.getElementById("todaySection");
        var today = thisYear + '.' + thisMonth + '.' + thisDay;
        todaySection.innerHTML = today;

        //메뉴창의 버튼 속성
        var editInfoButton = document.getElementById("editInfoButton");
        var comeBackButton = document.getElementById("comeBackButton");
        
        if(memberPageCheck === "true") {
            var memberNameSection = document.getElementById("memberNameSection");
            memberNameSection.innerHTML = "팀원 " + pageMemberName;

            editInfoButton.style.display = "none"; // 정보수정 버튼 숨기기
            comeBackButton.style.display = "block"; // 돌아가기 버튼 보이기
        }
        else {
            editInfoButton.style.display = "block"; // 정보수정 버튼 보이기
            comeBackButton.style.display = "none"; // 돌아가기 버튼 숨기기
        }

        //홈 버튼 클릭시 이번달 달력 표시
        function reloadEvent() {
            location.href = "schedule.jsp?id=" + id + "&year=" + thisYear + "&month=" + thisMonth + "&day=" + thisDay;
        }

        //올해 년도 입력
        var yearValue = document.getElementById("yearValue");
        yearValue.innerHTML = year;

        //년도 선택 
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
            var monthSelectButton = document.createElement("span");
            monthSelectButton.innerHTML = i+1;
            monthSelectButton.className = "monthSelectButton";
            if(i+1 == month) {
                monthSelectButton.id = "thisMonthButton";
            }
            monthSelectButton.addEventListener('click', monthSelectEvent);
            monthSelectSection.appendChild(monthSelectButton);
        }
        
        //월 버튼 클릭 이벤트
        function monthSelectEvent(event) {
            var clickedMonth = event.target.innerHTML;
            location.href = "schedule.jsp?id=" + pageId + "&year=" + year + "&month=" + clickedMonth + "&day=" + day;
        }

        //메뉴바에 내 정보 불러오기
        var nameSection = document.getElementById("name");
        var phonenumberSection = document.getElementById("phonenumber");
        var teamSection = document.getElementById("team");
        var positionSection = document.getElementById("position");

        nameSection.innerHTML = nameValue;
        phonenumberSection.innerHTML = phonenumberValue;
        teamSection.innerHTML = teamValue + "부";
        positionSection.innerHTML = positionValue;

        
        //내 직급이 팀장일 경우 팀원목록 불러오기
        if(leaderCheck === "true") {
            var memberList = document.getElementById("memberList");
            for(var i=0; i<memberNameList.length; i++){
                var memberRow = document.createElement("div");
                memberRow.className = "memberRow";
                memberRow.dataset.index = i;
                memberRow.addEventListener('click', showTemMemberScheduleEvent);

                var memberName = document.createElement("p");
                memberName.innerHTML = memberNameList[i];
                
                var memberPhonenumber = document.createElement("p");
                memberPhonenumber.innerHTML = memberPhonenumberList[i];

                memberRow.appendChild(memberName);
                memberRow.appendChild(memberPhonenumber);
                memberList.appendChild(memberRow);
            }
        }

        //팀원페이지로 이동
        function showTemMemberScheduleEvent(event) {
            var clickedIndex = event.target.dataset.index;
            var memberId = memberIdList[clickedIndex];
            location.href = "schedule.jsp?id=" + memberId + "&year=" + year + "&month=" + month + "&day=" + day;
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


        //로그아웃
        function logOutEvent() {
            location.href = "../action/logOutAction.jsp"
        }

        //정보수정 
        function editInfoEvent() {
            location.href="editInfo.jsp";
        }
        
        //원래 내 페이지로 돌아가기
        function comeBackEvent() {
            location.href = "schedule.jsp?id=" + id + "&year=" + year + "&month=" + month + "&day=" + day;
        }

        //달력 
        function makeCalendar() {
            var calendar = document.getElementById("calendar");
            var calendarHeader = document.getElementById("calendarHeader");
            calendarHeader.innerHTML = month + '월';
            calendar.appendChild(calendarHeader);
            var daysInMonth = new Date(year, month, 0).getDate();
            for (var i = 0; i < daysInMonth; i++) {
                var daySelectButton = document.createElement("div");
                daySelectButton.innerHTML = i + 1;
                daySelectButton.id = "day" + (i + 1);
                daySelectButton.className = "daySelectButton";
                
                if (year == thisYear && month == thisMonth && (i + 1) === thisDay) {
                    daySelectButton.className = "todayButton";
                }
                daySelectButton.addEventListener('click', showDetailEvent);
                calendar.appendChild(daySelectButton);
            }
        }

        //일자별로 일정 개수 표시해주기
        function makeSchedulesInDay(day) {
            var dayButton = document.getElementById("day" + day);
            // 일자에 원래 있던 일정 개수에 하나를 더해준다.
            var existingSchedules = dayButton.getElementsByClassName("schedulesInDay").length;
            var newScheduleCount = existingSchedules + 1;

            var schedulesInDay = document.createElement("div");
            schedulesInDay.innerHTML = "일정" + newScheduleCount +"개";
            schedulesInDay.className = "schedulesInDay";
            schedulesInDay.style.pointerEvents = "none";
            dayButton.appendChild(schedulesInDay);
        }

        //상세일정 팝업 오픈
        function showDetailEvent(event) {
            var clickedDay = parseInt(event.target.innerHTML, 10);
            var clickedDate = year+"-"+month+"-"+clickedDay;
            let options = "toolbar=no, scrollbars=no, resizable=yes, status=no, menubar=no, width=600, height=400, top=200, left=500";
            var ret = window.open("scheduleDetail.jsp?id=" + pageId + "&date=" + clickedDate, "상세일정", options)
        }