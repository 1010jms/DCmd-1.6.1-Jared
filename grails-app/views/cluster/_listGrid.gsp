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

<script type="text/javascript">

$(document).ready(function() {
    $( "#cluster_dialog" ).dialog({
        autoOpen: false,
        width: 800,
        height: 600,
        show: {
            effect: "blind",
            duration: 1000
        },
        hide: {
            effect: "blind",
            duration: 1000
        }
    });

    var fixPositionsOfFrozenDivs = function () {
        var grid = this.grid || this;
        var $rows;
        if (typeof grid.fbDiv !== "undefined") {
            $rows = $('>div>table.ui-jqgrid-btable>tbody>tr', grid.bDiv);
            $('>table.ui-jqgrid-btable>tbody>tr', grid.fbDiv).each(function (i) {
                var rowHight = $($rows[i]).height(), rowHightFrozen = $(this).height();
                if ($(this).hasClass("jqgrow")) {
                    $(this).height(rowHight);
                    rowHightFrozen = $(this).height()+0.2;
                    if (rowHight !== rowHightFrozen) {
                        $(this).height(rowHight + (rowHight - rowHightFrozen));
                    }
                }
            });
            $(grid.fbDiv).height(grid.bDiv.clientHeight);
            $(grid.fbDiv).css($(grid.bDiv).position());
        }
        if (typeof grid.fhDiv !== "undefined") {
            $rows = $('>div>table.ui-jqgrid-htable>thead>tr', grid.hDiv);
            $('>table.ui-jqgrid-htable>thead>tr', grid.fhDiv).each(function (i) {
                var rowHight = $($rows[i]).height(), rowHightFrozen = $(this).height();
                $(this).height(rowHight);
                rowHightFrozen = $(this).height();
                if (rowHight !== rowHightFrozen) {
                    $(this).height(rowHight + (rowHight - rowHightFrozen));
                }
            });
            $(grid.fhDiv).height(grid.hDiv.clientHeight);
            $(grid.fhDiv).css($(grid.hDiv).position());
        }
    };

jQuery("#allCluster").jqGrid({

height:'auto',
width:'1000',
//caption:'Cluster List',
url:'listAllCluster',
            datatype: "json",
            colNames:['Cluster Name', '# of Servers', '# of Hosts', 'Last Updated', 'Notes', 'id'],
            colModel:[
                {name:'name', editable:false,/* formatter: 'showlink', formatoptions: {showAction:'show'},*/title:false},
                {name:'numServers', editable:false, width:50,title:false, search:false, sortable:false},
                {name:'numHosts', editable:false,width:50, title:false, search:false, sortable:false},
                {name:'lastUpdated', editable:false, width: 100,title:false, search:false},
                {name:'generalNote', width:'400', editable:false,title:false},
                {name:'id', hidden:true}
            ],

    sortname: 'name',
    sortorder: 'asc',
    rowNum: 50,
    rowList: [10, 20, 50, 100],

    gridview: true,
    viewrecords: true,
    autowidth:true,
    shrinkToFit: true,
    searchOnEnter:true,
    pager: '#allClusterPager',
    scrollOffset:0,
    toolbar:[true, 'top'],
    gridComplete: function() {
        dynamicListSize("#allCluster");
    },
    loadComplete: function() {
        fixPositionsOfFrozenDivs.call(this);
    },
    resizeStop: function() {
        fixPositionsOfFrozenDivs.call(this);
    }


});

    jQuery('#allCluster').filterToolbar({id:'allCluster', searchOnEnter:true});
    jQuery('#allCluster').jqGrid('setFrozenColumns');
    
        jQuery('#allCluster').filterToolbar({id:'allCluster', searchOnEnter:true});
        $("#allCluster").jqGrid('navGrid','#allClusterPager',{
                add:false,
                del:false,
                edit:false,
                refresh:false,
                refreshstate:"current",
                search:false
        },
        {},//edit options

        {recreateForm:true //since clearAfterAdd is trueby default, recreate the form so we re-establish value for parent id
        });

    createTopToolbar("#allCluster");

    var setTooltipsOnColumnHeader = function (grid, iColumn, text) {
        var thd = jQuery("thead:first", grid[0].grid.hDiv)[0];
        jQuery("tr.ui-jqgrid-labels th:eq(" + iColumn + ")", thd).attr("title", text);
    };

    setTooltipsOnColumnHeader($("#allCluster"),0,"Name of Cluster");
    setTooltipsOnColumnHeader($("#allCluster"),1,"Number of Physical Servers making up the Cluster");
    setTooltipsOnColumnHeader($("#allCluster"),2,"Number of Virtual Hosts running on the Cluster");
    setTooltipsOnColumnHeader($("#allCluster"),3,"Last time the Cluster information was updated");



    jQuery(window).bind('resize', function() {
        dynamicListSize('#allCluster');
    }).trigger('resize');

    });

</script>
<table id="allCluster"></table>
<div id="allClusterPager"></div>

