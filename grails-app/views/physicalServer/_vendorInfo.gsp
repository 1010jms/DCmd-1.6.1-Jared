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
    <tr><td colspan="2"><center><b>Vendor Information</b></center></td></tr>
    <tr>
        <td valign="top" class="name">Vendor</td>
        <td valign="top" class="value">
            <input type='text' value="{{server.vendor}}" />
        </td>
    </tr>
    <tr>
        <td valign="top" class="name">Model Designation</td>
        <td valign="top" class="value">
            <input type='text' value="{{server.modelDesignation}}" />
        </td>
    </tr>
    <tr>
        <td valign="top" class="name">Product Description</td>
        <td valign="top" class="value">
            <input type='text' value="{{server.productDescription}}" />
        </td>
    </tr>
    <tr>
        <td valign="top" class="name">Ownership Type</td>
        <td valign="top" class="value">
            <input type='text' value="{{server.ownershipType}}" />
        </td>
    </tr>
    <tr>
        <td valign="top" class="name">Support Level</td>
        <td valign="top" class="value">
            <input type='text' value="{{server.supportLevel}}" />
        </td>
    </tr>
    <tr>
        <td valign="top" class="name">Vendor Support Level</td>
        <td valign="top" class="value">
            <input type='text' value="{{server.vendorSupportLevel}}" />
        </td>
    </tr>
</table>

