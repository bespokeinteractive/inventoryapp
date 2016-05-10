<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Drug Receipt Details"])

    ui.includeCss("billingui", "jquery.dataTables.min.css")
    ui.includeCss("registration", "onepcssgrid.css")

    ui.includeJavascript("billingui", "moment.js")
    ui.includeJavascript("billingui", "jquery.dataTables.min.js")
    ui.includeJavascript("laboratoryapp", "jq.browser.select.js")
    ui.includeJavascript("billingui", "jquery.PrintArea.js")
%>

<script>
    jq(document).ready(function () {
		var simple = ${transactionDetails};
		var simpleObjects = simple.simpleObjects;

		updateQueueTable(simpleObjects);
	
		function print () {
            var printDiv = jQuery("#print").html();
            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write('<html><head><title>Information</title>');
            printWindow.document.write(printDiv);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }

        jq("#printButton").on("click", function(e){
            print().show();
        });
		
		
    });
	
	function updateQueueTable(dataRows) {
        jq('#print-table > tbody > tr').remove();
        var tbody = jq('#print-table > tbody');

        for (index in dataRows) {
            var row = '<tr>';
            var item = dataRows[index];
			
			row += '<td>' + String(item.quantity).formatToAccounting(0) + '</td>';
			row += '<td>' + String(item.unitPrice).formatToAccounting() + '</td>';
			row += '<td>' + String(item.VAT).formatToAccounting() + '%</td>';
			row += '<td>' + String(item.costToPatient).formatToAccounting() + '</td>';
			
			row += '<td>' + item.batchNo + '</td>';
			row += '<td>' + item.companyName + '</td>';
			row += '<td>' + item.dateManufacture.substring(0, 11).replaceAt(2, ",").replaceAt(6, " ") + '</td>';
			row += '<td>' + item.dateExpiry.substring(0, 11).replaceAt(2, ",").replaceAt(6, " ") + '</td>';
			
			row += '<td>' + item.createdOn.substring(0, 11).replaceAt(2, ",").replaceAt(6, " ") + '</td>';
			row += '<td>' + item.receiptFrom + '</td>';

            row += '</tr>';
            tbody.append(row);
        }
    }
</script>

<style>
	.new-patient-header .identifiers {
		margin-top: 5px;
	}
	.name {
		color: #f26522;
	}
	#inline-tabs{
		background: #f9f9f9 none repeat scroll 0 0;
	}
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	#show-icon{
		background: rgba(0, 0, 0, 0) url("../ms/uiframework/resource/inventoryapp/images/inventory-icon.png") no-repeat scroll 0 0 / 100% auto;
		display: inline-block;
		float: right;
		height: 50px;
		margin-bottom: -40px;
		margin-top: 10px;
		width: 60px;
	}
	.exampler {
		background-color: #fff;
		border: 1px solid #ddd;
		border-radius: 2px;
		display: block;
		margin: 65px 0 3px;
		padding: 10px;
		position: relative;
	}
	.exampler::after {
		background: #f9f9f9 none repeat scroll 0 0;
		border: 1px solid #ddd;
		color: #969696;
		content: "Drug Summary";
		font-size: 12px;
		font-weight: bold;
		left: -1px;
		padding: 5px 10px;
		position: absolute;
		top: -29px;
	}
	.exampler div {
		background: rgba(0, 0, 0, 0) url("../ms/uiframework/resource/inventoryapp/images/drugs-icon.jpg") no-repeat scroll 10px 0 / auto 100%;
		padding-left: 90px;
		color: #363463;
	}
	.exampler div span{
		color: #555;
		float: left;
		font-size: 0.9em;
		text-transform: uppercase;
		width: 120px;
	}
	table{
		font-size: 14px;
	}
	td:first-child{
		width:30px;
	}
	td:nth-child(2),
	td:nth-child(3),
	td:nth-child(4){
		width:45px;
	}
	td:nth-child(7),
	td:nth-child(8),
	td:nth-child(9){
		width:80px;
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
	#footer button{
		float: right;
	}
	
	
</style>

<div class="container">
	<div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
					<i class="icon-home small"></i>
				</a>
            </li>
			
			<li>
                <a href="${ui.pageLink('inventoryapp', 'main')}">
					<i class="icon-chevron-right link"></i>Inventory
				</a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                Drug Receipt Details
            </li>
        </ul>
    </div>
	
	<div class="patient-header new-patient-header">
		<div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>VIEW CURRENT DRUG STOCK &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
            </h1>
        </div>
		
		<div id="show-icon">
			&nbsp;
		</div>
		
		<div class="exampler">
			<div>
				<span>Drug Name:</span><b>${drug.name}</b><br/>
				<span>Category:</span>${drug.category.name}<br/>
				<span>Formulation:</span>${formulation.name}-${formulation.dozage}<br/>
			</div>
		</div>
	</div>
</div>

<div id="print" style="display: block; margin-top:3px;">
	<table id="print-table" aria-describedby="expiry-detail-results-table_info">
		<thead>
			<tr align="center">
				<th title="Quantity"			>QTY</th>
				<th title="Unit Price"			>PRICE</th>
				<th title="Institutional Cost"	>I.COST</th>
				<th title="Cost To The Patient"	>COST</th>
				<th title="Batch Number"		>BATCH#</th>
				<th title="Company"				>COMPANY</th>
				<th title="Date of Manufacture"	>MANUF</th>
				<th title="Date of Manufacture"	>EXPIRY</th>
				<th title="Receipt Date"		>DATE</th>
				<th title="Receipt From"		>FROM</th>
			</tr>
		</thead>
		
		<tbody>
			<tr align="center">
				<td colspan="10">No Drugs found</td>
			</tr>
		</tbody>
	</table>
</div>

<div id="footer">
	<img src="../ms/uiframework/resource/inventoryapp/images/tooltip.jpg" />
	<span>Place the mouse over the Titles to get the meaning in full</span>
	
	<button class="button task" type="button" id="printButton"><i class="icon-print small"> </i>Print</button>
</div>
