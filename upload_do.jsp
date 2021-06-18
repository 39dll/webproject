<%@ page contentType="text/html;charset=utf-8" 
	import="com.oreilly.servlet.*, com.oreilly.servlet.multipart.*"
	import="java.sql.*, java.io.*" 
%>
<%
request.setCharacterEncoding("utf-8");

Class.forName("org.mariadb.jdbc.Driver");
String DB_URL = "jdbc:mariadb://localhost:3306/movieboard?useSSL=false";
String DB_USER = "admin";
String DB_PASSWORD= "1234";

ServletContext context = getServletContext();
String realFolder = context.getRealPath("upload");
//업로드가 끝난 뒤 방금 올린 동영상의 출력 페이지로 보내기 위해 마지막 튜플의 idx를 저장하는 변수를 만든다.
Integer lastidx = 0;

int maxsize = 1024 * 1024 * 5;

try {
	MultipartRequest multi = new MultipartRequest(request, realFolder, maxsize, "utf-8",
			new DefaultFileRenamePolicy());

	//upload.jsp에서 받아온 정보들을 변수에 담아준다.
	String video_name = multi.getParameter("video_name");
	String video_description = multi.getParameter("video_description");
	String uploader = multi.getParameter("uploader");
	String video_category = multi.getParameter("video_category");
	String fileName = multi.getFilesystemName("fileName");
	String fileName2 = multi.getFilesystemName("fileName2");

	Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

	String sql = "INSERT INTO video(name, description, category, uploader, lastupdate, fileName1, fileName2) VALUES(?, ?, ?, ?, ?, ?, ?)";
	
	PreparedStatement pstmt = con.prepareStatement(sql);

	pstmt.setString(1, video_name);
	pstmt.setString(2, video_description);
	pstmt.setString(3, video_category);
	pstmt.setString(4, uploader);
	//timestamp 객체를 생성해서 lastupdate attribute에 넣어준다.
	pstmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
	pstmt.setString(6, fileName);
	pstmt.setString(7, fileName2);
	
	pstmt.executeUpdate();
	
	//방금 INSERT한 튜플의 idx값을 알아낸다.
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery("SELECT * FROM video");
	if(rs.last()){ //rs.last()인 경우 rs.getInt("idx")는 방금 저장한 튜플의 idx를 리턴한다.
		lastidx = rs.getInt("idx");
	}
	
	pstmt.close();
	con.close();
	rs.close();
} catch(IOException e) { 
	out.println(e);
	return;
} catch(SQLException e) {
	out.println(e);
	return;
}
//등록이 끝났으면 업로드한 동영상의 출력 페이지로 리다이렉트한다.
response.sendRedirect("show.jsp?idx="+lastidx.toString());
%>