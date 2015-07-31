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
    var ClusterHost = Backbone.Model.extend();
    var ClusterHosts = Backbone.Collection.extend({
        url:'../host/getHostsByCluster',
        model: ClusterHost
    });

    var Cluster = Backbone.Model.extend({
        url:'/its/dcmd/cluster/getClusterDetails',

        initialize: function() {
            this.fetch();
            this.set('hostList', new ClusterHosts);
        },
        defaults: function() {
            return {
                name: 'empty'
            };
        },
        saveData: function() {

        }
    });
    var theCluster = new Cluster();

    var Asset = Backbone.Model.extend({
        url:'/its/dcmd/cluster/getAssetDetails',

        initialize: function() {
            this.set('hostList', new ClusterHosts);
        },
        defaults: function() {
            return {
                name: 'empty'
            };
        },
        saveData: function() {

        }
    });
    var theAsset = new Asset();

    var template;

    var ClusterView = Backbone.View.extend({

        model: theCluster,

//            template: _.template($("#Cluster_template").html()),
//            el: $("#cluster_dialog"),

        events: {
            "click #unlock": "unlockAll",
            "click #lock": "lockAll",
            "click .discard": "discardChanges"
        },

        initialize: function () {
            _.bindAll(this, 'render', 'unlockAll', 'lockAll', 'discardChanges', 'loadData', 'renderHostGrid');
            template = Handlebars.compile($("#cluster_template").html());
            //    this.model.on("change", this.render);
        },

        render: function() {
            var context = {cluster:this.model.toJSON()};

            this.$el.html(template(context));

            // Set all dropdowns to SELECT2 and set their values
            $('.value select').each(function() {
                var attribute = $(this).context.id;
                var selectedVal;
                switch(attribute) {
                    default:
                        selectedVal = theCluster.attributes[attribute];
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
        loadData: function(clusterId) {
            this.model.fetch({data: $.param({clusterId:clusterId}), success: this.render});
            this.model.attributes.hostList.fetch({data: $.param({clusterId:clusterId}), success:this.renderHostGrid});
            //this.model.attributes.technicalSupportStaffList.fetch({data: $.param({clusterId:clusterId}), success:this.renderTechnicalSupportStaffGrid()});
            //this.model.attributes.functionalSupportStaffList.fetch({data: $.param({clusterId:clusterId}), success:this.renderFunctionalSupportStaffGrid()});
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
        }
    });

    var openItem = function(clusterId) {
        var clusterView = new ClusterView({ el: $("#cluster_attributes") });
        clusterView.loadData(clusterId);
        $("#cluster_dialog").dialog("open");
        //   console.log(test.toJSON());
    };
</script>