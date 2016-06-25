<%@ include file="/html/init.jsp"%>

<%
	long guestbookId = (Long) renderRequest.getAttribute("guestbookId");
%>

<liferay-portlet:renderURL varImpl="searchURL">
	<portlet:param name="mvcPath" value="/html/guestbook/view_search.jsp" />
</liferay-portlet:renderURL>

<aui:form action="<%=searchURL%>" method="get" name="fm">
	<liferay-portlet:renderURLParams varImpl="searchURL" />

	<div class="search-form">
		<span class="aui-search-bar">
			<aui:input inlineField="true" label="" name="keywords" size="30" title="search-entries" type="text" />
			<aui:button type="submit" value="search" />
		</span>
	</div>
</aui:form>

<aui:nav cssClass="nav-tabs">

	<%
		List<Guestbook> guestbooks = GuestbookLocalServiceUtil.getGuestbooks(scopeGroupId);
			for (Guestbook curGuestbook : guestbooks) {
				String cssClass = StringPool.BLANK;

				if (curGuestbook.getGuestbookId() == guestbookId) {
					cssClass = "active";
				}

				if (GuestbookPermission.contains(permissionChecker, curGuestbook.getGuestbookId(), "VIEW")) {
	%>

	<portlet:renderURL var="viewPageURL">
		<portlet:param name="mvcPath" value="/html/guestbook/view.jsp" />
		<portlet:param name="guestbookId" value="<%=String.valueOf(curGuestbook.getGuestbookId())%>" />
	</portlet:renderURL>

	<aui:nav-item cssClass="<%=cssClass%>" href="<%=viewPageURL%>" label="<%=HtmlUtil.escape(curGuestbook.getName())%>">
	</aui:nav-item>

	<%
		}
			}
	%>

</aui:nav>

<aui:button-row>

	<portlet:renderURL var="addGuestbookURL">
		<portlet:param name="mvcPath" value="/html/guestbook/edit_guestbook.jsp" />
	</portlet:renderURL>

	<portlet:renderURL var="addEntryURL">
		<portlet:param name="mvcPath" value="/html/guestbook/edit_entry.jsp" />
		<portlet:param name="guestbookId" value="<%=String.valueOf(guestbookId)%>" />
	</portlet:renderURL>

	<c:if test='<%=GuestbookModelPermission.contains(permissionChecker, scopeGroupId, "ADD_GUESTBOOK")%>'>
		<aui:button onClick="<%= addGuestbookURL.toString() %>" value="Add Guestbook" />
	</c:if>
	<c:if test='<%=GuestbookPermission.contains(permissionChecker, guestbookId, "ADD_ENTRY")%>'>
		<aui:button onClick="<%= addEntryURL.toString() %>" value="Add Entry" />
	</c:if>

</aui:button-row>

<liferay-ui:search-container>
	<liferay-ui:search-container-results results="<%=EntryLocalServiceUtil.getEntries(scopeGroupId, guestbookId, searchContainer.getStart(),searchContainer.getEnd())%>" total="<%=EntryLocalServiceUtil.getEntriesCount()%>" />
	<liferay-ui:search-container-row className="com.liferay.docs.guestbook.model.Entry" modelVar="entry">

		<liferay-ui:search-container-column-text property="message" />

		<liferay-ui:search-container-column-text property="name" />

		<liferay-ui:search-container-column-jsp path="/html/guestbook/guestbook_actions.jsp" align="right" />

	</liferay-ui:search-container-row>

	<liferay-ui:search-iterator />
</liferay-ui:search-container>