<%@ page contentType="text/html;charset=utf-8" import="java.sql.*, java.io.*" %>
<%
request.setCharacterEncoding("utf-8");
 
try {
	String idx = request.getParameter("idx");
	Class.forName("org.mariadb.jdbc.Driver");
	
	String DB_URL = "jdbc:mariadb://localhost:3306/movieboard?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD= "1234";

	Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

	//썸네일 파일, 동영상 파일을 삭제하기 위해 SELECT문으로 찾는 부분
	String sql = "SELECT fileName1, fileName2 FROM video WHERE idx=?";

	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setInt(1, Integer.parseInt(idx));
	ResultSet rs = pstmt.executeQuery();
	rs.next();

	String filename = rs.getString("fileName1");
	String filename2 = rs.getString("fileName2");

	//썸네일 파일, 동영상 파일의 경로를 알아내고 파일을 삭제하는 부분
	ServletContext context = getServletContext();
	String realFolder = context.getRealPath("upload");
	File file = new File(realFolder+ "\\" +filename);
	File file2 = new File(realFolder+ "\\" +filename2);
	file.delete();
	file2.delete();

	//데이터베이스 상의 튜플을 삭제하는 부분
	sql = "DELETE FROM video WHERE idx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setInt(1, Integer.parseInt(idx));
	pstmt.executeUpdate();
	
	rs.close();
	pstmt.close();
	con.close();
} catch (SQLException e) {
	out.println(e.toString());
	return;
} catch (Exception e) { 
	out.println(e.toString());
	return;
}

//모든 작업이 끝난 후에는 메인 페이지로 리다이렉트
response.sendRedirect("main.jsp");   
%> 