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

<table class="floatTables" style="border:1px solid #CCCCCC;">
    <tr><td colspan="2"><center><b>Hardware Information</b></center></td></tr>
    <tr>
        <td valign="top" class="name">Serial Number</td>
        <td valign="top" class="value">
            <input type='text' value="{{server.serialNo}}" />
        </td>
    </tr>
    <tr>
        <td valign="top" class="name">Customer Service ID</td>
        <td valign="top" class="value">
            <input type='text' value="{{server.CSI}}" />
        </td>
    </tr>
    <tr>
        <td valign="top" class="name">Decal No</td>
        <td valign="top" class="value">
            <input type='text' value="{{server.decalNo}}" />
        </td>
    </tr>
    <tr>
        <td valign="top" class="name">Is Available for Parts</td>
        <td valign="top" class="value">
            <input type="checkbox" class="completed-chk"><%=completed?checked: ''%>
    </tr>
    <tr>
        <td valign="top" class="name">Post Migration Status</td>
        <td valign="top" class="value">
            <input type='text' value="{{server.postMigrationStatus}}" />
        </td>
    </tr>
    <tr>
        <td valign="top" class="name">Last Updated</td>
        <td valign="top" class="value">
            <input type='text' value="{{server.lastUpdated}}" />
        </td>
    </tr>
</table>
