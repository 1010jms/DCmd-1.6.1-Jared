<%--
  Created by IntelliJ IDEA.
  User: Ben
  Date: 2/27/2015
  Time: 2:00 PM
--%>
<div id="tabs" style="margin-top: 5px">

    <ul>
       %{-- <li>
            <a href="#tabs-service">Services</a>
        </li> --}%
        <li>
            <a href="#tabs-technical"><g:message code="asset.technicalsupportStaff.label" default="Technical Support Staff" /></a>
        </li>
        <li>
            <a href="#tabs-functional"><g:message code="asset.technicalsupportStaff.label" default="Functional Support Staff" /></a>
        </li>
        <li>
            <a href="#tabs-notes"><g:message code="notes.label" default="Notes" /></a>
        </li>
    </ul>

   %{-- <div id="tabs-service">
        <table id="serviceLists"></table>
    </div> --}%
    <div id="tabs-technical">
        <table id="technicalSupportStaffLists"></table>
    </div>

    <div id="tabs-functional">
        <table id="functionalSupportStaffLists"></table>
    </div>

    <div id="tabs-notes"></div>
</div>