/*
 * On document load, bind the click event of the 
 * 'Add Contract Feature' button to an ajax call that
 * adds a ContractFeatureType to the current Contract.
 * Also, hide all of the td elements in the table
 * so the id of ContractFeatureType objects is not
 * visible.
 */
$(document).ready(function() {
	
	//Bind the click event here
  	//alert('contractFeatures ready');
  	$('#remoteAdd').bind('click', function() {
  		//alert($(this).val());
  		
  		//validate input
  		if(validateInput()){
  			
  			//set up the ajax call
	  		$.ajax({
	  			url: '/dcmd/vendor/addContractFeatureType',
	  			data: getContractFeaturesParams(),
	  			type: 'POST',
	  			success: commitContractFeaturesInput,
	  			error: function(){
	  				alert('The addition of the Contract Feature was not successful.');
	  			}
	  		});
  		}
	});
  	
  	//Hide the id <td>'s
	$('.hide-me').each(function (i) {
		//alert(i);
		this.style.display='none';
	});
	
	addContractFeaturesDeleteButtons();
});

function validateContractFeaturesInput(){
	var msg='';
	if($('#contractFeatureType').val() == ''){
		msg += 'You must select a Contract Feature Type.';
	}
	if(msg != ''){
		alert(msg);
		return false;
	}else{
		return true;
	}
}

/*
 * When ajax call completes successfully, replace all
 * rows in the table with values returned.
 */
function saveContractFeaturesFormData(data, status, jqXHR){
	//alert(data.person);
	//alert(data.supportRole);
	
	//clear out all table rows not in th
	var rowCount = $('#contractFeaturesTable tbody tr').length;
	$('#contractFeaturesTable tbody tr').remove();
	var newRow;
	for(row in data){
		newRow = '<tr ';
		if((row % 2) == 1){
			newRow += "class='even'>";
		}else{
			newRow += "class='odd'>";
		}
		newRow += "<td class='hide-me' style='display:none'></td><td>";
		newRow += data[row].person;
		newRow += "</td>"
		newRow += getContractFeaturesDeleteButton(data[row].id);
		newRow += "</tr>";
		$('#contractFeaturesTable').append(newRow);
	}
	var newRowCount = $('#contractFeaturesTable tbody tr').length;
	if(rowCount == newRowCount){
		alert("The Contract Feature is already specified!");
	}
}

/*
 * Formats the params to be sent in the ajax request
 */
function getContractFeaturesParams(){
	var params = { person:$('#contractFeatureType').val(), supportableObjectType:$('#supportableObjectType').val(), vendor:$('#id').val()};
	return $.param(params);
}

function addContractFeaturesDeleteButtons(){
	$('#supportTable thead tr').append("<td>&nbsp;</td>");
	$('#supportTable tbody tr').each(function(index){
		var id = this.children[0].innerText;
		var del = getDeleteButton(index);
		$(this).append(del);
		var buttonId = "#remoteDeleteContractFeaturesButton" + index;
		$(buttonId).bind('click', function(){
			//alert('delete ' + id + '?');
			//some $.ajax to delete
		});
	});
}

function getContractFeaturesDeleteButton(index){
	return "<td><input type='submit' name='remoteDeleteContractFeatures" + index + "' value='Remove' id='remoteDeleteContractFeatures" + index + "'></td>";
}



