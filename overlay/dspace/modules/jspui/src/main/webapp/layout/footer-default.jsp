<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Footer for home page
  --%

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%
    String sidebar = (String) request.getAttribute("dspace.layout.sidebar");
%>

<%-- Right-hand side bar if appropriate --%
<%
    if (sidebar != null)
    {
%>

<div class="col-md-3">
    <%= sidebar %>
</div>

<%
    }
%>
</div>
<%-- Page footer --%
<footer>

    <p style="border-top: 1px solid #ccc;"></p>


    <section>
        <nav id="footernav">
            <ul>
                <li>
                </li>
                <li>
                    <a href="/arizona/feedback">Feedback</a>
                    &nbsp;|&nbsp;  </li>
                <li>
                    <script type="text/javascript">
                        document.write('<a href="#" class="null" onClick="var popupwin = window.open(\'/arizona/help/index.jsp\',\'dspacepopup\',\'height=600,width=550,resizable,scrollbars\');popupwin.focus();return false;">Help</a>');
                    </script>
                    <noscript><a href="/arizona/help/index.jsp" target="dspacepopup" class="null">Help</a></noscript>
                    &nbsp;|&nbsp; </li>
                <li>
                    <a href="/arizona/pages/contacts.html">Contact</a>
                </li>
            </ul>
        </nav>
        <br>

        <p>The University of Arizona Libraries | 1510 E. University Blvd. | Tucson, AZ 85721-0055 | Tel 520-621-6442</p>

        <p><a href="mailto:repository@u.library.arizona.edu">repository@u.library.arizona.edu</a></p>

    </section>

</footer>

<footer class="bottomFooter">
    <section>
        <p>UA Campus Repository is based on and contributes to <a href="http://www.dspace.org/"
                                                             title="DSpace - open source digital repositories">DSpace</a>
            the open source tool for the management of digital assets</p>
    </section>
</footer>

</body>
</html>







<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Footer for home page


<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%
    String sidebar = (String) request.getAttribute("dspace.layout.sidebar");
%>

            <%-- Right-hand side bar if appropriate -
<%
    if (sidebar != null)
    {
%>
	</div>
	<div class="col-md-3">
                    <%= sidebar %>
    </div>
    </div>       
<%
    }
%>
</div>
</main>
<footer>

    <p style="border-top: 1px solid #ccc;"></p>


    <section>


        <nav id="footernav">

            <ul>
                <li>

                    <script type="text/javascript" src="/arizona/loading.js.jsp"></script>
                    <form id="statsform" method="get" action="/arizona/displaygastats" onsubmit="displayLoadingDialog();">

                        <a href="#" onclick="jQuery('#statsform').submit()">Site Statistics&nbsp;&nbsp;|&nbsp;</a>
                    </form>



                </li>
                <li>
                    <a href="/arizona/feedback">Feedback</a>
                    &nbsp;|&nbsp;  </li>


                <li>
                    <script type="text/javascript">
                        document.write('<a href="#" class="null" onClick="var popupwin = window.open(\'/arizona/help/index.jsp\',\'dspacepopup\',\'height=600,width=550,resizable,scrollbars\');popupwin.focus();return false;">Help</a>');
                    </script>
                    <noscript><a href="/arizona/help/index.jsp" target="dspacepopup" class="null">Help</a></noscript>
                    &nbsp;|&nbsp; </li>
                <li>
                    <a href="/arizona/pages/contacts.html">Contact</a>
                </li>


            </ul>
        </nav>
        <br>


        <p>The University of Arizona Libraries | 1510 E. University Blvd. | Tucson, AZ 85721-0055 | Tel 520-621-6442</p>

        <p><a href="mailto:repository@u.library.arizona.edu">repository@u.library.arizona.edu</a></p>



    </section>

</footer>

<footer class="bottomFooter">
    <section>
        <p><a href="/arizona/">UA Campus Repository</a> is
            powered by <a href="http://new.library.arizona.edu/about/organization" target="_blank"><img id="orLogo"
                                                                                     src="/arizona/img/logo.png"></a>
        </p>

        <p>University of Arizona Libraries Open Repository operates on and contributes to <a href="http://www.dspace.org/"
                                                             title="DSpace - open source digital repositories">DSpace</a>
            the open source tool for the management of digital assets</p>
    </section>
    <div class="smallinfo"><a href="http://www.biomedcentral.com/about/cookies" target="blank">Cookies</a></div>
</footer>

    </body>
</html>

--%>


<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Footer for home page
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%
    String sidebar = (String) request.getAttribute("dspace.layout.sidebar");
%>

<%-- Right-hand side bar if appropriate --%>
<%
    if (sidebar != null)
    {
%>
</div>
<div class="col-md-3">
    <%= sidebar %>
</div>
</div>
<%
    }
%>

</div>
</main>
<%-- Page footer --%>
<footer>
    <p style="border-top: 1px solid #ccc;"></p>
    <section>
        <nav id="footernav">
            <ul>
                <%-- Form for Statistics, TO DO: purchase from Atmire TBD. This code will need updating once a decision is made to show it in the footer
                <li>

                    <script type="text/javascript" src="<%= request.getContextPath() %>/loading.js.jsp"></script>
                    <form id="statsform" method="get" action="<%= request.getContextPath() %>/displaygastats" onsubmit="displayLoadingDialog();">

                        <a href="#" onclick="jQuery('#statsform').submit()">Site Statistics&nbsp;&nbsp;|&nbsp;</a>
                    </form>
                    --%>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/feedback">Feedback</a>
                    &nbsp;|&nbsp;  </li>
                <li>
                    <%--<script type="text/javascript">
                        document.write('<a href="#" class="null" onClick="var popupwin = window.open(\'/help/index.jsp\',\'dspacepopup\',\'height=600,width=550,resizable,scrollbars\');popupwin.focus();return false;">Help</a>');
                    </script>--%>
                    <noscript><a href="<%= request.getContextPath() %>/help/index.jsp" target="dspacepopup" class="null">Help</a></noscript>
                    &nbsp;|&nbsp; </li>
                <li>
                    <a href="<%= request.getContextPath() %>/pages/contacts.html">Contact</a>
                </li>
            </ul>
        </nav>
        <br>
        <p>The University of Arizona Libraries | 1510 E. University Blvd. | Tucson, AZ 85721-0055 | Tel 520-621-6442</p>
        <p><a href="mailto:repository@u.library.arizona.edu">repository@u.library.arizona.edu</a></p>
    </section>
</footer>

<footer class="bottomFooter">
    <section>
        <p>UA Campus Repository operates on and contributes to <a href="http://www.dspace.org/" title="DSpace - open source digital repositories">DSpace</a> the open source tool for the management of digital assets</p>
    </section>
</footer>

</body>
</html>