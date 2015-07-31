<%@  page import="edu.hawaii.its.dcmd.inf.GeneralService" %>
%{--def genService = grailsApplication.classLoader.loadClass('edu.hawaii.its.dcmd.inf.GeneralService').newInstance()--}%

<script language="javascript" type="text/javascript" src="../js/isotope.pkgd.min.js"></script>
<script language="javascript" type="text/javascript">
    function setup(serviceInstance) {

        var $container = $('#container');
        $container.isotope({
            itemSelector: '.item',
            layoutMode: 'fitRows'
        });
    }
</script>

<script type="text/javascript">

</script>


<style>
.value input[type="text"] {
    background:transparent;
    border: 0px;
    color: white;
}

.editing input[type="text"] {
    background:white;
    border: 1px black;
    color: black;
}
</style>

<script language="javascript" type="text/javascript">
    var container = document.querySelector("#container");
    var iso = new Isotope( container, {
        itemSelector:'.item',
        layoutMode:'fitRows'
    });
</script>


<div class="dialog">
    <script type="text/x-handlebars-template" id="service_template">
    <div id="container" class="js-isotope" data-isotope-options='{ "columnWidth":400}' style="min-height:275px">

        <input type="button" id="unlock" value="Unlock" /><input type="button" id="lock" value="Lock" />

        <div class="item">
            <table class="floatTables" style="border:1px solid #CCCCCC;">
                <tr><td colspan="2"><center><b>General Information</b></center></td></tr>
                <tr>
                    <td valign="top" class="name">Service Name</td>
                    <td valign="top" class="value">
                        <input type='text' value="{{service.serviceTitle}}" />
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="name">Environment</td>
                    <td valign="top" class="value">
                        <select id="environment">
                            {{#each envList}}
                            <option value="{{this.id}}">{{this.text}}</option>
                            {{/each}}
                        </select></td>
                </tr>
                <tr>
                    <td valign="top" class="name">Id</td>
                    <td valign="top" class="value">
                        <input type='text' value="{{service.id}}" />
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="name">Description</td>
                    <td valign="top" class="value">
                        <input type='text' value="{{service.serviceDescription}}" />
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="name">Status</td>
                    <td valign="top" class="value">
                        <select id="status">
                            {{#each statusList}}
                            <option value="{{this.id}}">{{this.text}}</option>
                            {{/each}}
                        </select></td>
                </tr>
                <tr>
                    <td valign="top" class="name">Date Created</td>
                    <td valign="top" class="value">
                        <input type='text' value="{{service.dateCreated}}" />
                    </td>
                </tr>
                <tr>
                    <td valign="top" class="name">Last Updated</td>
                    <td valign="top" class="value">
                        <input type='text' value="{{service.lastUpdated}}" />
                    </td>
                </tr>

               %{-- <tr>
                    <td valign="top" class="name">Application</td>
                    <td valign="top" class="value">
                        <select id="application">
                            {{#each statusList}}
                            <option value="{{this.id}}">{{this.text}}</option>
                            {{/each}}
                        </select></td>
                </tr> --}%
            </table>
        </div>

    </div>
    <br />

    </script>



</div>