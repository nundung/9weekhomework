<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디 찾기</title>
    <link rel="stylesheet" type="text/css" href="../css/index.css">
</head>
<body id="body">
    <div id="title">
        아이디 찾기
    </div>
    <form action="../action/findIdAction.jsp" onsubmit="return exceptionCheckEvent()">
        <input type="text" class="input" id="name" name="name" placeholder="이름">
        <input type="text" class="input" id="phonenumber" name="phonenumber" placeholder="전화번호" oninput="phonenumberAutoHyphen()">
        <input type="submit" id="Button" value="아이디 찾기"></button>
    </form>
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