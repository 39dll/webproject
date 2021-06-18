<%@ page contentType="text/html;charset=utf-8" 
	import="com.oreilly.servlet.*, com.oreilly.servlet.multipart.*"
	import="java.sql.*, java.io.*" 
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>동영상 업로드</title>
	</head>
	<body>
		<!-- 동영상 업로드를 위해 form 태그를 작성해준다. -->
		<!-- submit을 하면 upload_do.jsp로 해당 정보들이 전달된다. -->
		<form action = "upload_do.jsp" method = "post" enctype = "multipart/form-data">
			<h1>동영상 업로드</h1>
			동영상 제목<br>
			<input type = "text" name = "video_name" value = ""><br>
			동영상 설명<br>
			<!-- 동영상 설명 작성은 textarea에서 하여 좀 더 작성이 편하도록 한다. -->
			<textarea rows = "5" cols = "30" name = "video_description"></textarea><br>
			업로더<br>
			<input type = "text" name = "uploader" value = ""><br>
			카테고리<br>
			<input type = "radio" name = "video_category" value = "영화" checked>영화<br>
			<input type = "radio" name = "video_category" value = "게임">게임<br>
			<input type = "radio" name = "video_category" value = "학습">학습<br>
			<input type = "radio" name = "video_category" value = "스포츠">스포츠<br><br>
			썸네일<br>
			<input type = "file" name = "fileName"><br>
			동영상<br>
			<input type = "file" name = "fileName2"><br><br>
			<input type = "submit" value = "동영상 등록">
		</form>
	</body>
</html>