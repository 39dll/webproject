<%@ page language="java" contentType="text/html; charset=UTF-8"
	import = "com.oreilly.servlet.*, com.oreilly.servlet.multipart.*"
	import = "java.sql.*, java.io.*"
%>
<%
request.setCharacterEncoding("utf-8");
ServletContext context = getServletContext();
String realFolder = context.getRealPath("upload");
int maxsize = 1024 * 1024 * 5;
MultipartRequest multi = new MultipartRequest(request, realFolder, maxsize, "utf-8",
		new DefaultFileRenamePolicy());

//동영상의 정보를 불러온다.
Integer idx = Integer.parseInt(request.getParameter("idx"));
String video_name = multi.getParameter("video_name");
String video_description = multi.getParameter("video_description");
String uploader = multi.getParameter("uploader");
String video_category = multi.getParameter("video_category");
String fileName = multi.getFilesystemName("fileName");
String fileName2 = multi.getFilesystemName("fileName2");

Class.forName("org.mariadb.jdbc.Driver");
String url = "jdbc:mariadb://localhost:3306/movieboard?useSSL=false";
Connection con = DriverManager.getConnection(url, "admin", "1234");
PreparedStatement pstmt = null;
ResultSet rs = null;
String sql = null;
if (fileName != null) { //썸네일 파일이 변경되었을 경우
	sql = "SELECT fileName1 FROM video WHERE idx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setInt(1, idx);
	rs = pstmt.executeQuery();
	rs.next();
	
	//기존의 썸네일 파일은 삭제해준다.
	String oldFileName = rs.getString("fileName1");
	File oldFile = new File(realFolder+"\\"+oldFileName);
	oldFile.delete();
	
	//새로운 썸네일을 적용해준다.
	sql = "UPDATE video SET fileName1=? WHERE idx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, fileName);
	pstmt.setInt(2, idx);
	pstmt.executeUpdate();
}
if (fileName2 != null) { //동영상 파일이 변경되었을 경우
	sql = "SELECT fileName2 FROM video WHERE idx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setInt(1, idx);
	rs = pstmt.executeQuery();
	rs.next();
	
	//기존의 동영상 파일은 삭제해준다.
	String oldFileName = rs.getString("fileName2");
	File oldFile = new File(realFolder+"\\"+oldFileName);
	oldFile.delete();
	
	//새로운 동영상을 적용해준다.
	sql = "UPDATE video SET fileName2=? WHERE idx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, fileName2);
	pstmt.setInt(2, idx);
	
	pstmt.executeUpdate();
}
{ //파일 외의 정보들 업데이트
	sql = "UPDATE video SET name=?, description=?, category=?, uploader=?, lastupdate=? WHERE idx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1, video_name);
	pstmt.setString(2, video_description);
	pstmt.setString(3, video_category);
	pstmt.setString(4, uploader);
	//수정할 때도 timestamp를 업데이트해준다.
	pstmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
	pstmt.setInt(6, idx);
	
	pstmt.executeUpdate();
}

if (pstmt != null)pstmt.close();
if (rs != null)rs.close();
if (con != null)con.close();

response.sendRedirect("show.jsp?idx="+idx.toString());
%>
