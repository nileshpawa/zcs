<%@ tag body-content="empty" %>
<%@ attribute name="rule" rtexprvalue="true" required="true" type="com.zimbra.cs.zclient.ZFilterRule" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="zm" uri="com.zimbra.zm" %>
<%@ taglib prefix="app" uri="com.zimbra.htmlclient" %>

<table cellspacing=3 cellpadding=3>
    <tr>
        <td valign='center'><fmt:message key="filterName"/> :</td>
        <td>
            <c:choose>
                <c:when test="${not empty param.rulename}">
                    <c:set var="rulename" value="${param.rulename}"/>
                </c:when>
                <c:when test="${empty rule}">
                    <c:set var="rulename" value=""/>
                </c:when>
                <c:otherwise>
                    <c:set var="rulename" value="${rule.name}"/>
                </c:otherwise>
            </c:choose>
            <input name='rulename' type='text' autocomplete='off' size='20' value="${fn:escapeXml(rulename)}">
        </td>
    </tr>
</table>

<table border="0" cellspacing="3" cellpadding="3">
<tbody>
    <tr>
        <td><fmt:message key="EFILT_ALLCOND_PRE"/></td>
        <td>
            <select name="allof">
                <option <c:if test="${rule.allConditions}">selected</c:if> value="IN"><fmt:message key="EFILT_all"/>
                <option <c:if test="${not rule.allConditions}">selected</c:if> value="IN"><fmt:message key="EFILT_any"/>
            </select>
        </td>
        <td><fmt:message key="EFILT_ALLCOND_POST"/></td>
    </tr>
</tbody>
</table>
<table border="0" cellspacing="3" cellpadding="3">
<tbody>
    <tr>
    <td width="5">&nbsp;</td>
    <td  class="ZhAppContent">
    <table border="0" cellspacing="0" cellpadding="5" class='RuleList' width=100%>
    <tbody>
        <c:forEach var="condition" items="${rule.conditions}">
            <tr>
            <c:choose>
                <c:when test="${zm:isAddressBook(condition)}">
                    <c:set var="ab" value="${zm:getAddressBook(condition)}"/>
                    <td>
                        <c:set var="selected" value="${ab.header}"/>
                                    <select name="abheader" style='width:100%'>
                                        <option <c:if test="${selected eq 'from'}">selected</c:if> value="from">
                                                <fmt:message key="EFILT_COND_addressIn"><fmt:param><fmt:message key="from"/></fmt:param></fmt:message>
                                        <option <c:if test="${selected eq 'to'}">selected</c:if> value="to">
                                            <fmt:message key="EFILT_COND_addressIn"><fmt:param><fmt:message key="to"/></fmt:param></fmt:message>
                                        <option <c:if test="${selected eq 'cc'}">selected</c:if> value="cc">
                                        <fmt:message key="EFILT_COND_addressIn"><fmt:param><fmt:message key="cc"/></fmt:param></fmt:message>
                                        <option <c:if test="${selected eq 'bcc'}">selected</c:if> value="bcc">
                                        <fmt:message key="EFILT_COND_addressIn"><fmt:param><fmt:message key="bcc"/></fmt:param></fmt:message>
                                </select>
                                </td>
                                <td colspan='3'>
                                    <select name="abheaderop">
                                        <option <c:if test="${ab.addressBookOp eq 'IN'}">selected</c:if> value="IN"><fmt:message key="EFILT_COND_ADDRESS_IN"/>
                                        <option <c:if test="${ab.addressBookOp eq 'NOT_IN'}">selected</c:if> value="NOT_IN"><fmt:message key="EFILT_COND_ADDRESS_NOT_IN"/>
                                    </select>
                                </td>
                </c:when>
                <c:when test="${zm:isSize(condition)}">
                    <c:set var="sz" value="${zm:getSize(condition)}"/>
                                <td>
                                    <select name="sizeop">
                                        <option <c:if test="${sz.sizeOp eq 'UNDER'}">selected</c:if> value="UNDER"><fmt:message key="EFILT_COND_SIZE_UNDER"/>
                                        <option <c:if test="${sz.sizeOp eq 'NOT_UNDER'}">selected</c:if> value="NOT_UNDER"><fmt:message key="EFILT_COND_SIZE_NOT_UNDER"/>
                                        <option <c:if test="${sz.sizeOp eq 'OVER'}">selected</c:if> value="OVER"><fmt:message key="EFILT_COND_SIZE_OVER"/>
                                        <option <c:if test="${sz.sizeOp eq 'NOT_OVER'}">selected</c:if> value="NOT_OVER"><fmt:message key="EFILT_COND_SIZE_NOT_OVER"/>
                                    </select>
                                </td>
                                <td colspan='3'>
                                     <input name='sizevalue' type='text' autocomplete='off' size='20' value="${fn:escapeXml(sz.size)}">
                                </td>
                </c:when>
                <c:when test="${zm:isBody(condition)}">
                    <c:set var="body" value="${zm:getBody(condition)}"/>
                                <td>
                                    <select name="bodyop">
                                        <option <c:if test="${body.bodyOp eq 'CONTAINS'}">selected</c:if> value="CONTAINS"><fmt:message key="EFILT_COND_BODY_CONTAINS"/>
                                        <option <c:if test="${body.bodyOp eq 'NOT_CONTAINS'}">selected</c:if> value="NOT_CONTAINS"><fmt:message key="EFILT_COND_BODY_NOT_CONTAINS"/>
                                    </select>
                                </td>
                                <td colspan='3'>
                                     <input name='bodyvalue' type='text' autocomplete='off' size='20' value="${fn:escapeXml(body.text)}">
                                </td>
                </c:when>
                <c:when test="${zm:isDate(condition)}">
                    <c:set var="date" value="${zm:getDate(condition)}"/>
                    <fmt:message var="dateFmt" key="FILT_COND_DATE_FORMAT"/>
                    <fmt:formatDate pattern="${dateFmt}" value="${date.date}" var="fdate"/>
                                <td>
                                    <select name="dateop">
                                        <option <c:if test="${date.dateOp eq 'BEFORE'}">selected</c:if> value="BEFORE"><fmt:message key="EFILT_COND_DATE_BEFORE"/>
                                        <option <c:if test="${date.dateOp eq 'NOT_BEFORE'}">selected</c:if> value="NOT_BEFORE"><fmt:message key="EFILT_COND_DATE_NOT_BEFORE"/>
                                        <option <c:if test="${date.dateOp eq 'AFTER'}">selected</c:if> value="BEFORE"><fmt:message key="EFILT_COND_DATE_AFTER"/>
                                        <option <c:if test="${date.dateOp eq 'NOT_AFTER'}">selected</c:if> value="NOT_BEFORE"><fmt:message key="EFILT_COND_DATE_NOT_AFTER"/>                                        
                                    </select>
                                </td>
                                <td colspan='3'>
                                     <input name='datevalue' type='text' autocomplete='off' size='20' value="${fn:escapeXml(fdate)}">
                                </td>
                </c:when>
                <c:when test="${zm:isHeader(condition)}">
                    <c:set var="hdr" value="${zm:getHeader(condition)}"/>
                    <c:choose>

                        <c:when test="${hdr.headerName eq 'subject' or hdr.headerName eq 'to' or hdr.headerName eq 'cc' or hdr.headerName eq 'from'}">
                            <c:set var="cspan" value="2"/>
                            <td>
                                <select name='headervalue'>
                                    <option <c:if test="${hdr.headerName eq 'subject'}">selected</c:if> value="subject"><fmt:message key="FILT_COND_HEADER_subject"/>
                                    <option <c:if test="${hdr.headerName eq 'to'}">selected</c:if> value="to"><fmt:message key="FILT_COND_HEADER_to"/>
                                    <option <c:if test="${hdr.headerName eq 'cc'}">selected</c:if> value="cc"><fmt:message key="FILT_COND_HEADER_cc"/>
                                    <option <c:if test="${hdr.headerName eq 'from'}">selected</c:if> value="from"><fmt:message key="FILT_COND_HEADER_from"/>
                                </select>
                            </td>                            
                        </c:when>
                        <c:otherwise>
                                <c:set var="cspan" value="1"/>
                                <td>
                                    <select name="headernamed">
                                        <option selected value="headernamed"><fmt:message key="EFILT_COND_HEADER_headerNamed"/>
                                    </select>
                                </td>
                                <td>
                                    <input name='headervalue' type='text' autocomplete='off' size='20' value="${fn:escapeXml(hdr.headerName)}">
                                </td>
                        </c:otherwise>
                    </c:choose>
                                <td colspan="${cspan}">
                                    <select name="headerop">
                                        <option <c:if test="${hdr.headerOp eq 'IS'}">selected</c:if> value="IS"><fmt:message key="EFILT_COND_HEADER_IS"/>
                                        <option <c:if test="${hdr.headerOp eq 'NOT_IS'}">selected</c:if> value="NOT_IS"><fmt:message key="EFILT_COND_HEADER_NOT_IS"/>
                                        <option <c:if test="${hdr.headerOp eq 'CONTAINS'}">selected</c:if> value="CONTAINS"><fmt:message key="EFILT_COND_HEADER_CONTAINS"/>
                                        <option <c:if test="${hdr.headerOp eq 'NOT_CONTAINS'}">selected</c:if> value="NOT_CONTAINS"><fmt:message key="EFILT_COND_HEADER_NOT_CONTAINS"/>
                                        <option <c:if test="${hdr.headerOp eq 'MATCHES'}">selected</c:if> value="MATCHES"><fmt:message key="EFILT_COND_HEADER_MATCHES"/>
                                        <option <c:if test="${hdr.headerOp eq 'NOT_MATCHES'}">selected</c:if> value="NOT_MATCHES"><fmt:message key="EFILT_COND_HEADER_NOT_MATCHES"/>
                                    </select>
                                </td>
                                <td>
                                    <input name='headervalue' type='text' autocomplete='off' size='20' value="${fn:escapeXml(hdr.headerValue)}">
                                </td>
                </c:when>
                <c:when test="${zm:isHeaderExists(condition)}">
                    <c:set var="hdrexists" value="${zm:getHeaderExists(condition)}"/>
                                <td>
                                    <select name="headerexistsop">
                                        <option <c:if test="${hdrexists.exists}">selected</c:if> value="EXISTS"><fmt:message key="EFILT_COND_HEADER_EXISTS"/>
                                        <option <c:if test="${not hdrexists.exists}">selected</c:if> value="NOT_EXISTS"><fmt:message key="EFILT_COND_HEADER_NOT_EXISTS"/>
                                    </select>
                                </td>
                                <td colspan='3'>
                                    <input name='headerexistsvalue' type='text' autocomplete='off' size='20' value="${fn:escapeXml(hdrexists.headerName)}">
                                </td>
                </c:when>
                <c:when test="${zm:isAttachmentExists(condition)}">
                    <c:set var="attach" value="${zm:getAttachmentExists(condition)}"/>
                                <td colspan='1'>
                                    <select name="attachop">
                                        <option <c:if test="${attach.exists}">selected</c:if> value="EXISTS"><fmt:message key="EFILT_COND_ATTACHMENT_EXISTS"/>
                                        <option <c:if test="${not attach.exists}">selected</c:if> value="NOT_EXISTS"><fmt:message key="EFILT_COND_ATTACHMENT_NOT_EXISTS"/>
                                    </select>
                                </td>
                                <td colspan='3'>&nbsp;
                                </td>
                </c:when>
            </c:choose>
                        <td>
                            <input class='tbButton' type="submit"
                                   name="actionRemoveCond" value="<fmt:message key="EFILT_COND_remove"/>">
                        </td>
            </tr>


            </c:forEach>
            <tr>
                <td colspan="1">
                    <select name="addcond">
                        <option value="from"><fmt:message key="EFILT_NEW_COND_FROM"/>
                        <option value="to"><fmt:message key="EFILT_NEW_COND_TO"/>
                        <option value="cc"><fmt:message key="EFILT_NEW_COND_CC"/>
                        <option value="subject"><fmt:message key="EFILT_NEW_COND_SUBJECT"/>
                        <option value="subject"><fmt:message key="EFILT_NEW_COND_HEADER"/>
                        <option value="subject"><fmt:message key="EFILT_NEW_COND_HEADER_EXISTS"/>
                        <option value="subject"><fmt:message key="EFILT_NEW_COND_SIZE"/>
                        <option value="subject"><fmt:message key="EFILT_NEW_COND_DATE"/>
                        <option value="subject"><fmt:message key="EFILT_NEW_COND_BODY"/>
                        <option value="subject"><fmt:message key="EFILT_NEW_COND_ATTACHMENT"/>
                        <option value="subject"><fmt:message key="EFILT_NEW_COND_ADDRESS_IN"/>                        
                    </select>
                </td>
                <td colspan=3>
                    &nbsp;
                </td>
                <td>
                    <input class='tbButton' type="submit"
                           name="actionNewCond" value="<fmt:message key="EFILT_COND_add"/>">
                </td>
            </tr>
            </tbody>
        </table>
        </td>
    </tr>
    <tr><td><br></td></tr>


    <tr><td colspan="4"><fmt:message key="performTheFollowingActions"/></td></tr>
    <tr>
        <td width="5">&nbsp;</td>
        <td valign="top" width="385" class="contactOutput">
            <c:forEach var="action" items="${rule.actions}">
                <c:choose>
                    <c:when test="${zm:isKeep(action)}">
                        <fmt:message key="FILT_ACTION_KEEP"/>
                    </c:when>
                </c:choose>
                <c:choose>
                    <c:when test="${zm:isDiscard(action)}">
                        <fmt:message key="FILT_ACTION_DISCARD"/>
                    </c:when>
                </c:choose>
                <c:choose>
                    <c:when test="${zm:isStop(action)}">
                        <fmt:message key="FILT_ACTION_STOP"/>
                    </c:when>
                </c:choose>
                <c:choose>
                    <c:when test="${zm:isFileInto(action)}">
                        <c:set var="fileInto" value="${zm:getFileInto(action)}"/>
                        <fmt:message key="FILT_ACTION_FILEINTO">
                            <fmt:param>${fileInto.folderPath}</fmt:param>
                        </fmt:message>
                    </c:when>
                </c:choose>
                <c:choose>
                    <c:when test="${zm:isTag(action)}">
                        <c:set var="tag" value="${zm:getTag(action)}"/>
                        <fmt:message key="FILT_ACTION_TAG">
                            <fmt:param>${tag.tagName}</fmt:param>
                        </fmt:message>
                    </c:when>
                </c:choose>
                <c:choose>
                    <c:when test="${zm:isRedirect(action)}">
                        <c:set var="redirect" value="${zm:getRedirect(action)}"/>
                        <fmt:message key="FILT_ACTION_REDIRECT">
                            <fmt:param>${redirect.address}</fmt:param>
                        </fmt:message>
                    </c:when>
                </c:choose>
                <c:choose>
                    <c:when test="${zm:isFlag(action)}">
                        <c:set var="flag" value="${zm:getFlag(action)}"/>
                        <fmt:message key="FILT_ACTION_FLAG_${flag.flagOp}"/>
                    </c:when>
                </c:choose>
                <br>
            </c:forEach>
        </td>
    </tr>
    <tr>
        <td><br></td>
    </tr>
</tbody>
</table>

