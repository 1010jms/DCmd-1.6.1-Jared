
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

<%@ page import="edu.hawaii.its.dcmd.inf.Person" %>
<html>
    <head>
        <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:'its_favicon.ico')}" type="image/x-icon" />
        <meta content="main" name="layout" />
        <g:set var="entityName" value="${message(code: 'person.label', default: 'Staff')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        <jqDT:resources jqueryUi="true" type="js" />

      %{--pop up for row select--}%
        <style>
        .toggler { width: 500px; height: 200px; position: absolute}
        #button { padding: .5em 1em; text-decoration: none; }
        #effect { width: 240px; height: 135px; padding: 0.4em; position: absolute; float: left }
        #effect h3 { margin: 0; padding: 0.4em; text-align: center; }
        </style>



    <script>
        //call ldap update function
            ${remoteFunction(
                controller: 'Person',
                action:'updatePersonsWithLDAP'
        )}

            $(function() {
// run the currently selected effect
                $( "#effect" ).draggable();

                function runEffect() {
// run the effect
                    $( "#effect" ).show( "fold", 1000, callback);
                };
//callback function to bring a hidden box back
                function callback() {
                    setTimeout(function() {
                        $( "#effect:visible" ).removeAttr( "style" ).fadeOut();
                    }, 10000 );
                };
// set effect from select menu value
            //    $( "#button" ).click(function() {
                    $( "#button" ).click(function() {
                    runEffect();
                    return false;
                });
                $( "#effect" ).hide();
            });

            </script>


        <g:applyLayout name="breadcrumb_bar">
            <g:include controller="person" action="setBreadCrumbForCurrentItem" params="[pageType: 'person']"/>
        </g:applyLayout>

    </head>
    <body>

    <script src="../js/underscore.js"></script>
    <script src="../js/backbone.js"></script>
    <script src="../js/handlebars.js"></script>

    <div id="container" >
          <g:render template="../show_secondary" model="[pageType:'person', objectId:0, action:'list']" />
          <g:render template="../breadcrumbs" model="[pageType:'person', action:'list']"/>

    </div>

    <div class="pageBody"  id="outerElement">

        <g:render template="../toolTip" />

        <g:render template="listAttributes"/>
        <g:render template="gridAttributes"/>

        <g:render template="../advancedOptions" model="[pageType:'person', gridId:'#allPerson', export:true, exportAction:'exportListAll', hostFilter:true]" />

        <table id="allPerson"></table>
        <div id="allPersonPager"></div>

        <g:render template="details"/>

        <div id="person_dialog" title="Staff Details">
            <div id="person_attributes"></div>
          %{--  <g:render template="popup-tabs"/> --}%
        </div>

            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>

        </div>

    </body>
</html>
