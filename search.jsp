<%@ page contentType="text/html;charset=utf-8" import="java.sql.*, java.text.SimpleDateFormat" %>

<%
request.setCharacterEncoding("utf-8");
//검색 키워드를 parameter로 받아와 keyword 문자열에 저장한다.
String keyword = request.getParameter("search_keyword");

Class.forName("org.mariadb.jdbc.Driver");
String DB_URL = "jdbc:mariadb://localhost:3306/movieboard?useSSL=false";
String DB_USER = "admin";
String DB_PASSWORD= "1234";

Connection con=null;
PreparedStatement pstmt = null;
ResultSet rs=null;
try {
	con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	//keyword를 name attribute에 포함하는 모든 튜플을 가져오는 쿼리문을 작성한다. (LIKE문 이용)
	String sql = "SELECT * FROM video WHERE name LIKE '%" + keyword + "%'";
	pstmt = con.prepareStatement(sql);
	rs = pstmt.executeQuery();
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>검색 결과</title>
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
					<input type = "text" name = "search_keyword" value = "<%= keyword %>">
					<input type = "submit" value = "검색">
				</form><p>
				<form action = "upload.jsp" method = "post">
					<input type = "submit" value = "동영상 업로드">
				</form>
		    </div>
		    <div id="content">
<%
	//main.jsp 페이지와 동일하게 검색된 모든 동영상 정보를 출력해준다.
	while(rs.next()) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
%>
		    <h1><%=rs.getString("name") %></h1>
		    <a href = "show.jsp?idx=<%=rs.getInt("idx") %>">
		    	<img src = "./upload/<%=rs.getString("fileName1") %>" width = "100%" height = "100%"><br>
		    </a>
		    <%=rs.getString("description") %><br><br>
		   	게시일 : <%=(String)sdf.format(rs.getTimestamp("lastupdate")) %><br>
		   	업로더 : <%=rs.getString("uploader") %><br>
		   	카테고리 : <%=rs.getString("category") %><br><br>
		   	
		    <button type = "button" onclick = "location.href='modify.jsp?idx=<%=rs.getInt("idx") %>'">동영상 수정</button>
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

