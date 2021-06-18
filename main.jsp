<%@ page contentType="text/html;charset=utf-8" import="java.sql.*, java.text.SimpleDateFormat" %>

<%
//모든 동영상들의 정보를 얻어오기 위해 데이터베이스에 접근
Class.forName("org.mariadb.jdbc.Driver");
String DB_URL = "jdbc:mariadb://localhost:3306/movieboard?useSSL=false";
String DB_USER = "admin";
String DB_PASSWORD= "1234";

Connection con=null;
PreparedStatement pstmt = null;
ResultSet rs=null;
try {
	con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	String sql = "SELECT * FROM video";
	pstmt = con.prepareStatement(sql);
	rs = pstmt.executeQuery();
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>메인 페이지</title>
		<style>
	    #container{
	    	overflow : auto;
	     	margin : 10px 0px;
	    }
	    #nav{
	    	margin-right : 3%;
	     	width : 20%;
	    	float : left;
	    	height : 100%;
	    }
	    #content{
	    	position : relative;
	    	float : left;
	    	width : 75%;
	    	height : 100%;
	    }
	    #nav ul li{
	    	height: 100%;
	    	list-style-type: none;
	    }
	 	</style>
	</head>
	<body>
	  	<div id="container">
		    <div id="nav">
			    <a href = "main.jsp">
			    	<!-- 홈페이지 로고를 이미지 호스팅 사이트에서 불러옴 -->
					<img src = "https://i.imgur.com/pAHjkiR.png" width = "100%" height = "100%">
				</a>
				<!-- 검색 기능을 지원하기 위해 form을 사용 -->
				<form action = "search.jsp" method = "post">
					<input type = "text" name = "search_keyword" value = "">
					<input type = "submit" value = "검색">
				</form><p>
				<!-- 동영상 업로드 버튼 -->
				<form action = "upload.jsp" method = "post">
					<input type = "submit" value = "동영상 업로드">
				</form>
		    </div>
		    <div id="content">
<%
	//찾은 모든 튜플에 대해서 실행
	while(rs.next()) {
			//타임스탬프를 출력하기 위해 SimpleDateFormat 객체를 이용한다.
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
%>
			<!-- 동영상의 정보를 출력 -->
		    <h1><%=rs.getString("name") %></h1>
		    
		    <!-- 썸네일을 클릭하면 show.jsp?idx=# 로 이동한다. -->
		    <a href = "show.jsp?idx=<%=rs.getInt("idx") %>">
		    	<img src = "./upload/<%=rs.getString("fileName1") %>" width = "100%" height = "100%"><br>
		    </a>
		    <%=rs.getString("description") %><br><br>
		   	게시일자 : <%=(String)sdf.format(rs.getTimestamp("lastupdate")) %><br>
		   	업로더 : <%=rs.getString("uploader") %><br>
		   	카테고리 : <%=rs.getString("category") %><br><br>
		   	
		   	<!-- 동영상 수정 버튼을 누르면 modify.jsp?idx=# 로 이동한다. -->
		    <button type = "button" onclick = "location.href='modify.jsp?idx=<%=rs.getInt("idx") %>'">동영상 수정</button>
		    <!-- 동영상 삭제 버튼을 누르면 정말로 삭제할 것인지 물어본 뒤에 delete.jsp?idx=# 로 이동한다. -->
		    <button type = "button" onclick = "if (confirm('정말로 삭제하시겠습니까??'))location.href='delete.jsp?idx=<%=rs.getInt("idx") %>';">동영상 삭제</button>
		   	<hr>
<%
}
	rs.close();
	pstmt.close();
	con.close();
}catch(SQLException e) {
	out.println(e);
}
%>
		    </div>
		</div>
	</body>
</html>