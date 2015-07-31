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
    var ServiceHost = Backbone.Model.extend();
    var ServiceHosts = Backbone.Collection.extend({
        url:'../host/getHostsByService',
        model: ServiceHost
    });

    var ServiceTechnicalSupportStaff = Backbone.Model.extend();
    var ServiceTechnicalSupportStaffs = Backbone.Collection.extend({
        url:'../person/getPersonIdByServer',
        model: ServiceTechnicalSupportStaff
    });

    var ServiceFunctionalSupportStaff = Backbone.Model.extend();
    var ServiceFunctionalSupportStaffs = Backbone.Collection.extend({
        url:'../person/getPersonIdByServer',
        model: ServiceFunctionalSupportStaff
    });

    var Asset = Backbone.Model.extend({
        url:'/its/dcmd/service/getAssetDetails',

        initialize: function() {
            this.set('hostList', new ServiceHosts);
        },
        defaults: function() {
            return {
                serviceTitle: 'empty'
            };
        },
        saveData: function() {

        }
    });
    var theAsset = new Asset();

    var Person = Backbone.Model.extend({
        url:'/its/dcmd/Person/getPersonIdFromRoleId',

        initialize: function() {
            this.set('technicalSupportStaffList', new ServiceTechnicalSupportStaffs);
            this.set('functionalSupportStaffList', new ServiceFunctionalSupportStaffs);
        },
        defaults: function() {
            return {
                serviceTitle: 'empty'
            };
        },
        saveData: function() {

        }
    });
    var thePerson = new Person();

    var Service = Backbone.Model.extend({
        url:'/its/dcmd/service/getServiceDetails',

        initialize: function() {
            this.set('hostList', new ServiceHosts);
            this.set('technicalSupportStaffList', new ServiceTechnicalSupportStaffs);
            this.set('functionalSupportStaffList', new ServiceFunctionalSupportStaffs);
        },
        defaults: function() {
            return {
                serviceTitle: 'empty'
            };
        },
        saveData: function() {

        }
    });
    var theService = new Service();

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

    var template;

    var ServiceView = Backbone.View.extend({

        model: theService,

        events: {
            "click #unlock": "unlockAll",
            "click #lock": "lockAll",
            "click .discard": "discardChanges"
        },

        initialize: function () {
            _.bindAll(this, 'render', 'unlockAll', 'lockAll', 'discardChanges', 'loadData', 'renderHostGrid', 'renderTechnicalSupportStaffGrid', 'renderFunctionalSupportStaffGrid');
            template = Handlebars.compile($("#service_template").html());
            //    this.model.on("change", this.render);
        },

        render: function() {
            var context = {service:this.model.toJSON(), envList:environments.toJSON(), statusList:statuses.toJSON()};

            this.$el.html(template(context));

            // Set all dropdowns to SELECT2 and set their values
          /*  $('.value select').each(function() {
                var attribute = $(this).context.id;
                var selectedVal;
                switch(attribute) {
                    case 'env':
                        selectedVal = theService.attributes[attribute].id;
                        break;
                    /*case 'status':
                        selectedVal = theService.attributes[attribute].id;
                        break; *
                    default:
                        selectedVal = theService.attributes[attribute];
                }
                $(this).select2({
                    width:150
                }).select2('val', selectedVal);
            });*/

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

        loadData: function(serviceId) {
            this.model.fetch({data: $.param({serviceId:serviceId}), success: this.render});
            this.model.attributes.hostList.fetch({data: $.param({serviceId:serviceId}), success:this.renderHostGrid});
            this.model.attributes.technicalSupportStaffList.fetch({data: $.param({serviceId:serviceId}), success:this.renderTechnicalSupportStaffGrid()});
            this.model.attributes.functionalSupportStaffList.fetch({data: $.param({serviceId:serviceId}), success:this.renderFunctionalSupportStaffGrid()});
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

    var openItem = function(serviceId) {
        var serviceView = new ServiceView({ el: $("#service_attributes") });
        serviceView.loadData(serviceId);
        $("#service_dialog").dialog("open");
        //   console.log(test.toJSON());
    };
</script>