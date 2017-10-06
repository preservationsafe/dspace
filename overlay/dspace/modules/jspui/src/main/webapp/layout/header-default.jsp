<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - HTML header for main home page
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="org.dspace.app.webui.util.JSPManager" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.app.util.Util" %>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.*" %>

<%
    String title = (String) request.getAttribute("dspace.layout.title");
    String navbar = (String) request.getAttribute("dspace.layout.navbar");
    boolean locbar = ((Boolean) request.getAttribute("dspace.layout.locbar")).booleanValue();

    String siteName = ConfigurationManager.getProperty("dspace.name");
    String feedRef = (String)request.getAttribute("dspace.layout.feedref");
    boolean osLink = ConfigurationManager.getBooleanProperty("websvc.opensearch.autolink");
    String osCtx = ConfigurationManager.getProperty("websvc.opensearch.svccontext");
    String osName = ConfigurationManager.getProperty("websvc.opensearch.shortname");
    List parts = (List)request.getAttribute("dspace.layout.linkparts");
    String extraHeadData = (String)request.getAttribute("dspace.layout.head");
    String extraHeadDataLast = (String)request.getAttribute("dspace.layout.head.last");
    String dsVersion = Util.getSourceVersion();
    String generator = dsVersion == null ? "DSpace" : "DSpace "+dsVersion;
    String analyticsKey = ConfigurationManager.getProperty("jspui.google.analytics.key");
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= siteName %>: <%= title %></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="Generator" content="<%= generator %>" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="<%= request.getContextPath() %>/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/jquery-ui-1.10.3.custom/redmond/jquery-ui-1.10.3.custom.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/bootstrap.min.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/bootstrap-theme.min.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/dspace-theme.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/custom-styles.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/768.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/490.css" type="text/css" />

    <%
        if (!"NONE".equals(feedRef))
        {
            for (int i = 0; i < parts.size(); i+= 3)
            {
    %>
    <link rel="alternate" type="application/<%= (String)parts.get(i) %>" title="<%= (String)parts.get(i+1) %>" href="<%= request.getContextPath() %>/feed/<%= (String)parts.get(i+2) %>/<%= feedRef %>"/>
    <%
            }
        }

        if (osLink)
        {
    %>
    <link rel="search" type="application/opensearchdescription+xml" href="<%= request.getContextPath() %>/<%= osCtx %>description.xml" title="<%= osName %>"/>
    <%
        }

        if (extraHeadData != null)
        { %>
    <%= extraHeadData %>
    <%
        }
    %>

    <script type='text/javascript' src="<%= request.getContextPath() %>/static/js/jquery/jquery-1.10.2.min.js"></script>
    <script type='text/javascript' src='<%= request.getContextPath() %>/static/js/jquery/jquery-ui-1.10.3.custom.min.js'></script>
    <script type='text/javascript' src='<%= request.getContextPath() %>/static/js/bootstrap/bootstrap.min.js'></script>
    <script type='text/javascript' src='<%= request.getContextPath() %>/static/js/holder.js'></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/utils.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/choice-support.js"> </script>
    <dspace:include page="/layout/google-analytics-snippet.jsp" />

    <%
        if (extraHeadDataLast != null)
        { %>
    <%= extraHeadDataLast %>
    <%
        }
    %>


    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="<%= request.getContextPath() %>/static/js/html5shiv.js"></script>
    <script src="<%= request.getContextPath() %>/static/js/respond.min.js"></script>
    <![endif]-->
</head>

<%-- HACK: leftmargin, topmargin: for non-CSS compliant Microsoft IE browser --%>
<%-- HACK: marginwidth, marginheight: for non-CSS compliant Netscape browser --%>
<body>
<header>

    <section id="parent">
        <!-- insitute's logo: link to inst. homepage and add tooltip if set in repo properties -->

        <div style="float: left"><a href="http://www.arizona.edu/" target="_blank" id="logo">

            <img src="<%= request.getContextPath() %>/img/repo-logo.png"
                 title="Go to University of Arizona home"
            />
        </a></div>
    </section>

    <%-- Do not have a known case where the navbar is off currently. Leaving check in place but commented out until its knwn 100% we don't need a minimal nav menu.
        if (!navbar.equals("off")) {
    --%>
        <dspace:include page="<%= navbar %>" />
    <%--
        } else {
    %>
        <dspace:include page="<%= request.getContextPath() %>/navbar-minimal.jsp" />
    <%
        }
    --%>

</header>

<div id="main" role="main">
    <div class="frame">
        <section id="content">
       <%-- <div class="row">
            <div class="col-md-9 brand">
                <h1><fmt:message key="jsp.layout.header-default.brand.heading" /></h1>
                <fmt:message key="jsp.layout.header-default.brand.description" />
            </div>
            <div class="col-md-3"><img class="pull-right" src="<%= request.getContextPath() %>/image/logo.gif" alt="DSpace logo" />
            </div>
        </div>
    <br/>
    <%-- Location bar --
        <%
    if (locbar)
    {
%>
    <div class="container">
        <dspace:include page="/layout/location-bar.jsp" />
    </div>
        <%
    }
%>


    <%-- Page contents --
    <div class="container">
            <% if (request.getAttribute("dspace.layout.sidebar") != null) { %>
        <div class="row">
            <div class="col-md-9">
                    <% } %>

            </div>



        </section> --%>

<%--
        <script type="text/javascript">
            function showBrowseScoped() {
                document.getElementById("browseMenuScoped").style.display = "";
                document.getElementById("browseMenuAll").style.display = "none";
                document.getElementById("community_show_list").style.display = "none";
            }

            function showBrowseAll() {
                document.getElementById("browseMenuScoped").style.display = "none";
                document.getElementById("browseMenuAll").style.display = "";
                document.getElementById("community_show_list").style.display = "";
            }

            function showBrowseCommunity() {
                document.getElementById("community_show_list").style.display = "";
                document.getElementById("community_show_button").style.display = "none";
                document.getElementById("community_hide_button").style.display = "";
            }

            function hideBrowseCommunity() {
                document.getElementById("community_show_list").style.display = "none";
                document.getElementById("community_hide_button").style.display = "none";
                document.getElementById("community_show_button").style.display = "";
            }

        </script>

        <nav id="shortcuts">

            <h1 class="description">

                <a href="<%= request.getContextPath() %>/browse">Browse</a>

                items by
            </h1>


            <ul class="shortcuts-list" id="browseMenuAll">


                <!-- show top level communities --



                <li ><a href="<%= request.getContextPath() %>/browse?type=title">Title</a></li>
                <li ><a href="<%= request.getContextPath() %>/browse?type=author">Authors</a></li>
                <li ><a href="<%= request.getContextPath() %>/browse?type=dateissued">Issue Date</a></li>
                <li ><a href="<%= request.getContextPath() %>/browse?type=dateaccessioned">Submit Date</a></li>
                <li ><a href="<%= request.getContextPath() %>/browse?type=subject">Subjects</a></li>
                <li>
                    <a href="<%= request.getContextPath() %>/community-list">Communities</a>
                    <span id="community_show_button" class="item-number" onclick="showBrowseCommunity()">Show All</span>
                    <span id="community_hide_button" class="item-number" style="display:none;"
                          onclick="hideBrowseCommunity()">Hide All</span>
                    <div id="community_show_list" style="display:none;">
                        <ul>
                            <li><a href="<%= request.getContextPath() %>/handle/10150/595873">UA Faculty Research</a></li>
                            <li><a href="<%= request.getContextPath() %>/handle/10150/595895">UA Graduate and Undergraduate Research</a></li>
                            <li><a href="<%= request.getContextPath() %>/handle/10150/595561">Journals and Magazines</a></li>
                            <li><a href="<%= request.getContextPath() %>/handle/10150/595560">Conference Proceedings</a></li>
                            <li><a href="<%= request.getContextPath() %>/handle/10150/599246">Organizations</a></li></ul>

                    </div>
                </li>
            </ul>
            <h1 class="description small-space">Featured Collections</h1>
            <ul class="shortcuts-list" id="browseLocalLinks">
                <li><a href="<%= request.getContextPath() %>/andle/10150/595893" target="_blank">UA Faculty Publications</a></li>
                <li><a href="<%= request.getContextPath() %>/handle/10150/129652" target="_blank">UA Dissertations</a></li>
                <li><a href="<%= request.getContextPath() %>/handle/10150/129651" target="_blank">UA Master's Theses</a></li>
                <li><a href="<%= request.getContextPath() %>/handle/10150/129650" target="_blank">UA Honors Theses</a></li>
                <li><a href="<%= request.getContextPath() %>/handle/10150/576138" target="_blank">UA Press</a></li>
                <li><a href="<%= request.getContextPath() %>/handle/10150/145753" target="_blank">UA Yearbooks</a></li>
                <li><a href="<%= request.getContextPath() %>/handle/10150/217129" target="_blank">UA Catalogs</a></li>
            </ul>
            <h1 class="description small-space">Quick guides</h1>
            <ul class="shortcuts-list" id="browseGuides">
                <li><a href="<%= request.getContextPath() %>/about-this-service.jsp#6" target="blank">Getting started</a></li>
                <li><a href="<%= request.getContextPath() %>/about-this-service.jsp#2" target="blank">Using search</a></li>
                <li><a href="<%= request.getContextPath() %>/about-this-service.jsp#3" target="blank">Browsing</a></li>
                <li><a href="<%= request.getContextPath() %>/about-this-service.jsp#4" target="blank">Submitting content</a></li>
                <li><a href="<%= request.getContextPath() %>/about-this-service.jsp#5" target="blank">Editing your details</a></li>
                <li>
                    <script type="text/javascript">
                        <!-- Javascript starts here
                        document.write('<a href="#" onClick="var popupwin = window.open(\'/arizona/help/index.jsp\',\'dspacepopup\',\'height=600,width=550,resizable,scrollbars\');popupwin.focus();return false;">More help<\/a>');
                        // -->
                    </script><noscript><a href="<%= request.getContextPath() %>/help/index.jsp" target="dspacepopup">More help</a></noscript>
                </li>
            </ul>
        </nav>

        --%>
