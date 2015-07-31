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
var ServerHost = Backbone.Model.extend();
var ServerHosts = Backbone.Collection.extend({
    url:'../host/getHostsByServer',
    model: ServerHost
});

var ServerTechnicalSupportStaff = Backbone.Model.extend();
var ServerTechnicalSupportStaffs = Backbone.Collection.extend({
    url:'../person/getPersonIdByServer',
    model: ServerTechnicalSupportStaff
});

var ServerFunctionalSupportStaff = Backbone.Model.extend();
var ServerFunctionalSupportStaffs = Backbone.Collection.extend({
    url:'../person/getPersonIdByServer',
    model: ServerFunctionalSupportStaff
});

var ServerType = Backbone.Model.extend({
    defaults: function() {
        return {
            selected: ""
        };
    }
});

var ServerTypes = Backbone.Collection.extend({
    url:'../physicalServer/getServerTypes',
    model: ServerType,
    initialize: function() {
        this.fetch();
    }
});

var serverTypes = new ServerTypes();

var PhyServer = Backbone.Model.extend({
    url:'/its/dcmd/physicalServer/getServerDetails',

    initialize: function() {
        this.set('hostList', new ServerHosts);
        this.set('technicalSupportStaffList', new ServerTechnicalSupportStaffs);
        this.set('functionalSupportStaffList', new ServerFunctionalSupportStaffs);
    },
    defaults: function() {
        return {
            itsId: 'empty'
        };
    },
    saveData: function() {

    }
});
var theServer = new PhyServer();

var Asset = Backbone.Model.extend({
    url:'/its/dcmd/physicalServer/getAssetDetails',

    initialize: function() {
        this.set('hostList', new ServerHosts);
    },
    defaults: function() {
        return {
            itsId: 'empty'
        };
    },
    saveData: function() {

    }
});
var theAsset = new Asset();

var Person = Backbone.Model.extend({
    url:'/its/dcmd/Person/getPersonIdFromRoleId',

    initialize: function() {
        this.set('technicalSupportStaffList', new ServerTechnicalSupportStaffs);
        this.set('functionalSupportStaffList', new ServerFunctionalSupportStaffs);
    },
    defaults: function() {
        return {
            itsId: 'empty'
        };
    },
    saveData: function() {

    }
});
var thePerson = new Person();


var template;

var ServerView = Backbone.View.extend({

    model: theServer,

//            template: _.template($("#server_template").html()),
//            el: $("#server_dialog"),

    events: {
        "click #unlock": "unlockAll",
        "click #lock": "lockAll",
        "click .discard": "discardChanges"
    },

    initialize: function () {
        _.bindAll(this, 'render', 'unlockAll', 'lockAll', 'discardChanges', 'loadData', 'renderHostGrid', 'renderTechnicalSupportStaffGrid', 'renderFunctionalSupportStaffGrid');
        template = Handlebars.compile($("#server_template").html());
        //    this.model.on("change", this.render);
    },

    render: function() {
        var context = {server:this.model.toJSON(),sTypes:serverTypes.toJSON(), clusterList:clusters.toJSON()};

        this.$el.html(template(context));

        // Set all dropdowns to SELECT2 and set their values
        $('.value select').each(function() {
            var attribute = $(this).context.id;
            var selectedVal;
            switch(attribute) {
                case 'cluster':
                    selectedVal = theServer.attributes[attribute].id;
                    break;
                default:
                    selectedVal = theServer.attributes[attribute];
            }
            $(this).select2({
                width:150
            }).select2('val', selectedVal);
        });

        // Set everything to initially locked
        $('.value input[type="text"]').prop("disabled", true);
        $('.value select').prop("disabled", true);

        return this;
    },

    unlockAll: function() {
        this.$el.addClass('editing');
        $('.value input[type="text"]').prop("disabled", false);
        $('.value select').prop("disabled",false);
//                this.render();
    },
    lockAll: function() {
        this.$el.removeClass('editing');
//                console.log($('.value input[type="text"]'));
        $('.value input[type="text"]').prop("disabled", true);
        $('.value select').prop("disabled", true);
        //    console.log(this.$el.('input[type="text"] .edit'));
        //    this.render();
    },
    discardChanges: function() {
    },
    loadData: function(serverId) {
        this.model.fetch({data: $.param({serverId:serverId}), success: this.render});
        this.model.attributes.hostList.fetch({data: $.param({serverId:serverId}), success:this.renderHostGrid});
        this.model.attributes.technicalSupportStaffList.fetch({data: $.param({serverId:serverId}), success:this.renderTechnicalSupportStaffGrid()});
        this.model.attributes.functionalSupportStaffList.fetch({data: $.param({serverId:serverId}), success:this.renderFunctionalSupportStaffGrid()});
    },
    renderHostGrid: function() {
        console.log(this.model.attributes.hostList.toJSON());
        $("#hostsList").GridUnload();
        jQuery("#hostsList").jqGrid({
            height:'auto',
            autowidth:true,
            datatype: 'local',
            data:this.model.attributes.hostList.toJSON(),
            width:'100%',
            colNames:['Hostname', 'Status', 'Environment', 'Host SA', 'Max Memory', 'Max CPU'],
            colModel:[  {name:'Hostname', align:'left'},
                {name:'status', align:'left'},
                {name:'env', align:'left'},
                {name:'primarySA', align:'left'},
                {name:'maxMemory', align:'left'},
                {name:'maxCPU', align:'left'}],
            loadComplete : function(data) {
                //alert('grid loading completed ' + data);
            },
            loadError : function(xhr, status, error) {
                alert('grid loading error' + error);
            }
        });
    },

    renderTechnicalSupportStaffGrid: function(){
        console.log(this.model.attributes.technicalSupportStaffList.toJSON());
        $("#technicalSupportStaffLists").GridUnload();
        jQuery("#technicalSupportStaffLists").jqGrid({
            height:'auto',
            autowidth:true,
            datatype: 'local',
            data:this.model.attributes.technicalSupportStaffList.toJSON(),
            width:'100%',
            colNames:['Role', 'Person', 'E-Mail', 'Phone', 'Notes'],
            colModel:[
                {name:'roleName', align:'left'},
                {name:"person", align:'left'},
                {name:'email', align:'left'},
                {name:'phone', align:'left'},
                {name:'supportRoleNotes', align:'left'}],
            loadComplete : function(data) {
                //alert('grid loading completed ' + data);
            },
            loadError : function(xhr, status, error) {
                alert('grid loading error' + error);
            }
        });
    },

    renderFunctionalSupportStaffGrid: function(){
        console.log(this.model.attributes.functionalSupportStaffList.toJSON());
        $("#functionalSupportStaffLists").GridUnload();
        jQuery("#functionalSupportStaffLists").jqGrid({
            height:'auto',
            autowidth:true,
            datatype: 'local',
            data:this.model.attributes.functionalSupportStaffList.toJSON(),
            width:'100%',
            colNames:['', 'Role', 'Person', 'E-Mail', 'Phone', 'Notes', 'id'],
            colModel:[
                {name:'actions', index:'actions', align:'left'},
                {name:'roleName', align:'left'},
                {name:"person", align:'left'},
                {name:'email', align:'left'},
                {name:'phone', align:'left'},
                {name:'supportRoleNotes',align:'left'},
                {name:'id', hidden:true}
            ],
            loadComplete : function(data) {
                //alert('grid loading completed ' + data);
            },
            loadError : function(xhr, status, error) {
                alert('grid loading error' + error);
            }
        });
    }
});

var openServer = function(serverId) {
    var serverView = new ServerView({ el: $("#server_attributes") });
    serverView.loadData(serverId);
    $("#server_dialog").dialog("open");
    //   console.log(test.toJSON());
};

</script>