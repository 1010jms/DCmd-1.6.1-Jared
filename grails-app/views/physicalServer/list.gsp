
%{--
  - Copyright (c) 2014 University of Hawaii
  -
  - This file is part of DataCenter metadata (DCmd) project.
  -
  - DCmd is free software: you can redistribute it and/or modify
  - it under the terms of the GNU General Public License as published by
  - the Free Software Foundation, either version 3 of the License, or
  - (at your option) any later version.
  -
  - DCmd is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU General Public License
  - along with DCmd.  It is contained in the DCmd release as LICENSE.txt
  - If not, see <http://www.gnu.org/licenses/>.
  --}%

<%@ page import="edu.hawaii.its.dcmd.inf.PhysicalServer" %>
<html>
<head>
    <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:'its_favicon.ico')}" type="image/x-icon" />
    <meta content="main" name="layout" />
    <g:set var="entityName" value="${message(code: 'host.label', default: 'PhysicalServer')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
    <jqDT:resources jqueryUi="true" type="js" />

    <script language="javascript" type="text/javascript" src="../js/mustache.js"></script>

    <g:applyLayout name="breadcrumb_bar">
        <g:include controller="person" action="setBreadCrumbForCurrentItem" params="[pageType: 'physicalServer', instance :physicalServerInstance]"/>
    </g:applyLayout>


</head>
<body>

<script src="../js/underscore.js"></script>
<script src="../js/backbone.js"></script>
<script src="../js/handlebars.js"></script>

<div id="container">
    <g:render template="../show_secondary" model="[pageType:'physicalServer', objectId:0, action:'list']" />
    <g:render template="../breadcrumbs" model="[pageType:'physicalServer', action:'list']"/>
</div>
<div class="pageBody" id="outerElement">
    <g:render template="../toolTip" />

    <g:render template="listAttributes"/>
    <g:render template="gridAttributes"/>

    <g:render template="../advancedOptions" model="[pageType:'physicalServer', gridId:'#allPhyServer', export:true, exportAction:'exportListAll', hostFilter:true]" />

    <table id="allPhyServer"></table>
    <div id="allServerPager"></div>

    <g:render template="details"/>

    <div id="server_dialog" title="Server Details">
        <div id="server_attributes"></div>
        <g:render template="popup-tabs"/>
    </div>
</div>

</body>
</html>
