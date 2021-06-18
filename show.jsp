<%@ page contentType="text/html;charset=utf-8" 
	import="com.oreilly.servlet.*, com.oreilly.servlet.multipart.*"
	import="java.sql.*, java.io.*, java.text.SimpleDateFormat" 
%>
<%
Class.forName("org.mariadb.jdbc.Driver");
String DB_URL = "jdbc:mariadb://localhost:3306/movieboard?useSSL=false";
String DB_USER = "admin";
String DB_PASSWORD= "1234";
String idx = request.getParameter("idx");

Connection con=null;
PreparedStatement pstmt = null;
ResultSet rs=null;
try {
	con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	String sql = "SELECT * FROM video where idx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setInt(1, Integer.parseInt(idx));
	rs = pstmt.executeQuery();
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>동영상 출력 페이지</title>
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
					<img src = "https://i.imgur.com/pAHjkiR.png" width = "100%" height = "100%">
				</a>
				<form action = "search.jsp" method = "post">
					<input type = "text" name = "search_keyword" value = "">
					<input type = "submit" value = "검색">
				</form><p>
				<form action = "upload.jsp" method = "post">
					<input type = "submit" value = "동영상 업로드">
				</form>
		    </div>
		    <div id="content">
<%
	while(rs.next()) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
%>
		    <h1><%=rs.getString("name") %></h1>
		    <!-- 동영상을 로딩해서 자동으로 플레이 해준다. -->
		    <video autoplay src = "./upload/<%=rs.getString("fileName2") %>"></video>
		    <br><%=rs.getString("description") %><br><br>
		   	게시일자 : <%=(String)sdf.format(rs.getTimestamp("lastupdate")) %><br>
		   	업로더 : <%=rs.getString("uploader") %><br>
		   	카테고리 : <%=rs.getString("category") %><br><br>
		   	
		    <button type = "button" onclick = "location.href='modify.jsp?idx=<%=rs.getInt("idx") %>'">동영상 수정</button>
		    <button type = "button" onclick = "if (confirm('정말로 삭제하시겠습니까??'))location.href='delete.jsp?idx=<%=rs.getInt("idx") %>';">동영상 삭제</button>
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

