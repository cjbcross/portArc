<%@ taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix='c' uri='http://java.sun.com/jsp/jstl/core' %>

<form id="searchForm" method="post" class="form-horizontal">
    <div class="form-group">
        <label class="col-xs-3 control-label">Enter Application:</label>
        <div class="col-xs-5">
            <input type="text" class="form-control" name="appNum" id="appNum" />
        </div>
    </div>

    <div class="form-group">
        <label class="col-xs-3 control-label"><i class="fa fa-info-circle" title='"Yes" returns folders containing datasets, "No" returns folders without datasets, and "Show All" shows all folders, regardless of data types contained.'></i> Folders with Datasets:</label>
        <div class="col-xs-5">
	        <label class="radio-inline">
	          	<input type="radio" name="folders" id="radioYes" value="yes"> Yes
	        </label>
	        <label class="radio-inline">
	          	<input type="radio" name="folders" id="radioNo" value="no"> No
	        </label>
	        <label class="radio-inline">
	          	<input type="radio" name="folders" id="radioAll1" value="" checked> Show All
	        </label>
	    </div>      
  	</div>

    <div class="form-group">
        <label class="col-xs-3 control-label"><i class="fa fa-info-circle" title='"Non-Clinical" returns m4 studies, "Clinical" returns m5 studies, and "Show All" returns both m4 and m5 study folders.'></i> Choose a Data Module:</label>
        <div class="col-xs-5">
	        <label class="radio-inline">
	          	<input type="radio" name="module" id="radioM4" value="m4"> Non-Clinical
	        </label>
	        <label class="radio-inline">
	          	<input type="radio" name="module" id="radioM5" value="m5"> Clinical
	        </label>
	        <label class="radio-inline">
	          	<input type="radio" name="module" id="radioAll2" value="" checked> Show All
	        </label>
	    </div>      
  	</div>
</form>

    <div class="form-group">
        <div class="col-xs-5 col-xs-offset-3">
            <button id="search" type="button" class="btn btn-primary" disabled><i class="fa fa-search"></i> Search</button>
            <button id="reset" type="button" class="btn btn-secondary"><i class="fa fa-refresh"></i> Reset</button>
        </div>
    </div>
    
<br /><br />    

<div id="resultHead" style="display:none">
	<h3>Showing results for application <span id="appVal"></span></h3>
</div>    
  

<div id="tableDiv" style="display:none;">
   <table id="mdTable" class="display" cellspacing="0" width="100%">
   		<col width="5%">
   		<col width="75%">
   		<col width="5%">
   		<col width="5%">
   		<col width="5%">
   		<col width="5%">
        <thead>
            <tr>
            	<th></th>
                <th>Path</th>
                <th>Total Files</th>
                <th>Data Files</th>
                <th>PDF Files</th>
                <th>XML Files</th>
            </tr>
        </thead>
        <tfoot>
            <tr>
              	<th></th>
                <th>Path</th>
                <th>Total Files</th>
                <th>Data Files</th>
                <th>PDF Files</th>
                <th>XML Files</th>
            </tr>
        </tfoot>
    </table>
</div>

<div id="toolbarDiv" style="display:none;">
	<div id="selCount">No Items Selected</div>
	<br/>
    <button id="submitSelected" type="button" class="btn btn-primary" title="No Items Selected"><i class="fa fa-download"></i> Submit Selections</button>
</div>
<style>
.modal-lg {
    width: 90%;
}

div.ui-tooltip {
    max-width: 55%;
}

.select-item{
	display: none;
}
</style>
<script>
    $(document).ready(function() {
    	
    	$( function() {
    		$(document).tooltip({
    	        content: function () {
    	        	return $(this).prop('title');
    	        }
    	    });
    	});
    	
    	$("#search").click(function(){
			$("#resultHead").show();
			$("#toolbarDiv").show();

    		var application = $('#appNum').val();
    		var datasets = $('input[name=folders]:checked', '#searchForm').val();
    		var module = $('input[name=module]:checked', '#searchForm').val();
    		
    		document.getElementById("appVal").innerHTML = application;
    		
			var table = $('#mdTable').DataTable( {
				destroy: true,
		        empty: true,
				columnDefs: [ {
		            orderable: false,
		            className: 'select-checkbox',
		            targets:   0
		        } ],
		        select: {
		            style:    '',
		            selector: 'td:first-child'
		        },
		        order: [[ 1, 'asc' ]],
		        ajax: {
		        	url: "mdJSON.do?application=" + application + "&datasets=" + datasets + "&module=" + module,
		        	dataSrc: ''
		        },
		        columns: [
		        	{ "data": "cb_null" },
		        	{ "data": "href_path" },
		        	{ "data": "file_num" },
		        	{ "data": "file_list" },
		        	{ "data": "pdf_count" },
		        	{ "data": "xml_count" }
		        ]
		    } );
			
			$("#tableDiv").show();
						
			$('#mdTable tbody').on( 'click', 'tr', function () {
		        $(this).toggleClass('selected');
		        
		        if(table.rows('.selected').data().length > 0)
					document.getElementById("selCount").innerHTML = table.rows('.selected').data().length+ " Items Selected";
				else
					document.getElementById("selCount").innerHTML = 'No Items Selected';
		    } );
			
			$("#submitSelected").on("mouseover", function(){
				if(table.rows('.selected').data().length > 0){
			    	var myTips;
			    	var tipTxt = "<h4>Current Selections:</h4><table class='table table-striped' style='width: 100%;'>";

			    	for (m=0;m<table.rows('.selected').data().length;m++)
			    		myTips = table.rows('.selected').data();
			    	
			    	for(n=0;n<myTips.length;n++)
			    		tipTxt += ('<tr><td>'+myTips[n].href_path+'</td></tr>');
			    	
			    	tipTxt += "</table>";

					$('#submitSelected').prop('title', tipTxt);
				}
				else
					$('#submitSelected').prop('title', 'No Items Selected');
			});
			
			function getUserTasks(callback){
				$.getJSON("getUserTasks.do", function(result){
			    	var key1 = 'href_path';
			    	var key2 = 'file_num';
					var cb = "";
		            $.each(result, function(i, field){
		            	cb += ('<option title="" value="'+field[key1]+'">'+field[key2]+'</option>');
		            });
					cb += "</select>";
				    if( typeof callback === 'function' ) callback( cb ); 
		        });
			}
		 
		    $('#submitSelected').click( function () {
		    	if(table.rows('.selected').data().length > 0){
		    		getUserTasks(function(cb){
				    	var myArr;
				    	var mySubmit = [];
				    	var mycbIds = [];
				    	
				    	for (i=0;i<table.rows('.selected').data().length;i++)
				    		myArr = table.rows('.selected').data();
				    	
				    	for (j=0;j<myArr.length;j++) {
				    		mySubmit.push(myArr[j].href_path);
				    		mycbIds.push('<select id="multiple-selected-'+[j]+'" multiple="multiple">')
				    	}
				    	
				    	$('#myNoSel').modal('hide');
				    	$("#myModal").modal();
				    							
				    	var html = "<table class='table table-striped' style='width: 100%;'><col width='65%'><col width='35%'><thead><tr><th>Folder</th><th>Staging Action</th></tr></thead><tbody>";
				    	for (var k=0; k<mySubmit.length; k++) {
				            html += ('<tr><td id="td-sel-'+[k]+'">'+mySubmit[k]+'</td><td>'+mycbIds[k]+cb+'</td></tr>');
				        }
				    	html += "</tbody></table>";
				    	
				    	html += '<div id="submittedNum" style="display:none;">'+myArr.length+'</div>';
				    	
				    	document.getElementById("modBod").innerHTML = html;
						
				    	for (l=0;l<mycbIds.length;l++) {
				    	   	$('#multiple-selected-'+[l]).multiselect({
				                buttonWidth: '400px',
				                dropRight: true,
				                includeSelectAllOption: true,
				                selectAllText: 'Select All',
				                buttonText: function(options, select) {
				                    return 'Select file types and download location';
				                },
				                buttonTitle: function(options, select) {
				                	if ( options.length>0 ) {
					                    var labels = [];
					                    options.each(function () {
					                        labels.push('<tr><td>'+$(this).text()+'</td></tr>');
					                    });
					                    labels.unshift("<h4>Current Selections:</h4><table class='table table-striped' style='width: 100%;'>");
					                    labels.push('</table>');
					                    return labels.join('');
				                	}
				                	else {
				                		return "<h4><i class='fa fa-exclamation-triangle'></i> Please make selections</h4>";
				                	}
				                }
				            });
				    	}
				    	
		    		});
		    	}
		    	else {
			    	$("#myModal").modal('hide');
		    		$("#myNoSel").modal();
		    	}
		    });
    	});
		
		$('#appNum').on('keyup',function(){
		      var input = $(this);
		      if (input.val().trim().length == 0 || input.val().length == 0)
		    	  $('#search').prop('disabled', true);
		      else
		    	  $('#search').prop('disabled', false);
		});
		
		$("#reset").click(function(){
			location.reload();
		});
		
	});
</script>

<!-- Selections made Modal  -->
<div class="modal fade" id="myModal" role="dialog">
	<div class="modal-dialog modal-lg">
	<!-- Modal content-->
		<div class="modal-content">
  			<div class="modal-header">
    			<h4 class="modal-title">Confirm Selections:</h4>
  			</div>
  			<div class="modal-body" id="modBod" style="word-wrap: break-word;">
      		</div>
      		<div class="modal-footer">
        		<button id="submitTask" type="button" class="btn btn-primary" data-dismiss="modal"><i class="fa fa-upload"></i> Send to Queue</button>
        		<button type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fa fa-undo"></i> Back to Results</button>
      		</div>
    	</div>
  	</div>
</div>

<!-- Selections NOT made Modal  -->
<div class="modal fade" id="myNoSel" role="dialog">
	<div class="modal-dialog">
	<!-- Modal content-->
		<div class="modal-content">
  			<div class="modal-header">
    			<h4 class="modal-title">No Selections made...</h4>
  			</div>
  			<div class="modal-body" style="word-wrap: break-word;">
  				You must make selections from the search results page.  Please click the button below to go back.
      		</div>
      		<div class="modal-footer">
        		<button type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fa fa-undo"></i> Back to Results</button>
      		</div>
    	</div>
  	</div>
</div>

<!-- Selections Submitted -->
<div class="modal fade" id="mySuccess" role="dialog">
	<div class="modal-dialog">
	<!-- Modal content-->
		<div class="modal-content">
  			<div class="modal-header">
    			<h4 class="modal-title">Selections Submitted</h4>
  			</div>
  			<div class="modal-body" style="word-wrap: break-word;">
  				Your Selections have been submitted and will be processed from our task queue.<p />
  				You will receive email notification when your files are processed and staged.<p />
  				Thank you for using Portes 2.0!
      		</div>
      		<div class="modal-footer">
        		<button id="closeReload" type="button" class="btn btn-secondary" data-dismiss="modal"><i class="fa fa-close"></i> Close</button>
      		</div>
    	</div>
  	</div>
</div>


<div id="hidden" style="display:none;">${sessionScope.username}</div>

<!-- We will submit to the DB now -->
<script>
	$('#submitTask').click( function () {
		var num = document.getElementById("submittedNum").innerHTML;
		var username = document.getElementById("hidden").innerHTML;
    	var application = $('#appNum').val();
		
		var href_path = []
		var choices = []
		
		for (i=0;i<num;i++) {
			href_path.push(document.getElementById('td-sel-'+[i]).innerHTML);
			choices.push($('#multiple-selected-'+[i]).val());
		} 
		
		for (j=0;j<href_path.length;j++) {
			$.ajax({
				  type: "POST",
				  url: "submitTasks.do?application=" + application + "&href_path=" + href_path[j] + "&actions=" + choices[j] + "&username=" + username,
			});
		}
		
		$("#mySuccess").modal();
	});
	
	$('#closeReload').click( function () {
		location.reload();
	});
</script>
