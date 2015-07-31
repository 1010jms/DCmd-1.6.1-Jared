$(document).ready(function() {
  	$('#person').autocomplete({
		source: function( request, response ) {
			$.ajax({
				url: "/dcmd/person/searchJSON",
				type: "POST",
				data: {
					maxRows: 12,
					searchTerm: request.term
				},
				success: function( data ) {
					response( $.map( data, function( item ) {
						return {
							label: item.name,
							value: item.name,
							id: item.id
						}
					}));
				},
				error: function(jqXHR, textStatus, errorThrown){
					alert("Could not retrieve a list of people!");
				}
			});
		},
		minLength: 2,
		select: function( event, ui ) {
			//set hidden value to id of person
			$('#personId').val(ui.item.id);
		}
  	});
});