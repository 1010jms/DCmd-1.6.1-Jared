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
    var Staff = Backbone.Model.extend({
        url:'/its/dcmd/person/getPersonDetails',

        initialize: function() {

        },
        defaults: function() {
            return {
                uhName: 'empty'
            };
        },
        saveData: function() {

        }
    });
    var theStaff = new Staff();

    var template;

    var PersonView = Backbone.View.extend({

        model: theStaff,

//            template: _.template($("#server_template").html()),
//            el: $("#server_dialog"),

        events: {
            "click #unlock": "unlockAll",
            "click #lock": "lockAll",
            "click .discard": "discardChanges"
        },

        initialize: function () {
            _.bindAll(this, 'render', 'unlockAll', 'lockAll', 'discardChanges', 'loadData');
            template = Handlebars.compile($("#person_template").html());
            //    this.model.on("change", this.render);
        },

        render: function() {
            var context = {person:this.model.toJSON()};

            this.$el.html(template(context));

            // Set all dropdowns to SELECT2 and set their values
            $('.value select').each(function() {
                var attribute = $(this).context.id;
                var selectedVal;
                switch(attribute) {
                    /*case 'cluster':
                        selectedVal = theStaff.attributes[attribute].id;
                        break; */
                    default:
                        selectedVal = theStaff.attributes[attribute];
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
        loadData: function(staffId) {
            this.model.fetch({data: $.param({staffId:staffId}), success: this.render});
        }
    });

    var openItem = function(staffId) {
        var personView = new PersonView({ el: $("#person_attributes") });
        personView.loadData(staffId);
        $("#person_dialog").dialog("open");
        //   console.log(test.toJSON());
    };

</script>
