<%@ page contentType="text/html;charset=utf-8" 
	import="com.oreilly.servlet.*, com.oreilly.servlet.multipart.*"
	import="java.sql.*, java.io.*" 
%>

<%
//동영상 수정 페이지의 기본값을 출력하기 위해 쿼리문을 작성하여 실행한다.
request.setCharacterEncoding("utf-8");
int idx = Integer.parseInt(request.getParameter("idx"));

Class.forName("org.mariadb.jdbc.Driver");
String url = "jdbc:mariadb://localhost:3306/movieboard?useSSL=false";

Connection con = DriverManager.getConnection(url, "admin", "1234");
String sql = "Select * from video where idx=?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setInt(1, idx);
ResultSet rs = pstmt.executeQuery();
rs.next();
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>동영상 수정</title>
	</head>
	<body>
		<!-- check() 함수를 실행한 뒤, true가 return되면 modify_do.jsp?idx=# 로 이동한다. -->
		<form action = "modify_do.jsp?idx=<%=idx %>" method = "post" enctype = "multipart/form-data" onSubmit = "return check()">
			<h1>동영상 정보 수정</h1>
			동영상 제목<br>
			<input type = "text" name = "video_name" value = "<%=rs.getString("name") %>"><br>
			동영상 설명<br>
			<!-- 동영상 설명 작성은 textarea에서 하여 좀 더 작성이 편하도록 한다. -->
			<textarea rows = "5" cols = "30" name = "video_description"><%=rs.getString("description")%></textarea><br>
			업로더<br>
			<input type = "text" name = "uploader" value = "<%=rs.getString("uploader") %>"><br>
			카테고리<br>
			<input type = "radio" name = "video_category" value = "영화" checked>영화<br>
			<input type = "radio" name = "video_category" value = "게임">게임<br>
			<input type = "radio" name = "video_category" value = "학습">학습<br>
			<input type = "radio" name = "video_category" value = "스포츠">스포츠<br><br>
			썸네일<br>
			현재 파일명: <%=rs.getString("fileName1") %><br>
			<input type = "file" name = "fileName"><br><br>
			동영상<br>
			현재 파일명: <%=rs.getString("fileName2") %><br>
			<input type = "file" name = "fileName2"><br><br>
			
			<!-- 정말로 수정할 건지 묻는 함수를 선언한다. -->
			<script type = "text/javascript">
				function check() {
					if (confirm("정말로 수정하시겠습니까?") == true) {
						document.form.submit();
						return true;
					}
					else {
						return false;
					}
				}
			</script>
			<input type = "submit" value = "동영상 수정">
		</form>
	</body>
</html>