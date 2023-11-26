<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" type="text/css" href="../css/signUp.css">
    <link rel="stylesheet" type="text/css" href="../css/common.css">
</head>
<body>
    <header>
        비밀번호 찾기
    </header>
    <main>
        <form action="../action/findPwAction.jsp" onsubmit="return exceptionCheckEvent()">
            <section class="rows">
                <label for="name" class ="label">이름</label>
                <input type="text" class="input" id="name" name="name">
            </section>
            <section class="rows">
                <label for="id" class ="label">아이디</label>
                <input type="text" class="input" id="id" name="id">
            </section>
            <section class="rows">
                <label for="phonenumber" class ="label">전화번호</label>
                <input type="text" class="input" id="phonenumber" name="phonenumber" oninput="phonenumberAutoHyphen()">
            </section>
            <input type="submit" id="button" value="비밀번호 찾기"></button>
        </form>
    </main>
    
    <script>
        // 자동 하이픈 추가
        var phonenumberAutoHyphen =() => {
            var target = event.target || window.event.srcElement;
            target.value = target.value
            .replace(/[^0-9]/g, '')
            .replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3").replace(/(\-{1,2})$/g, "");
        }
        //예외처리
        function exceptionCheckEvent() {
            var input = document.getElementsByClassName("input");
            for(var i=0; i < input.length; i++) {
                if (input[i].value === "") {
                    alert("모든값을 입력해주세요.");
                    return false;
                }
            }
            //이름 정규식
            var nameReg = /^[가-힣]{2,4}$/;
            var name = document.getElementById("name").value;
            if(!nameReg.test(name)) {
                alert("이름은 한글 2~4자로 입력해주세요.")
                return false;
            }
            
            //아이디 정규식
            var idReg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,18}$/;
            var id = document.getElementById("id").value;
            if(!idReg.test(id)) {
                alert("아이디는 영문, 숫자의 조합으로 6~18자로 입력해주세요.");
                return false;
            }

            //전화번호 정규식
            var phonenumberReg = /^01([0|1|6|7|8|9])-?([0-9]{4})-?([0-9]{4})$/;
            var phonenumber = document.getElementById("phonenumber").value;
            if(!phonenumberReg.test(phonenumber)) {
                alert("유효한 전화번호 값을 입력해주세요.")
                return false;
            }
        }
    </script>
</body>