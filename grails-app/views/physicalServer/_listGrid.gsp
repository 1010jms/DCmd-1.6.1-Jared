
<script src="../js/underscore.js"></script>
<script src="../js/backbone.js"></script>
<script src="../js/handlebars.js"></script>

<g:render template="listAttributes"/>
<g:render template="gridAttributes" />

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

<g:render template="../advancedOptions" model="[pageType:'physicalServer', gridId:'#allPhyServer', export:true, exportAction:'exportListAll', hostFilter:true]" />

<table id="allPhyServer"></table>
<div id="allServerPager"></div>


<g:render template="details"/>
<div id="server_dialog" title="Server Details">
    <div id="server_attributes"></div>
    <g:render template="popup-tabs"/>

</div>
%{--
<script type="text/javascript">
   function testExtern() {
       jQuery.ajax({
           async: false,
           url: '/its/dcmd/physicalServer/testExtern',
           type:'POST',
           dataType:'json',
           contentType: 'application/json; charset=utf-8',
           success: function(data) {
               alert(data);
           },
           error: function () { alert('Error retrieving elog info'); }
       });
   }
</script>

%{--<input type="button" value="test" onclick="testExtern()"/> --}%