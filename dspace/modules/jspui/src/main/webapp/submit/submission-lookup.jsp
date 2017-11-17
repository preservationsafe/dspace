<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - UI page for selection of collection.
  -
  - Required attributes:
  -    collections - Array of collection objects to show in the drop-down.
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.submit.AbstractProcessingStep" %>
<%@ page import="org.dspace.app.util.SubmissionInfo" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="java.lang.Boolean" %>
<%@ page import="java.util.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>
	
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    String contextPath = "/dspace-jspui";
	request.setAttribute("LanguageSwitch", "hide");

    //get collection id from the collection home
	Object collection_id_object = request.getAttribute("collection_id");

	String collection_id;

	if(collection_id_object instanceof UUID){
		UUID uuid = (UUID) collection_id_object;
		collection_id = uuid.toString();
	}
	else {
		collection_id = (String) collection_id_object;
	}

    //check if we need to display the "no collection selected" error
    Boolean noCollection = (Boolean) request.getAttribute("no.collection");
    Boolean nosuuid = (Boolean) request.getAttribute("nouuid");
    Boolean expired = (Boolean) request.getAttribute("expired");
    
    Map<String, List<String>> identifiers2providers = (Map<String, List<String>>) request.getAttribute("identifiers2providers");
    List<String> searchProviders = (List<String>) request.getAttribute("searchProviders");
    List<String> identifiers = (List<String>) request.getAttribute("identifiers");
    String uuid = (String) request.getAttribute("s_uuid");
%>

<c:set var="dspace.layout.head" scope="request">
	<style type="text/css">
		
	#link-ricerca-identificatore {cursor: pointer; font-weight: bold; color: #FF6600;}
	.sl-result {padding: 10px;}
	.sl-result:HOVER {background-color: #5C9CCC;}
	.sl-result-title, .sl-result-authors, .sl-result-date {display: block;}
	.sl-result-title {font-weight: bold;}
	.sl-result-authors {font-style: italic;}
	.sl-result-date {margin-bottom: 10px;}
	.invalid-value {border: 1px solid #FF6600;}
	</style>	
	<script type='text/javascript'>var dspaceContextPath = "<%=request.getContextPath()%>";</script>		
</c:set>
<c:set var="dspace.layout.head.last" scope="request">		
	<script type="text/javascript" src="<%= request.getContextPath() %>/static/js/submission-lookup.js"></script>
</c:set>

<dspace:layout style="submission"
               locbar="off"
               navbar="off"
               titlekey="jsp.submit.start-lookup-submission.search-loading.title"
               nocache="true">

        <jsp:include page="/submit/progressbar.jsp"/>

    <form name="foo" id="form-submission-search" action="<%= request.getContextPath() %>/submit" method="post" onkeydown="return disableEnterKey(event);">

     <h1><fmt:message key="jsp.submit.start-lookup-submission.search-loading.title"/>
	
	<h3><a href="#"><fmt:message key="jsp.submit.start-lookup-submission.identifiers"/></a></h3>
	<div id="identifier-group">
		<input type="hidden" id="suuid-identifier" name="suuid" value="<%= uuid %>"/>
		<input type="hidden" id="iuuid-identifier" name="iuuid" value=""/>
		<input type="hidden" id="fuuid-identifier" name="fuuid" value=""/>
		<input type="hidden" id="collectionid-identifier" name="collectionid" value=""/>
<% if (identifiers != null && identifiers.size()>0) {
	%>
		
		<p class="help-block"><fmt:message key="jsp.submit.start-lookup-submission.identifiers.hints"/></p>
<%	
		for (String identifier : identifiers)
		{			
%>
<c:set var="identifier"><%= identifier %></c:set>
	<!-- div class="form-group" -->
	<div class="row">
		<label class="col-md-3" for="identifier_<%= identifier%>"><span class="submission-lookup-label"><fmt:message key="jsp.submit.start-lookup-submission.identifier-${identifier}"/>:</span> 
		<span class="help-block submission-lookup-hint"><fmt:message key="jsp.submit.start-lookup-submission.identifier-${identifier}.hint"/></span></label>
		<div class="col-md-9">
		<div class="col-md-4">
		<input class="form-control  submission-lookup-identifier" type="text" name="identifier_<%= identifier%>" id="identifier_<%= identifier%>" />
		</div>
		<div class="col-md-7">
<%	
			for (String provider : identifiers2providers.get(identifier))
			{			
%>
		
			<img class="img-thumbnail" src="<%= request.getContextPath() %>/image/submission-lookup-small-<%= provider %>.jpg" />
		
<% 
			}
%>
      </div></div></div>
<%
    }
%>				
	<div class="row">	
		&nbsp;<button class="btn btn-primary col-md-2 pull-left" type="button" id="lookup_idenfifiers"><fmt:message key="jsp.submit.start-lookup-submission.identifier.lookup"/></button>
	</div>
	</div>
<% 
		
	} %>


    		<div class="col-md-4 pull-right btn-group">
                <input class="btn btn-default col-md-6" type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>" value="<fmt:message key="jsp.submit.edit-metadata.cancelsave"/>"/>
				<input class="btn btn-primary col-md-6" type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" value="<fmt:message key="jsp.submit.edit-metadata.next"/>"/>
    		</div><br/>
	</form>

</dspace:layout>
