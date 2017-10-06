<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%--
  - Display hierarchical list of communities and collections
  -
  - Attributes to be passed in:
  -    communities         - array of communities
  -    collections.map  - Map where a keys is a community IDs (Integers) and
  -                      the value is the array of collections in that community
  -    subcommunities.map  - Map where a keys is a community IDs (Integers) and
  -                      the value is the array of subcommunities in that community
  -    admin_button - Boolean, show admin 'Create Top-Level Community' button
  --%>

<%@page import="java.util.List"%>
<%@page import="org.dspace.content.service.CollectionService"%>
<%@page import="org.dspace.content.factory.ContentServiceFactory"%>
<%@page import="org.dspace.content.service.CommunityService"%>
<%@page import="org.dspace.content.Bitstream"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.browse.ItemCountException" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Map" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    List<Community> communities = (List<Community>) request.getAttribute("communities");
    Map collectionMap = (Map) request.getAttribute("collections.map");
    Map subcommunityMap = (Map) request.getAttribute("subcommunities.map");
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));
%>

<%!
    CommunityService comServ = ContentServiceFactory.getInstance().getCommunityService();
    CollectionService colServ = ContentServiceFactory.getInstance().getCollectionService();
    void showCommunity(Community c, JspWriter out, HttpServletRequest request, ItemCounter ic,
                       Map collectionMap, Map subcommunityMap) throws ItemCountException, IOException, SQLException
    {
        boolean showLogos = ConfigurationManager.getBooleanProperty("jspui.community-list.logos", true);
        out.println( "<li class=\"media well\">" );
        Bitstream logo = c.getLogo();
        if (showLogos && logo != null)
        {
            out.println("<a class=\"pull-left col-md-2\" href=\"" + request.getContextPath() + "/handle/"
                    + c.getHandle() + "\"><img class=\"media-object img-responsive\" src=\"" +
                    request.getContextPath() + "/retrieve/" + logo.getID() + "\" alt=\"community logo\"></a>");
        }
        out.println( "<div class=\"media-body\"><h4 class=\"media-heading\"><a href=\"" + request.getContextPath() + "/handle/"
                + c.getHandle() + "\">" + c.getName() + "</a>");
        if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
        {
            out.println(" <span class=\"badge\">" + ic.getCount(c) + "</span>");
        }
        out.println("</h4>");

        if (StringUtils.isNotBlank(comServ.getMetadata(c, "short_description")))
        {
            out.println(comServ.getMetadata(c, "short_description"));
        }
        out.println("<br>");
        // Get the collections in this community
        List<Collection> cols = (List<Collection>) collectionMap.get(c.getID().toString());
        if (cols != null && cols.size() > 0)
        {
            out.println("<ul class=\"media-list\">");
            for (int j = 0; j < cols.size(); j++)
            {
                out.println("<li class=\"media well\">");

                Bitstream logoCol = cols.get(j).getLogo();
                if (showLogos && logoCol != null)
                {
                    out.println("<a class=\"pull-left col-md-2\" href=\"" + request.getContextPath() + "/handle/"
                            + cols.get(j).getHandle() + "\"><img class=\"media-object img-responsive\" src=\"" +
                            request.getContextPath() + "/retrieve/" + logoCol.getID() + "\" alt=\"collection logo\"></a>");
                }
                out.println("<div class=\"media-body\"><h4 class=\"media-heading\"><a href=\"" + request.getContextPath() + "/handle/" + cols.get(j).getHandle() + "\">" + cols.get(j).getName() +"</a>");
                if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
                {
                    out.println(" [" + ic.getCount(cols.get(j)) + "]");
                }
                out.println("</h4>");
                if (StringUtils.isNotBlank(colServ.getMetadata(cols.get(j), "short_description")))
                {
                    out.println(colServ.getMetadata(cols.get(j), "short_description"));
                }
                out.println("</div>");
                out.println("</li>");
            }
            out.println("</ul>");
        }

        // Get the sub-communities in this community
        List<Community> comms = (List<Community>) subcommunityMap.get(c.getID().toString());
        if (comms != null && comms.size() > 0)
        {
            out.println("<ul class=\"media-list\">");
            for (int k = 0; k < comms.size(); k++)
            {
                showCommunity(comms.get(k), out, request, ic, collectionMap, subcommunityMap);
            }
            out.println("</ul>");
        }
        out.println("</div>");
        out.println("</li>");
    }
%>

<dspace:layout titlekey="jsp.community-list.title">

    <%
        if (admin_button)
        {
    %>
    <dspace:sidebar>
        <div class="panel panel-warning">
        <div class="panel-heading">
            <fmt:message key="jsp.admintools"/>
            <span class="pull-right">
					<dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.site-admin\")%>"><fmt:message key="jsp.adminhelp"/></dspace:popup>
				</span>
        </div>
        <div class="panel-body">
            <form method="post" action="<%=request.getContextPath()%>/dspace-admin/edit-communities">
                <input type="hidden" name="action" value="<%=EditCommunitiesServlet.START_CREATE_COMMUNITY%>" />
                <input class="btn btn-default" type="submit" name="submit" value="<fmt:message key="jsp.community-list.create.button"/>" />
            </form>
        </div>
    </dspace:sidebar>
    <%
        }
    %>
    <h1><fmt:message key="jsp.community-list.title"/></h1>
    <p><fmt:message key="jsp.community-list.text1"/></p>

    <% if (communities.size() != 0)
    {
    %>
    <ul class="media-list">
        <%
            for (int i = 0; i < communities.size(); i++)
            {
                showCommunity(communities.get(i), out, request, ic, collectionMap, subcommunityMap);
            }
        %>
    </ul>

    <% }
    %>
</dspace:layout>













<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%--
  - Display hierarchical list of communities and collections
  -
  - Attributes to be passed in:
  -    communities         - array of communities
  -    collections.map  - Map where a keys is a community IDs (Integers) and
  -                      the value is the array of collections in that community
  -    subcommunities.map  - Map where a keys is a community IDs (Integers) and
  -                      the value is the array of subcommunities in that community
  -    admin_button - Boolean, show admin 'Create Top-Level Community' button

<%@page import="java.util.List"%>
<%@page import="org.dspace.content.service.CollectionService"%>
<%@page import="org.dspace.content.factory.ContentServiceFactory"%>
<%@page import="org.dspace.content.service.CommunityService"%>
<%@page import="org.dspace.content.Bitstream"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.browse.ItemCountException" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Map" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>


<div id="main" role="main">

    <div class="frame">

        <section id="content" >

            <div id="intro">

                <div class="crumbs">

                    <a href="<%= request.getContextPath() %>/index">The University of Arizona Campus Repository
                    </a>&nbsp;&gt;

                </div>

                <h1 class="page-title">
                    Communities &amp; Collections

                </h1>
            </div>


            <link rel="stylesheet" href="<%= request.getContextPath() %>/static/js/collapsableTree/collapsableTree.css"
                  type="text/css"/>

            <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/jquery.js"></script>
            <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/collapsableTree/collapsableTree.js"></script>
            <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/collapsableTree/community-list.js"></script>
            <script type="text/javascript">
                jQuery.noConflict();
            </script>
            <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>

            <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/custom-styles.css" type="text/css" />
            <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/768.css" type="text/css" />
            <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/490.css" type="text/css" />


            <section class="intro">
                <p>Shown below is a list of communities and the collections and sub-communities within them. Click on a name to view that community or collection home page.</p>
            </section>


            <div id="community-list-browser-1" class="intro">
                <input type="submit" value="Expand All" id="expand"> <input type="submit" value="Collapse All" id="collapse">
                &nbsp;

                <ul class="list-collection" id="community-list-browser" style="padding-top:20px;">

                        <%
    List<Community> communities = (List<Community>) request.getAttribute("communities");
    Map collectionMap = (Map) request.getAttribute("collections.map");
    Map subcommunityMap = (Map) request.getAttribute("subcommunities.map");
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));
%>

                                <%!
	CommunityService comServ = ContentServiceFactory.getInstance().getCommunityService();
	CollectionService colServ = ContentServiceFactory.getInstance().getCollectionService();
    void showCommunity(Community c, JspWriter out, HttpServletRequest request, ItemCounter ic,
    		Map collectionMap, Map subcommunityMap) throws ItemCountException, IOException, SQLException
    {
		boolean showLogos = ConfigurationManager.getBooleanProperty("jspui.community-list.logos", true);
        out.println( "<li class=\"communitiesOrderingOnPage\">" );
        Bitstream logo = c.getLogo();
        if (showLogos && logo != null)
        {
        	out.println("<a href=\"" + request.getContextPath() + "/handle/"
        		+ c.getHandle() + "\"><img class=\"media-object img-responsive\" src=\"" +
        		request.getContextPath() + "/retrieve/" + logo.getID() + "\" alt=\"community logo\"></a>");
        }
        out.println( "<a href=\"" + request.getContextPath() + "/handle/"
        	+ c.getHandle() + "\">" + c.getName() + "</a>");
        if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
        {
            out.println(" <span class=\"item-number\">" + ic.getCount(c) + "</span>");
        }

		if (StringUtils.isNotBlank(comServ.getMetadata(c, "short_description")))
		{
			out.println(comServ.getMetadata(c, "short_description"));
		}
		out.println("<br>");
        // Get the collections in this community
        List<Collection> cols = (List<Collection>) collectionMap.get(c.getID().toString());
        if (cols != null && cols.size() > 0)
        {
            out.println("<ul class=\"communitiesOrderingOnPage\">");
            for (int j = 0; j < cols.size(); j++)
            {
                out.println("<li class=\"communitiesOrderingOnPage\">");

                Bitstream logoCol = cols.get(j).getLogo();
                out.println("<a href=\"" + request.getContextPath() + "/handle/" + cols.get(j).getHandle() + "\">" + cols.get(j).getName() +"</a>");
				if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
                {
                    out.println(" [" + ic.getCount(cols.get(j)) + "]");
                }

				if (StringUtils.isNotBlank(colServ.getMetadata(cols.get(j), "short_description")))
				{
					out.println(colServ.getMetadata(cols.get(j), "short_description"));
				}

                out.println("</li>");
            }
            out.println("</ul>");
        }
        out.println("</div>");
        out.println("</li>");
    }
%>

                <dspace:layout titlekey="jsp.community-list.title">

                        <%
    if (admin_button)
    {
%>
                <dspace:sidebar>
                <div class="panel panel-warning">
                    <div class="panel-heading">
                        <fmt:message key="jsp.admintools"/>
                        <span class="pull-right">
					<dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.site-admin\")%>"><fmt:message key="jsp.adminhelp"/></dspace:popup>
				</span>
                    </div>
                    <div class="panel-body">
                        <form method="post" action="<%=request.getContextPath()%>/dspace-admin/edit-communities">
                            <input type="hidden" name="action" value="<%=EditCommunitiesServlet.START_CREATE_COMMUNITY%>" />
                            <input class="btn btn-default" type="submit" name="submit" value="<fmt:message key="jsp.community-list.create.button"/>" />
                        </form>
                    </div>
                    </dspace:sidebar>
                            <%
    }
%>
                    <h1><fmt:message key="jsp.community-list.title"/></h1>
                    <p><fmt:message key="jsp.community-list.text1"/></p>

                            <% if (communities.size() != 0)
{
%>
                    <ul class="list-collection" id="community-list-browser" style="padding-top:20px">
                        <%
                            for (int i = 0; i < communities.size(); i++)
                            {
                                showCommunity(communities.get(i), out, request, ic, collectionMap, subcommunityMap);
                            }
                        %>
                    </ul>

                            <% }
%>
                    </dspace:layout>




                    --%>


<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%--
  - Display hierarchical list of communities and collections
  -
  - Attributes to be passed in:
  -    communities         - array of communities
  -    collections.map  - Map where a keys is a community IDs (Integers) and
  -                      the value is the array of collections in that community
  -    subcommunities.map  - Map where a keys is a community IDs (Integers) and
  -                      the value is the array of subcommunities in that community
  -    admin_button - Boolean, show admin 'Create Top-Level Community' button
  --%

<%@page import="java.util.List"%>
<%@page import="org.dspace.content.service.CollectionService"%>
<%@page import="org.dspace.content.factory.ContentServiceFactory"%>
<%@page import="org.dspace.content.service.CommunityService"%>
<%@page import="org.dspace.content.Bitstream"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.browse.ItemCountException" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Map" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>


<%--<div id="main" role="main">

    <div class="frame">

        <section id="content" >

            <div id="intro">

                <div class="crumbs">

                    <a href="<%= request.getContextPath() %>/index">The University of Arizona Campus Repository
                    </a>&nbsp;&gt;

                </div>

                <h1 class="page-title">
                    Communities &amp; Collections

                </h1>
            </div>
            --%


            <link rel="stylesheet" href="<%= request.getContextPath() %>/static/js/collapsableTree/collapsableTree.css"
                  type="text/css"/>

            <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/jquery.js"></script>
            <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/collapsableTree/collapsableTree.js"></script>
            <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/collapsableTree/community-list.js"></script>
            <script type="text/javascript">
                jQuery.noConflict();
            </script>
            <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>

            <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/custom-styles.css" type="text/css" />
            <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/768.css" type="text/css" />
            <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/490.css" type="text/css" />


            <section class="intro">
                <p>Shown below is a list of communities and the collections and sub-communities within them. Click on a name to view that community or collection home page.</p>
            </section>


            <div id="community-list-browser-1" class="intro">
                <input type="submit" value="Expand All" id="expand"> <input type="submit" value="Collapse All" id="collapse">
                &nbsp;

                <ul class="list-collection" id="community-list-browser" style="padding-top:20px;">
                        <%
    List<Community> communities = (List<Community>) request.getAttribute("communities");
    Map collectionMap = (Map) request.getAttribute("collections.map");
    Map subcommunityMap = (Map) request.getAttribute("subcommunities.map");
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));
%>


<%!
    CommunityService comServ = ContentServiceFactory.getInstance().getCommunityService();
    CollectionService colServ = ContentServiceFactory.getInstance().getCollectionService();
    void showCommunity(Community c, JspWriter out, HttpServletRequest request, ItemCounter ic,
                       Map collectionMap, Map subcommunityMap) throws ItemCountException, IOException, SQLException
    {
        boolean showLogos = ConfigurationManager.getBooleanProperty("jspui.community-list.logos", true);
        out.println( "<li class=\"communitiesOrderingOnPage\">" );
        Bitstream logo = c.getLogo();
        if (showLogos && logo != null)
        {
            out.println("<a href=\"" + request.getContextPath() + "/handle/"
                    + c.getHandle() + "\"><img class=\"media-object img-responsive\" src=\"" +
                    request.getContextPath() + "/retrieve/" + logo.getID() + "\" alt=\"community logo\"></a>");
        }
        out.println( "<a href=\"" + request.getContextPath() + "/handle/"
                + c.getHandle() + "\">" + c.getName() + "</a>");
        if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
        {
            out.println(" <span class=\"item-number\">" + ic.getCount(c) + "</span>");
        }

        if (StringUtils.isNotBlank(comServ.getMetadata(c, "short_description")))
        {
            out.println(comServ.getMetadata(c, "short_description"));
        }
        out.println("<br>");
        // Get the collections in this community
        List<Collection> cols = (List<Collection>) collectionMap.get(c.getID().toString());
        if (cols != null && cols.size() > 0)
        {
            out.println("<ul class=\"communitiesOrderingOnPage\">");
            for (int j = 0; j < cols.size(); j++)
            {
                out.println("<li class=\"communitiesOrderingOnPage\">");

                Bitstream logoCol = cols.get(j).getLogo();
                out.println("<a href=\"" + request.getContextPath() + "/handle/" + cols.get(j).getHandle() + "\">" + cols.get(j).getName() +"</a>");
                if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
                {
                    out.println(" [" + ic.getCount(cols.get(j)) + "]");
                }

                if (StringUtils.isNotBlank(colServ.getMetadata(cols.get(j), "short_description")))
                {
                    out.println(colServ.getMetadata(cols.get(j), "short_description"));
                }

                out.println("</li>");
            }
            out.println("</ul>");
        }
        out.println("</div>");
        out.println("</li>");
    }
%>

<dspace:layout titlekey="jsp.community-list.title">

    <%
        if (admin_button)
        {
    %>
    <dspace:sidebar>
        <div class="panel panel-warning">
        <div class="panel-heading">
            <fmt:message key="jsp.admintools"/>
            <span class="pull-right">
					<dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.site-admin\")%>"><fmt:message key="jsp.adminhelp"/></dspace:popup>
				</span>
        </div>
        <div class="panel-body">
            <form method="post" action="<%=request.getContextPath()%>/dspace-admin/edit-communities">
                <input type="hidden" name="action" value="<%=EditCommunitiesServlet.START_CREATE_COMMUNITY%>" />
                <input class="btn btn-default" type="submit" name="submit" value="<fmt:message key="jsp.community-list.create.button"/>" />
            </form>
        </div>
    </dspace:sidebar>
    <%
        }
    %>
    <h1><fmt:message key="jsp.community-list.title"/></h1>
    <p><fmt:message key="jsp.community-list.text1"/></p>

    <% if (communities.size() != 0)
    {
    %>
    <ul class="list-collection" id="community-list-browser" style="padding-top:20px">
        <%
            for (int i = 0; i < communities.size(); i++)
            {
                showCommunity(communities.get(i), out, request, ic, collectionMap, subcommunityMap);
            }
        %>
    </ul>

    <% }
    %>
</dspace:layout>





