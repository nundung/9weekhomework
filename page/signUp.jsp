<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>


<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="../css/signUp.css">
    <link rel="stylesheet" type="text/css" href="../css/common.css">
</head>
<body>
    <header>
        회원가입
    </header>
    <main>
        <form action="../action/signUpAction.jsp" onsubmit="return exceptionCheckEvent()">
            <section id="idRow">
                <label for="id" id="idLabel">아이디</label>
                <input type="text" id="idInput" name="id" placeholder="영문, 숫자 조합으로 6~18자" onchange="resetDuplicateCheckEvent()">
                <input type="button" id="duplicateCheckButton" onclick="duplicateCheckEvent()" value="아이디 중복체크">
            </section>
            <section class="rows">
                <label for="pw" class ="label">비밀번호</label>
                <input type="password" class="input" id="pw" name="pw" placeholder="영문, 숫자,특수문자 조합으로 8~20자">
            </section>
            <section class="rows">
                <label for="pwCheck" class ="label">비밀번호 확인</label>
                <input type="password" class="input" id="pwCheck">
            </section>
            <section class="rows">
                <label for="name" class ="label">이름</label>
                <input type="text" class="input" id="name" name="name">
            </section>
            <section class="rows">
                <label for="phonenumber" class ="label">전화번호</label>
                <input type="text" class="input" id="phonenumber" name="phonenumber" oninput="phonenumberAutoHyphenEvent()">
            </section>
            <section class="rows">
                <label for="team" class ="label">부서</label>
                <div class="radioInput">
                    <input type="radio" name="team" value="1">개발
                    <input type="radio" name="team" value="2">디자인
                </div>
            </section>
            <section class="rows">
                <label for="position" class ="label">직급</label>
                <div class="radioInput">
                    <input type="radio" name="position" value="1">팀원
                    <input type="radio" name="position" value="2">팀장
                </div>
            </section>
            <input type="submit" id="button" value="회원가입">
        </form>
    </main>
    <script>
        var checkedId = false;

        //아이디 중복체크 이벤트
        function duplicateCheckEvent() {
            var id = document.getElementById("idInput").value;
            //아이디 유효성 체크
            if(id.trim() == "") {
                alert("아이디값을 입력해주세요.");
                return false;
            }
            //아이디 정규식
            var idReg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,18}$/;
            //id 문자열이 idReg로 정의된 정규 표현식과 일치하는지 체크
            if(!idReg.test(id)) {
                alert("아이디는 영문, 숫자의 조합으로 6~18자로 입력해주세요.");
                return false;
            }

            //아이디 중복체크 팝업 오픈
            let options = "toolbar=no, scrollbars=no, resizable=yes, status=no, menubar=no, width=600, height=400";
            var pop = window.open("../action/checkIdAction.jsp?id="+ id, "아이디 중복체크", options);

            //팝업창이 닫힐 때
            pop.onunload = function () {
                if (checkedId === true) {
                    var idInput = document.getElementById("idInput");
                    var duplicateCheckButton = document.getElementById("duplicateCheckButton");
                
                    //버튼을 비활성화
                    duplicateCheckButton.disabled = true;

                    //버튼색 변경
                    duplicateCheckButton.style.backgroundColor = "gray";
                }
            }
        }
        
        //아이디 입력 값 변경 시 중복 체크 상태 초기화
        function resetDuplicateCheckEvent() {
            checkedId = false;
            var duplicateCheckButton = document.getElementById("duplicateCheckButton");
            duplicateCheckButton.disabled = false;
            duplicateCheckButton.style.backgroundColor = ""; // 버튼 색상 초기화
        }
        
        //자동 하이픈 추가 이벤트
        var phonenumberAutoHyphenEvent =() => {
            var target = event.target || window.event.srcElement;
            target.value = target.value
            .replace(/[^0-9]/g, '')
            .replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3").replace(/(\-{1,2})$/g, "");
        }

        //예외 체크 이벤트
        function exceptionCheckEvent() {
            if (checkedId === false) {
                alert("아이디 중복체크를 먼저 진행해주세요.");
                return false;
            }
            var input = document.getElementsByClassName("input")
            for(var i=0; i < input.length; i++) {
                if (input[i].value === "") {
                    alert("모든값을 입력해주세요.");
                    return false;
                }
            }
            //아이디 정규식
            var id = document.getElementById("idInput").value;
            var idReg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,18}$/;
            if(!idReg.test(id)) {
                alert("아이디는 영문, 숫자의 조합으로 6~18자로 입력해주세요.");
                return false;
            } 
            //비밀번호 정규식
            var pwReg = /^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,20}$/;
            var pw = document.getElementById("pw").value;
            if(!pwReg.test(pw)) {
                alert("비밀번호는 영문, 숫자, 특수문자의 조합으로 8~20자로 입력해주세요.");
                return false;
            }
            //비밀번호 확인값 검사
            var pwCheck = document.getElementById("pwCheck").value;
            if(pw !== pwCheck) {
                alert("비밀번호 확인값이 일치하지 않습니다.");
                return false;
            }
            //이름 정규식
            var nameReg = /^[가-힣]{2,4}$/;
            var name = document.getElementById("name").value;
            if(!nameReg.test(name)) {
                alert("이름은 한글 2~4자로 입력해주세요.")
                return false;
            }
            //전화번호 정규식
            var phonenumberReg = /^01([0|1|6|7|8|9])-?([0-9]{4})-?([0-9]{4})$/;
            var phonenumber = document.getElementById("phonenumber").value;
            if(!phonenumberReg.test(phonenumber)) {
                alert("유효한 전화번호 값을 입력해주세요.")
                return false;
            }
            //라디오 버튼 선택값 체크
            var teamRadio = document.getElementsByName("team");
            var positionRadio = document.getElementsByName("position");
            var radioList = [teamRadio, positionRadio];
            
            for (var j = 0; j < radioList.length; j++) {
                var isChecked = false;
                for(var k = 0; k < radioList[j].length; k++)
                if (radioList[j][k].checked) {
                    isChecked = true;
                    break;
                }
            }
            if (!isChecked) {
                alert("부서와 직급을 선택해주세요.");
                return false;
            }
        }
    </script>
</body>