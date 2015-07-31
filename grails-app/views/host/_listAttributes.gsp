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

   /* var Service = Backbone.Model.extend();
    var Services = Backbone.Collection.extend({
        url:'../tier/getTiersByHost',
        model: Service
    });*/

    var HostTechnicalSupportStaff = Backbone.Model.extend();
     var HostTechnicalSupportStaffs = Backbone.Collection.extend({
     url:'../person/getPersonIdByHost',
     model: HostTechnicalSupportStaff
     });

     var HostFunctionalSupportStaff = Backbone.Model.extend();
     var HostFunctionalSupportStaffs = Backbone.Collection.extend({
     url:'../person/getPersonIdByHost',
     model: HostFunctionalSupportStaff
     });

    var Host = Backbone.Model.extend({
        url:'/its/dcmd/host/getHostDetails',

        initialize: function() {
         // this.set('serviceList', new Services);
          this.set('technicalSupportStaffList', new HostTechnicalSupportStaffs);
          this.set('functionalSupportStaffList', new HostFunctionalSupportStaffs);
         },
        defaults: function() {
             return {
               hostname: 'empty'
             };
        },
        saveData: function() {

        }
    });
    var theHost = new Host();

  /*  var Tier = Backbone.Model.extend({
        url:'/its/dcmd/host/getTierDetails',

        initialize: function() {
            this.set('serviceList', new Services);
        },
        defaults: function() {
            return {
                hostname: 'empty'
            };
        },
        saveData: function() {

        }
    });
    var theTier = new Tier();*/

    var Person = Backbone.Model.extend({
        url:'/its/dcmd/Person/getPersonIdFromRoleId',

        initialize: function() {
            this.set('technicalSupportStaffList', new HostTechnicalSupportStaffs);
            this.set('functionalSupportStaffList', new HostFunctionalSupportStaffs);
        },
        defaults: function() {
            return {
                hostname: 'empty'
            };
        },
        saveData: function() {

        }
    });
    var thePerson = new Person();


    var Environment = Backbone.Model.extend({
    defaults: function() {
        return {
            selected: ""
        };
    }
});

var Environments = Backbone.Collection.extend({
    url:'../host/getEnvironmentsAsSelect',
    model: Environment,
    initialize: function() {
        this.fetch();
    }
});

var environments = new Environments();

var Status = Backbone.Model.extend({
    defaults: function() {
        return {
            selected: ""
        };
    }
});

var Statuses = Backbone.Collection.extend({
    url:'../host/getStatusesAsSelect',
    model: Status,
    initialize: function() {
        this.fetch();
    }
});

var statuses = new Statuses();

var Cluster = Backbone.Model.extend({
    defaults: function() {
        return {
            selected: ""
        };
    }
});

var Clusters = Backbone.Collection.extend({
    url:'../host/getClustersAsSelect',
    model: Cluster,
    initialize: function() {
        this.fetch();
    }
});

var clusters = new Clusters();

var Server = Backbone.Model.extend({
    defaults: function() {
        return {
            selected: ""
        };
    }
});

var Servers = Backbone.Collection.extend({
    url:'../host/getServersAsSelect',
    model: Server,
    initialize: function() {
        this.fetch();
    }
});

var servers = new Servers();

var template;

var HostView = Backbone.View.extend({

    model: theHost,

//            template: _.template($("#server_template").html()),
//            el: $("#server_dialog"),

    events: {
        "click #unlock": "unlockAll",
        "click #lock": "lockAll",
        "click .discard": "discardChanges"
    },

    initialize: function () {
        _.bindAll(this, 'render', 'unlockAll', 'lockAll', 'discardChanges', 'loadData', /*'renderServiceGrid',*/ 'renderTechnicalSupportStaffGrid', 'renderFunctionalSupportStaffGrid');
        template = Handlebars.compile($("#host_template").html());
        //    this.model.on("change", this.render);
    },

    render: function() {
        var context = {host:this.model.toJSON(), envList:environments.toJSON(), statusList:statuses.toJSON(), clusterList:clusters.toJSON(), serverList:servers.toJSON()};

        this.$el.html(template(context));

        // Set all dropdowns to SELECT2 and set their values
        $('.value select').each(function() {
            var attribute = $(this).context.id;
            var selectedVal;
            switch(attribute) {
                case 'env':
                    selectedVal = theHost.attributes[attribute].id;
                    break;
                case 'status':
                    selectedVal = theHost.attributes[attribute].id;
                    break;
                default:
                    selectedVal = theHost.attributes[attribute];
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
    loadData: function(hostId) {
        this.model.fetch({data: $.param({hostId:hostId}), success: this.render});
       // this.model.attributes.serviceList.fetch({data: $.param({hostId:hostId}), success:this.renderServiceGrid()});
        this.model.attributes.technicalSupportStaffList.fetch({data: $.param({hostId:hostId}), success:this.renderTechnicalSupportStaffGrid()});
        this.model.attributes.functionalSupportStaffList.fetch({data: $.param({hostId:hostId}), success:this.renderFunctionalSupportStaffGrid()});
    },

   /* renderServiceGrid: function(){
        console.log(this.model.attributes.serviceList.toJSON());
        $("#serviceLists").GridUnload();
        jQuery("#serviceLists").jqGrid({
            height:'auto',
            autowidth:true,
            datatype: 'local',
            data:this.model.attributes.serviceList.toJSON(),
            width:'100%',
            colNames:[/*'',*'Application', 'Service', 'Service Primary SA', 'Load Balanced', 'Instance Type', 'Instance Notes', 'id'],
            colModel:[
               // {name:'actions', index:'actions', align:'left'},
                {name:'application', align:'left'},
                {name:'service', align:'left'},
                {name:'servAdmin', align:'left'},
                {name:'loadBalanced', align:'left'/*, edittype:'checkbox'*},
                {name:'tierType',align:'left'},
                {name:'generalNote',align:'left'},
                {name:'id', hidden:true}
            ],
            loadComplete : function(data) {
                //alert('grid loading completed ' + data);
            },
            loadError : function(xhr, status, error) {
                alert('grid loading error' + error);
            }
        });
    },*/

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

var openItem = function(hostId) {
    var hostView = new HostView({ el: $("#host_attributes") });
    hostView.loadData(hostId);
    $("#host_dialog").dialog("open");
     // console.log(test.toJSON());
};

</script>