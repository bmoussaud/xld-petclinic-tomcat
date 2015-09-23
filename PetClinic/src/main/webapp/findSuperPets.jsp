<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" href="/petclinic/styles/petclinic.css" type="text/css"/>
    <title>PetClinic :: a Spring Framework demonstration</title>
</head>

<body>

<div id="main">

    <%
        java.util.Random rand = new java.util.Random();
        int  n = rand.nextInt(4);
        Thread.sleep(n*10);
    %>
    <h2>Find Super Pets: <%= n %></h2>



    <br/>
    <table class="footer">
        <tr>
            <td><a href="/petclinic/index.html">Home</a></td>
            <td align="right"><img src="/petclinic/images/springsource-logo.png"></td>
        </tr>
    </table>

</div>
</body>

</html>

