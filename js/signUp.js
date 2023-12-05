
        //예외처리
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