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
    var AppSupportTechnicalSupportStaff = Backbone.Model.extend();
    var AppSupportTechnicalSupportStaffs = Backbone.Collection.extend({
        url: '/its/dcmd/person/getPersonIdByApp',
        model: AppSupportTechnicalSupportStaff
    });

    var Environment = Backbone.Model.extend({
        defaults: function() {
            return {
                selected: ""
            };
        }
    });

    var Environments = Backbone.Collection.extend({
        url:'../application/getEnvironmentsAsSelect',
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
        url:'../application/getStatusesAsSelect',
        model: Status,
        initialize: function() {
            this.fetch();
        }
    });

    var statuses = new Statuses();

    var AppSupport = Backbone.Model.extend({
        url:'../Application/getAppSupportDetails',

        initialize: function() {
            // this.set('serviceList', new Services);
            this.set('technicalSupportStaffList', new AppSupportTechnicalSupportStaffs);
            // this.set('functionalSupportStaffList', new HostFunctionalSupportStaffs);
        },
        defaults: function() {
            return {
                applicationTitle: 'empty'
            };
        },
        saveData: function() {

        }
    });
    var theAppSupport = new AppSupport();

    var objectSupport = Backbone.Model.extend({
        url:'../Application/getSupportDetails',

        initialize: function() {
            // this.set('serviceList', new Services);
            this.set('technicalSupportStaffList', new AppSupportTechnicalSupportStaffs);
            // this.set('functionalSupportStaffList', new HostFunctionalSupportStaffs);
        },
        defaults: function() {
            return {
                applicationTitle: 'empty'
            };
        },
        saveData: function() {

        }
    });
    var theobjectSupport = new objectSupport();

    var Person = Backbone.Model.extend({
        url:'/its/dcmd/Person/getPersonIdFromRoleId',

        initialize: function() {
            this.set('technicalSupportStaffList', new AppSupportTechnicalSupportStaffs);
            // this.set('functionalSupportStaffList', new HostFunctionalSupportStaffs);
        },
        defaults: function() {
            return {
                applicationTitle: 'empty'
            };
        },
        saveData: function() {

        }
    });

    var thePerson = new Person();

    var template;

    var AppSupportView = Backbone.View.extend({

        model: theAppSupport,

//            template: _.template($("#server_template").html()),
//            el: $("#server_dialog"),

        events: {
            "click #unlock": "unlockAll",
            "click #lock": "lockAll",
            "click .discard": "discardChanges"
        },

        initialize: function () {
            _.bindAll(this, 'render', 'unlockAll', 'lockAll', 'discardChanges', 'loadData', 'renderTechnicalSupportStaffGrid');
            template = Handlebars.compile($("#app_support_template").html());
            //    this.model.on("change", this.render);
        },

        render: function() {
            var context = {appSupport:this.model.toJSON(), envList:environments.toJSON(), statusList:statuses.toJSON()};

            this.$el.html(template(context));

            // Set all dropdowns to SELECT2 and set their values
            /* $('.value select').each(function() {
             var attribute = $(this).context.id;
             var selectedVal;
             switch(attribute) {
             case 'env':
             selectedVal = theApp.attributes[attribute].id;
             break;
             case 'status':
             selectedVal = theApp.attributes[attribute].id;
             break;
             default:
             selectedVal = theApp.attributes[attribute];
             }
             $(this).select2({
             width:150
             }).select2('val', selectedVal);
             }); */

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
        loadData: function(appSupportId) {
            this.model.fetch({data: $.param({appSupportId:appSupportId}), success: this.render});
            //    this.model.attributes.serviceList.fetch({data: $.param({hostId:hostId}), success:this.renderServiceGrid()});
            this.model.attributes.technicalSupportStaffList.fetch({data: $.param({appSupportId:appSupportId}), success:this.renderTechnicalSupportStaffGrid()});
            //    this.model.attributes.functionalSupportStaffList.fetch({data: $.param({hostId:hostId}), success:this.renderFunctionalSupportStaffGrid()});
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
        }
    });

    var openSupportItem = function(appSupportId) {
        var appView = new AppSupportView({ el: $("#app_support_attributes") });
        appView.loadData(appSupportId);
        $("#app_support_dialog").dialog("open");
        // console.log(test.toJSON());
    };
</script>
