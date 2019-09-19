<%@ taglib uri="uri" prefix="prefixOfTag" %>
<%@taglib prefix="c" uri="uri"%>
<%@ page isELIgnored = "false" %>

 <%-- This is 
 a 
 multiline
 comment
  --%> 

<html>
   <head><title>Hello World</title></head>
   <c:set var="realm" value='<%=AppConfig.getRealm().name()%>' />
   
   <body>
      Hello World!<br/>

    <script type="text/javascript">
        <c:if test="${includeJS}">
            alert("hello!");
            var country = "argentina";
        </c:if>
        <jsp:scriptlet>
             out.println("Your IP address is " + request.getRemoteAddr());
        </jsp:scriptlet>
    </script>

    <style>
        .timer {position:relative; height:8px; margin-bottom:2px; font-size:1px;}
        <c:if test="${includeJS}">
            .timer2 {position:absolute;}
        </c:if>
    </style>

    <div class="nav-link" style="display:<%=isAdmin ? "inline" : "none" %>">
    </div>

    <a href="/search?q=<c:out value="${query}"/>&h_pageNumber=1&h_pageSize=10">
        A link!
    </a>

    <select name="role" <c:if test="${isAdmin}">disabled="disabled"</c:if>>
        <option value="User" <c:if test="${user.role eq 'ENTITY_USER'}">selected="selected"</c:if>></option>
    </select>

<%-- Interpolations --%> 

    <input type="${'hidden'}" id="sampleCertificate" value="<c:out value ="${sampleCertificate}"/>" />

    <c:text>
        ${myViewModel.myProperty}
    </c:text>

<%-- Scriptlets --%> 

      <%
         out.println("Your IP address is " + request.getRemoteAddr());
      %>
        <jsp:scriptlet>
             out.println("Your IP address is " + request.getRemoteAddr());
        </jsp:scriptlet>

<%-- Declarations --%> 

    <%! int i=0; %> 
    <%! int a, b, c; %> 
    <%! Circle a=new Circle(2.0); %> 

    <jsp:declaration>
        Rectangle r=new Rectangle(2.0);
    </jsp:declaration>

<%-- Expressions --%>

    <p>Today's date: <%= (new java.util.Date()).toLocaleString()%></p>

        <jsp:expression>
            (new java.util.Date()).toLocaleString();
        </jsp:expression>

<%-- Directives --%>

            <%@ page attribute="value" %>
            <jsp:directive.page attribute="value" />
            <%@ include file="relative url" %>
            <jsp:directive.include file="relative url" />
            <%@ taglib uri="uri" prefix="prefixOfTag" %>
            <jsp:directive.taglib uri="uri" prefix="prefixOfTag" />

<%-- Actions --%>    

            <jsp:include page="relative URL" flush="true" />
            <jsp:useBean id="name" class="package.class" />
            <jsp:useBean id="myName" class="package.class"  >
            <jsp:setProperty name="myName" property="someProperty" />
            </jsp:useBean>
            <jsp:getProperty name="myName" property="someProperty" />
            <jsp:forward page="date.jsp" />
            <jsp:plugin type="applet" codebase="dirname" code="MyApplet.class"
            width="60" height="80">
            <jsp:param name="fontcolor" value="red" />
            <jsp:param name="background" value="black" />
            
            <jsp:fallback>
                Unable to initialize Java Plugin
            </jsp:fallback>
            
            </jsp:plugin>
            <jsp:element name="xmlElement">
                <jsp:attribute name="xmlElementAttr">
                    Value for the attribute
                </jsp:attribute>
                
                <jsp:body>
                    Body for XML element
                </jsp:body>

            </jsp:element>
            <jsp:text>Template data</jsp:text>

<%-- Using tag libraries --%>

        <c:set var="nameofvariable" value="10"/>
        <c:if test="nameofvariable == 10">
            <p>Condition is true!</p>
            <input name="pswd" type="password" />
             <script type="text/javascript">
                    function callMe() {
                        return 42;
                    }
            </script>
            <jsp:scriptlet>
                out.println("Your IP address is " + request.getRemoteAddr());
            </jsp:scriptlet>
        </c:if>
        <c:otherwise>
            <p>Boo! Condition is false!</p>
        </c:otherwise>


   </body>
</html>