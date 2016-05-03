<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Manage Receipt Drugs"])

    ui.includeCss("billingui", "jquery.dataTables.min.css")
    ui.includeCss("registration", "onepcssgrid.css")

    ui.includeJavascript("billingui", "moment.js")
    ui.includeJavascript("billingui", "jquery.dataTables.min.js")
    ui.includeJavascript("laboratoryapp", "jq.browser.select.js")
%>
<head>
    <script>
        var drugOrder = [];
		var receiptDescription = "";
        var index=0;
        var count = 0;

        jq(function () {
            jq("#tabs").tabs();

            var getJSON = function (dataToParse) {
                if (typeof dataToParse === "string") {
                    return JSON.parse(dataToParse);
                }
                return dataToParse;
            }

            var adddrugdialog = emr.setupConfirmationDialog({
                selector: '#addDrugDialog',
                actions: {
                    confirm: function() {
						if (!page_verified()){
							jq().toastmessage('showErrorToast', 'Ensure fields marked in Red are filled properly');
							return false;
						}

						if(!compare_DOE_DOM_DOR(jq("#dateOfExpiry-field").val(),jq("#dateOfManufacture-field").val(),jq("#receiptDate-field").val())){
							return false;
						}
					
                        var tbody = jq('#addDrugsTable').children('tbody');
                        var table = tbody.length ? tbody : jq('#addDrugsTable');

                        index = drugOrder.length ;
                        count = index + 1;
                        table.append('<tr id="' + index +'"><td>'+ count +'</td><td>'+jq("#drugCategory").val()+'</td><td>'+jq("#drugName").val()+'</td><td>'+jq("#drugFormulation option:selected").text()+'</td><td>'+jq("#quantity").val()+'</td><td>'+jq("#unitPrice").val()+'</td><td>'+jq("#institutionalCost").val()+'</td><td>'+jq("#costToThePatient").val()+'</td><td>'+jq("#batchNo").val()+'</td><td>'+jq("#companyName").val()+'</td><td>'+jq("#dateOfManufacture-display").val()+'</td><td>'+jq("#dateOfExpiry-display").val()+'</td><td>'+jq("#receiptDate-display").val()+'</td><td>'+jq("#receiptFrom").val()+'</td><td><a onclick="removerFunction(' + index +')" class="remover"><i class="icon-remove small" style="color:red"></i></a> <a onclick="editorFunction(' + index +')" class="remover" ><i class="icon-edit small" style="color:blue"></i></a></td></tr>');
                        drugOrder.push(
                                {
                                    rowId: index,
                                    drugCategoryId: jq("#drugCategory").children(":selected").attr("id"),
                                    drugCategoryName: jq("#drugCategory").children(":selected").val(),
                                    drugId: jq("#drugName").children(":selected").attr("id"),
                                    drugName: jq("#drugName").children(":selected").val(),
                                    drugFormulationId: jq("#drugFormulation").children(":selected").attr("id"),
                                    drugFormulationName: jq("#drugFormulation").children(":selected").val(),
                                    quantity: jq("#quantity").val(),
                                    unitPrice: jq("#unitPrice").val(),
                                    institutionalCost:jq("#institutionalCost").val(),
                                    costToThePatient:jq("#costToThePatient").val(),
                                    batchNo:jq("#batchNo").val(),
                                    companyName:jq("#companyName").val(),
                                    dateOfManufacture:jq("#dateOfManufacture-field").val(),
                                    dateOfExpiry:jq("#dateOfExpiry-field").val(),
                                    receiptDate:jq("#receiptDate-field").val(),
                                    receiptFrom:jq("#receiptFrom").val()
                                }
                        );

                        adddrugdialog.close();
                    },
                    cancel: function() {
                        adddrugdialog.close();
                    }
                }

            });

			var addDescriptionDialog = emr.setupConfirmationDialog({
				selector: '#addDescriptionDialog',
				actions: {
					confirm: function() {
						receiptDescription = jq("#addReceiptsDescription").val();

						drugOrder = JSON.stringify(drugOrder);
						var addDrugsData = {
							'drugOrder':drugOrder,
							'description' :receiptDescription
						};

						jq.getJSON('${ ui.actionLink("inventoryapp", "AddReceiptsToStore", "saveReceipt") }',addDrugsData)
								.success(function(data) {
									jq().toastmessage('showSuccessToast', 'Receipt Saved Successfully');
									var receiptsLink = emr.pageLink("inventoryapp", "main");
									receiptsLink = receiptsLink.substring(0, receiptsLink.length - 1) + "#receipts";
									window.location = receiptsLink; 
								})
								.error(function(xhr, status, err) {
									jq().toastmessage('showErrorToast', 'Some Error Occured');
								});

						adddrugdialog.close();
					},
					cancel: function() {
						adddrugdialog.close();
					}
				}

			});
			
			function page_verified(){
				var error = 0;
				
				if (jq("#drugCategory").children(":selected").attr("id") == 0){
					jq("#drugCategory").addClass('red');
					error ++;
				}
				else {
					jq("#drugCategory").removeClass('red');
				}
				
				if (jq("#drugName").children(":selected").attr("id") == 0){
					jq("#drugName").addClass('red');
					error ++;
				}
				else {
					jq("#drugName").removeClass('red');
				}
				
				if (jq("#drugFormulation").children(":selected").attr("id") == 0){
					jq("#drugFormulation").addClass('red');
					error ++;
				}
				else {
					jq("#drugFormulation").removeClass('red');
				}
				
				if (jq("#quantity").val() == ""){
					jq("#quantity").addClass('red');
					error ++;
				}
				else {
					jq("#quantity").removeClass('red');
				}
				
				if (jq("#costToThePatient").val() == ""){
					jq("#costToThePatient").addClass('red');
					error ++;
				}
				else {
					jq("#costToThePatient").removeClass('red');
				}
				
				if (jq("#batchNo").val() == ""){
					jq("#batchNo").addClass('red');
					error ++;
				}
				else {
					jq("#batchNo").removeClass('red');
				}
				
				if (jq("#companyName").val() == ""){
					jq("#companyName").addClass('red');
					error ++;
				}
				else {
					jq("#companyName").removeClass('red');
				}
				
				if (jq("#dateOfManufacture-display").val() == ""){
					jq("#dateOfManufacture-display").addClass('red');
					error ++;
				}
				else {
					jq("#dateOfManufacture-display").removeClass('red');
				}
				
				if (jq("#dateOfExpiry-display").val() == ""){
					jq("#dateOfExpiry-display").addClass('red');
					error ++;
				}
				else {
					jq("#dateOfExpiry-display").removeClass('red');
				}
				
				if (jq("#receiptDate-display").val() == ""){
					jq("#receiptDate-display").addClass('red');
					error ++;
				}
				else {
					jq("#receiptDate-display").removeClass('red');
				}
				
				if (error == 0){
					return true;
				} else{
					return false;				
				}
			}
			
			function resets(){
				jq('form')[0].reset();
				jq('#drugCategory').change();
			}
			

            jq("#addDrugsButton").on("click", function(e){
				resets();
                adddrugdialog.show();
            });

            jq("#drugCategory").on("change",function(e){
                var categoryId = jq(this).children(":selected").attr("id");
                var drugNameData = "<option id='0' name='0'>Select Drug</option>";
				var drugFormulationData = "<option id='0'>Select Formulation</option>";
				
				jq('#drugName').empty();
				jq('#drugFormulation').empty();
				
                jq.getJSON('${ ui.actionLink("inventoryapp", "AddReceiptsToStore", "fetchDrugNames") }',{
                    categoryId:categoryId
                }).success(function(data) {
					for (var key in data) {
						if (data.hasOwnProperty(key)) {
							var val = data[key];
							for (var i in val) {
								if (val.hasOwnProperty(i)) {
									var j = val[i];
									if(i=="id")
									{
										drugNameData=drugNameData + '<option id="'+j+'"';
									}
									else{
										drugNameData=drugNameData+ 'name="' +j+ '">' + j+'</option>';
									}
								}
							}
						}
					}
					jq(drugNameData).appendTo("#drugName");
					jq(drugFormulationData).appendTo("#drugFormulation");
				}).error(function(xhr, status, err) {
					alert('AJAX error ' + err);
				});
            });

            jq("#drugName").on("change",function(e){
                var drugName = jq(this).children(":selected").attr("name");
                var drugFormulationData = "<option id='0'>Select Formulation</option>";
				
				jq('#drugFormulation').empty();
				
                jq.getJSON('${ ui.actionLink("inventoryapp", "AddReceiptsToStore", "getFormulationByDrugName") }',{
                            drugName:drugName
                        })
                        .success(function(data) {
                            for (var key in data) {
                                if (data.hasOwnProperty(key)) {
                                    var val = data[key];
                                    for (var i in val) {
									var name,dosage;
                                        if (val.hasOwnProperty(i)) {
                                            var j = val[i];
                                            if(i=="id")
                                            {
                                               drugFormulationData=drugFormulationData + '<option id="'+j+'">';
                                            }
													else if (i == "name") {
											   name = j;
										   }
										   else {
											   dozage = j;
											   drugFormulationData = drugFormulationData + (name + "-" + dozage) + '</option>';
										   }
                                        }
                                    }
                                }
                            }
                            jq(drugFormulationData).appendTo("#drugFormulation");
                        })
                        .error(function(xhr, status, err) {
                            alert('AJAX error ' + err);
                        });
            });

			jq("#addDrugsSubmitButton").click(function(event) {
				addDescriptionDialog.show();
			});

			
			jq('input[type="text"]').keydown(function (e) {
				var numberFields = ['quantity','unitPrice','institutionalCost','costToThePatient'];
				
				if (jq.inArray(String(jq(this).attr('id')), numberFields)>=0){
					// Allow: backspace, delete, tab, escape, enter and .
					if (jq.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
						 // Allow: Ctrl+A, Command+A
						(e.keyCode == 65 && ( e.ctrlKey === true || e.metaKey === true ) ) || 
						 // Allow: home, end, left, right, down, up
						(e.keyCode >= 35 && e.keyCode <= 40)) {
							 // let it happen, don't do anything
							 return;
					}
					// Ensure that it is a number and stop the keypress
					if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
						e.preventDefault();
					}
				}
			});

        });

        function removerFunction(rowId) {
			if (confirm("Are you sure about this?")) {
				jq('#addDrugsTable > tbody > tr').remove();
				var tbody = jq('#addDrugsTable > tbody');
				var table = tbody.length ? tbody : jq('#addDrugsTable');
				drugOrder = jq.grep(drugOrder, function (item, index) {
					return (rowId !== index);
				});

				// jq('#' + rowId).remove();


				jq.each(drugOrder, function (rowId, item) {

					console.log(item);
					tbody.append('<tr id="' + (rowId + 1) + '"><td>' + (rowId + 1) + '</td><td>' + item.drugCategoryName + '</td><td>' + item.drugName +
							'</td><td>' + item.drugFormulationName + '</td><td>' + item.quantity +
							'</td><td>' + item.unitPrice + '</td><td>' + item.institutionalCost +
							'</td><td>' + item.costToThePatient + '</td><td>' + item.batchNo + '</td><td>' + item.companyName + '</td><td>' +
							item.dateOfManufacture + '</td><td>' + item.dateOfExpiry + '</td><td>' + item.receiptDate + '</td><td>' + item.receiptFrom +
							'</td><td><a onclick="removerFunction(' + rowId + ')" class="remover"><i class="icon-remove small" style="color:red"></i></a> ' +
							'<a class="remover" ><i class="icon-edit small" style="color:blue"></i></a></td></tr>');
				});
			}
			else {
					return false;
				}

        }

		function printSlip() {
			var printDiv = jq("#addDrugsTablePrintable").html();
			var printWindow = window.open('', '', 'height=400,width=800');
			printWindow.document.write('<html><head><title>Patient Information</title>');
			printWindow.document.write(printDiv);
			printWindow.document.write('</body></html>');
			printWindow.document.close();
			printWindow.print();
		}
		function clearSlip() {
			if (confirm("Are you sure about this?")) {
			jq('#addDrugsTable > tbody > tr').remove();
			} else {
				return false;
			}
		}
		function editorFunction(rowId) {
			//editor logic
		}
		function stringToDateConvert(stringDate)
		{
			var parts = stringDate.split('-');
			return Date.parse(new Date(parts[0], parts[1]-1, parts[2]));
		}

		function compare_DOE_DOM_DOR(dateOfExpiryString, dateOfManufactureString, dateOfReceiptString){
			console.log("Method has been called");
			console.log("Date of Expiry");
			console.log(dateOfExpiryString);
			console.log(dateOfManufactureString);
			console.log("Date of Receipt");
			console.log(dateOfReceiptString);
			dateOfManufacture = stringToDateConvert(dateOfManufactureString);
			dateOfExpiry = stringToDateConvert(dateOfExpiryString);
			dateOfReceipt = stringToDateConvert(dateOfReceiptString);

			if(dateOfManufacture > dateOfExpiry){
				jq().toastmessage('showErrorToast', 'Please review date of manufacture is greater than date of expiry');
				return false;
			}
			else if(dateOfReceipt > dateOfExpiry){
				jq().toastmessage('showErrorToast', 'Please review receipt date is greater than date of expiry');
				return false;
			}
			else if(dateOfManufacture > dateOfReceipt){
				jq().toastmessage('showErrorToast', 'Please review date of manufacture is greater than receipt date');
				return false;
			}else{
				return true;
			}
		}

    </script>

    <style>
		body {
			margin-top: 20px;
		}
		
		#modal-overlay{
			background: #000 none repeat scroll 0 0;
			opacity: 0.3!important;
		}

		.col1, .col2, .col3, .col4, .col5, .col6, .col7, .col8, .col9, .col10, .col11, .col12 {
			color: #555;
			text-align: left;
		}

		form input,
		form select {
			margin: 0px;
			display: inline-block;
			min-width: 50px;
			padding: 2px 10px;
			height: 32px !important;
		}

		.info-header span {
			cursor: pointer;
			display: inline-block;
			float: right;
			margin-top: -2px;
			padding-right: 5px;
		}

		.dashboard .info-section {
			margin: 2px 5px 5px;
		}

		.toast-item {
			background-color: #222;
		}

		@media all and (max-width: 768px) {
			.onerow {
				margin: 0 0 100px;
			}
		}

		form .advanced {
			background: #363463 none repeat scroll 0 0;
			border-color: #dddddd;
			border-style: solid;
			border-width: 1px;
			color: #fff;
			cursor: pointer;
			float: right;
			padding: 6px 0;
			text-align: center;
			width: 27%;
		}

		form .advanced i {
			font-size: 22px;
		}

		.col4 label {
			width: 110px;
			display: inline-block;
		}

		.col4 input[type=text] {
			display: inline-block;
			padding: 4px 10px;
		}

		.col4 select {
			padding: 4px 10px;
		}

		form select {
			min-width: 50px;
			display: inline-block;
		}

		.identifiers span {
			border-radius: 50px;
			color: white;
			display: inline;
			font-size: 0.8em;
			letter-spacing: 1px;
			margin: 5px;
		}

		table.dataTable thead th, table.dataTable thead td {
			padding: 5px 10px;
		}

		input[type="text"], select {
			border: 1px solid #aaa;
			border-radius: 2px !important;
			box-shadow: none !important;
			box-sizing: border-box !important;
			height: 32px;
			width: 250px;
			padding: 5px 0 5px 10px;
		}

		.newdtp {
			width: 166px;
		}

		#lastDayOfVisit label,
		#referred-date label {
			display: none;
		}

		#lastDayOfVisit input {
			width: 160px;
		}

		.add-on {
			color: #f26522;
			float: right;
			left: auto;
			margin-left: -29px;
			margin-top: 2px;
			position: absolute;
			right: 25px;
		}

		.chrome .add-on {
			margin-left: -31px;
			margin-top: -27px !important;
			position: relative !important;
		}

		#lastDayOfVisit-wrapper .add-on {
			margin-top: 5px;
		}

		.ui-widget-content a {
			color: #007fff;
		}

		#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
			text-decoration: none;
		}

		.new-patient-header .identifiers {
			margin-top: 5px;
		}

		.name {
			color: #f26522;
		}

		#inline-tabs {
			background: #f9f9f9 none repeat scroll 0 0;
		}

		.formfactor {
			background: #f3f3f3 none repeat scroll 0 0;
			border: 1px solid #ddd;
			margin-bottom: 5px;
			padding: 5px 10px;
			text-align: left;
			width: auto;
		}

		.formfactor .lone-col {
			display: inline-block;
			margin-top: 5px;
			overflow: hidden;
			width: 100%;
		}

		.formfactor .first-col {
			display: inline-block;
			margin-top: 5px;
			overflow: hidden;
			width: 300px;
		}

		.formfactor .second-col {
			display: inline-block;
			float: right;
			margin-top: 5px;
			overflow: hidden;
			width: 600px;
		}

		.formfactor .lone-col input,
		.formfactor .first-col input,
		.formfactor .second-col input {
			margin-top: 5px;
			padding: 5px 15px;
			width: 100%;
		}

		.formfactor .lone-col label,
		.formfactor .first-col label,
		.formfactor .second-col label {
			padding-left: 5px;
			color: #363463;
			cursor: pointer;
		}

		.ui-tabs-panel h2 {
			display: inline-block;
		}
		
		#addDrugsTable {
			font-size: 9px;
			margin-top: 40px;
		}
		
		.dialog li label span{
			color: #f00;
			float: right;
			margin-right: 10px;
		}
		
		.dialog label{
			display: inline-block;
			width: 180px;
		}
		.dialog select {
			display: inline-block;
			margin: 0;
			padding: 2px 0 2px 5px;
			width: 250px;
		}
		.dialog .dialog-content li {
			margin-bottom: 2px;
		}
		.dialog .dialog-content {
			padding: 5px 20px 0;
		}
		.dialog select option {
			font-size: 1.0em;
		}
		td a,
		td a:hover{
			text-decoration: none;
		}
		.red{
			border: 1px solid #f00!important;
		}
		
		#dateOfExpiry label,
		#receiptDate label,
		#dateOfManufacture label{
			display: none;
		}
		th:first-child{
			width: 5px;
		}
		th:nth-child(4){
			min-width: 75px;
		}
		th:nth-child(5),
		th:nth-child(7){
			min-width: 30px;
		}
		th:nth-child(6),
		th:nth-child(8),
		th:nth-child(11),
		th:nth-child(12),
		th:nth-child(13),
		th:nth-child(14){
			min-width: 30px;
		}
		th:nth-child(9){
			min-width: 40px;
		}
		th:nth-child(10) {
			min-width: 50px;
		}
		th:last-child{
			width: 35px;
		}
		form input:focus, form select:focus, form textarea:focus, form ul.select:focus, .form input:focus, .form select:focus, .form textarea:focus, .form ul.select:focus{
			outline: 2px none #007fff;
			box-shadow: 0 0 2px 0 #888 !important;
		}
		#footer{
			height: 50px;
			margin-top: 5px;
		}
		
		#footer img{
			float: left;
			height: 20px;
			margin-right: 5px;
			margin-top: 6px;
		}
		
		#footer span{
			color: #777;
			float: left;
			font-size: 12px;
			margin-top: 8px;
		}
		#footer input{
			float: right;
		}
    </style>
</head>

<body>
<div class="clear"></div>

<div class="container">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
                    <i class="icon-home small"></i></a>
            </li>
			
			<li>
                <a href="${ui.pageLink('inventoryapp', 'main')}">
					<i class="icon-chevron-right link"></i>Inventory
				</a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                Receipts
            </li>
        </ul>
    </div>

    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>ADD RECEIPTS TO GENERAL STORE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
            </h1>
        </div>

        <div id="addDrugsTablePrintable">
            <table id="addDrugsTable">
                <thead>
					<tr role="row">
						<th title="Record ID"				>#</th>
						<th title="Drug Category"			>CATEGORY</th>
						<th title="Drug Name"				>NAME</th>
						<th title="Formulation"				>FORMULATION</th>
						<th title="Quantity"				>QNTY</th>
						<th title="Unit Price"				>PRICE</th>
						<th title="Institutional Cost(%)"	>I.COST</th>
						<th title="Cost To The Patient"		>COST</th>
						<th title="Batch Number"			>BATCH#</th>
						<th title="Company Name"			>COMPANY</th>
						<th title="Date of Manufacture"		>D.O.M</th>
						<th title="Expiry Date"				>D.O.E</th>
						<th title="Receipt Date"			>R.D</th>
						<th title="Receipt From"			>FROM</th>
						<th title="Task Actions"			>&nbsp;</th>
					</tr>
                </thead>

                <tbody>
                </tbody>
            </table>
        </div>
		
		<div id="footer">
			<img src="../ms/uiframework/resource/inventoryapp/images/tooltip.jpg" />
			<span>Place the mouse over the Titles to get the meaning in full</span>
			
            <input type="button" value="Submit" class="button task" name="addDrugsSubmitButton" id="addDrugsSubmitButton" style="margin-right:0px;"/>
			<input type="button" value="Add" class="button confirm" name="addDrugsButton" id="addDrugsButton"/>
			<input type="button" value="Clear Slip" onclick="clearSlip()" class="button cancel" name="clearSlip" id="clearSlip"/>
			<input type="button" value="Print Slip" onclick="printSlip()" class="button task" name="printSlip" id="printSlip"/>
		</div>

    </div>
</div>

<div id="addDrugDialog" class="dialog" style="display:none; width:480px">
    <div class="dialog-header">
        <i class="icon-folder-open"></i>
        <h3>ADD RECEIPTS</h3>
    </div>
    <form class="dialog-content">
        <ul>
            <li>
                <label for="listCategory">Drug Category<span>*</span></label>
                <select name="drugCategory" id="drugCategory" >
                    <option id="0">Select Category</option>
                    <% if (listCategory!=null || listCategory!="") { %>
                    <% listCategory.each { drugCategory -> %>
                        <option id="${drugCategory.id}">${drugCategory.name}</option>
                    <% } %>
                    <% } %>
                </select>
            </li>
            <li>
                <label for="drugName">Drug Name<span>*</span></label>
                <select name="drugName" id="drugName" >
                    <option id="0">Select Drug</option>
                </select>
            </li>
            <li>
                <label for="drugFormulation">Formulation<span>*</span></label>
                <select name="drugFormulation" id="drugFormulation" >
                    <option id="0">Select Formulation</option>
                </select>
            </li>

            <li>
                <label for="quantity">Quantity<span>*</span></label>
                <input name="quantity" id="quantity" type="text" >
            </li>

            <li>
                <label for="unitPrice">Unit Price</label>
                <input name="unitPrice" id="unitPrice" type="text" >
            </li>

            <li>
                <label for="institutionalCost">Institutional Cost(%)</label>
                <input name="institutionalCost" id="institutionalCost" type="text" >
            </li>

            <li>
                <label for="costToThePatient">Cost To The Patient<span>*</span></label>
                <input name="costToThePatient" id="costToThePatient" type="text" >
            </li>

            <li>
                <label for="batchNo">Batch No.<span>*</span></label>
                <input name="batchNo" id="batchNo" type="text" >
            </li>

            <li>
                <label for="companyName">Company Name<span>*</span></label>
                <input name="companyName" id="companyName" type="text" >
            </li>

            <li>
                <label for="dateOfManufacture">Date of Manufacture<span>*</span></label>
				${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'dateOfManufacture',    id: 'dateOfManufacture',   label: '', useTime: false, defaultToday: false, class: ['newdtp']])}
            </li>

            <li>
                <label for="dateOfExpiry">Date of Expiry<span>*</span></label>
				${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'dateOfExpiry',    id: 'dateOfExpiry',   label: '', useTime: false, defaultToday: false, class: ['newdtp']])}
            </li>

            <li>
                <label for="receiptDate">Receipt Date<span>*</span></label>
				${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'receiptDate',    id: 'receiptDate',   label: '', useTime: false, defaultToday: false, class: ['newdtp']])}
            </li>

            <li>
                <label for="receiptFrom">Receipt From</label>
                <input name="receiptFrom" id="receiptFrom" type="text" >
            </li>

        </ul>

        <span class="button confirm right" > Confirm </span>
        <span class="button cancel"> Cancel </span>
    </form>
</div>

<div id="addDescriptionDialog" class="dialog" style="display:none; width:480px">
	<div class="dialog-header">
		<i class="icon-folder-open"></i>
		<h3>ADD Description</h3>
	</div>
	<form class="dialog-content">
		<textarea id="addReceiptsDescription"></textarea>

		<span class="button cancel"> Cancel </span>
		<span class="button confirm right" > Submit </span>
	</form>
</div>

</body>


