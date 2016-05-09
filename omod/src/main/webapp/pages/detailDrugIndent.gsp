<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Detailed Drug Indent"])
    ui.includeCss("billingui", "jquery.dataTables.min.css")
    ui.includeCss("registration", "onepcssgrid.css")

    ui.includeJavascript("billingui", "moment.js")
    ui.includeJavascript("billingui", "jquery.dataTables.min.js")
    ui.includeJavascript("laboratoryapp", "jq.browser.select.js")
    ui.includeJavascript("billingui", "jquery.PrintArea.js")
%>
<script>
    INDENT = {

        detailDrugIndent: function (indentId) {
            if (SESSION.checkSession()) {
                url = "detailDrugIndent.form?indentId=" + indentId + "&keepThis=false&TB_iframe=true&height=500&width=1000";
                tb_show("Detail Indent Drug....", url, false);
            }
        }
    }
</script>

<script>

    jq(document).ready(function () {
        function print() {
            var printDiv = jQuery("#print").html();
            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write('<html><head><title>Information</title>');
            printWindow.document.write(printDiv);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }

        jq("#printButton").on("click", function (e) {
            print().show();
        });
    });
</script>

<style>
body {
    margin-top: 20px;
}

#modal-overlay {
    background: #000 none repeat scroll 0 0;
    opacity: 0.3 !important;
}

.col1, .col2, .col3, .col4, .col5, .col6, .col7, .col8, .col9, .col10, .col11, .col12 {
    color: #555;
    text-align: left;
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

.identifiers span {
    border-radius: 50px;
    color: white;
    display: inline;
    font-size: 0.8em;
    letter-spacing: 1px;
    margin: 5px;
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

td a,
td a:hover {
    text-decoration: none;
}

.red {
    border: 1px solid #f00 !important;
}

table th, table td {
    padding: 5px;
}

#nullsOut {
    font-size: 12px;
    margin-top: 3px;
}

#nullsOut th:nth-child(5),
#nullsOut th:nth-child(6) {
    width: 65px;
}

#nullsOut th:nth-child(7) {
    width: 75px;
}

#nullsOut th:nth-child(8) {
    width: 60px;
}

#nullsOut th:last-child {
    width: 120px;
}

form input:focus, form select:focus, form textarea:focus, form ul.select:focus, .form input:focus, .form select:focus, .form textarea:focus, .form ul.select:focus {
    outline: 2px none #007fff;
    box-shadow: 0 0 2px 0 #888 !important;
}

#footer {
    height: 50px;
    margin-top: 5px;
}

#footer img {
    float: left;
    height: 20px;
    margin-right: 5px;
    margin-top: 6px;
}

#footer span {
    color: #777;
    float: left;
    font-size: 12px;
    margin-top: 8px;
}

#footer button {
    float: right;
}

.hide {
    display: none;
}
</style>

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
                Manage Indents
            </li>
        </ul>
    </div>

    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>DRUG INDENT DETAILS &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
            </h1>
        </div>
    </div>
</div>

<div id="print">
    <% if (listTransactionDetail == null && listTransactionDetail.size() == 0) { %>
    <div style="margin: 10px auto; width: 981px; font-size: 1.0em;font-family:'Dot Matrix Normal',Arial,Helvetica,sans-serif;">
        <div class='hide'>
            <br/>
            <br/>
            <center style="float:center;font-size: 2.2em">Indent From ${store.name}</center>
            <br/>
            <br/>
            <span style="float:right;font-size: 1.7em">Date: ${date}</span>
            <br/>
            <br/>
        </div>

        <table id="nullsInn">
            <thead>
            <tr>
                <th>#</th>
                <th>CATEGORY</th>
                <th>DRUG NAME</th>
                <th>FORMULATION</th>
                <th>INDENT QNTY</th>
                <th>TRANSFER QNTY</th>
            </tr>
            </thead>

            <% if (listIndentDetail != null || listIndentDetail.size() > 0) { %>
            <% listIndentDetail.eachWithIndex { indent, varStatus -> %>
            <tr class='${varStatus % 2 == 0 ? "oddRow" : "evenRow"}'>
                <td>${varStatus + 1}</td>
                <td>${indent.drug.category.name}</td>
                <td>${indent.drug.name}</td>
                <td>${indent.formulation.name}-${indent.formulation.dozage}</td>
                <td>${indent.quantity}</td>
                <td>${indent.mainStoreTransfer}</td>
            </tr>
            <% } %>
            <% } %>

        </table>

        <div class='hide'>
            <br/><br/><br/><br/><br/><br/>
            <span style="float:left;font-size: 1.5em">Signature of sub-store/ Stamp</span><span
                style="float:right;font-size: 1.5em">Signature of inventory clerk/ Stamp</span>
            <br/><br/><br/><br/><br/><br/>
            <span style="margin-left: 13em;font-size: 1.5em">Signature of Medical Superintendent/ Stamp</span>
        </div>
    </div>

    <% } else { %>
        <div class='hide'>
			<br/>
			<br/>
			<center style="float:center;font-size: 2.2em">Indent From ${store.name}</center>
			<br/>
			<br/>
			<span style="float:right;font-size: 1.7em">Date: ${date}</span>
			<br/>
			<br/>
		</div>
		
        <table id="nullsOut">
			<thead>
				<tr>
					<th>#</th>
					<th>CATEGORY</th>
					<th>DRUG NAME</th>
					<th>FORMULATION</th>
					<th>INDENT</th>
					<th>TRANSFER</th>
					<th>BATCH#</th>
					<th>EXPIRY</th>
					<th>COMPANY</th>
				</tr>
			</thead>

                <% if (listIndentDetail != null && listIndentDetail.size() > 0) { %>
                    <% listIndentDetail.eachWithIndex { indent, varStatus -> %>
                        <tr>
                        <td>${varStatus+1}</td>
                        <td>${indent.drug.category.name}</td>
                        <td>${indent.drug.name}</td>
                        <td>${indent.formulation.name}-${indent.formulation.dozage}</td>
                        <td>${indent.quantity}</td>

                        <% def count=0 %>
                        <% def check=0 %>
                        <% listTransactionDetail.each { trDetail, varIndex ->  %>
                            <% if (trDetail.drug.id == indent.drug.id && trDetail.formulation.id == indent.formulation.id) { %>
                                <% check=1 %>

                                    <% if (count > 0) { %>
                                            <td>${trDetail.issueQuantity}</td>
                                            <td>${trDetail.batchNo}</td>
                                            <td>${ui.formatDatePretty(trDetail.dateExpiry)}</td>
                                            <td>${trDetail.companyName}</td>
                                        </tr>
                                    <% } else {%>
											<td>${trDetail.issueQuantity}</td>
											<td>${trDetail.batchNo}</td>
											<td>${ui.formatDatePretty(trDetail.dateExpiry)}</td>
											<td>${trDetail.companyName}</td>
                                        </tr>
                                    <% } %>


                                <% count=count + 1 %>
                            <% } %>
                        <% } %>
                        <% if (check == 0){ %>
                            <td>0</td>
                            <td>N/A</td>
                            <td>N/A</td>
                            <td>N/A</td>
                            </tr>
                        <% } %>
                    <% } %>
                <% } %>

    <table id="nullsOut">
        <thead>
        <tr>
            <th>#</th>
            <th>CATEGORY</th>
            <th>DRUG NAME</th>
            <th>FORMULATION</th>
            <th>INDENT</th>
            <th>TRANSFER</th>
            <th>BATCH#</th>
            <th>EXPIRY</th>
            <th>COMPANY</th>
        </tr>
        </thead>

        <% if (listIndentDetail != null && listIndentDetail.size() > 0) { %>
        <% listIndentDetail.eachWithIndex { indent, varStatus -> %>
        <tr class='${varStatus % 2 == 0 ? "oddRow" : "evenRow"}'>
            <td>${varStatus + 1}</td>
            <td>${indent.drug.category.name}</td>
            <td>${indent.drug.name}</td>
            <td>${indent.formulation.name}-${indent.formulation.dozage}</td>
            <td>${indent.quantity}</td>

            <% def count = 0 %>
            <% def check = 0 %>git 
            <% listTransactionDetail.each { trDetail -> %>
            <% if (trDetail.drug.id == indent.drug.id && trDetail.formulation.id == indent.formulation.id) { %>
            <% check = 1 %>

            <% if (count > 0) { %>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td>${trDetail.issueQuantity}</td>
            <td>${trDetail.batchNo}</td>
            <td>${ui.formatDatePretty(trDetail.dateExpiry)}</td>
            <td>${trDetail.companyName}</td>
        </tr>
        <% } else { %>
        <td>${trDetail.issueQuantity}</td>
        <td>${trDetail.batchNo}</td>
        <td>${ui.formatDatePretty(trDetail.dateExpiry)}</td>
        <td>${trDetail.companyName}</td>
    </tr>
        <% } %>


        <% count = count + 1 %>
        <% } %>
        <% } %>
        <% if (check == 0) { %>
        <td>0</td>
        <td>N/A</td>
        <td>N/A</td>
        <td>N/A</td>
    </tr>
        <% } %>
        <% } %>
        <% } %>

    </table>

    <div class='hide'>
        <br/><br/><br/><br/><br/><br/>
        <span style="float:left;font-size: 1.5em">Signature of sub-store/ Stamp</span><span
            style="float:right;font-size: 1.5em">Signature of inventory clerk/ Stamp</span>
        <br/><br/><br/><br/><br/><br/>
        <span style="margin-left: 13em;font-size: 1.5em">Signature of Medical Superintendent/ Stamp</span>
    </div>

    <% } %>
</div>

<div id="footer">
    <img src="../ms/uiframework/resource/inventoryapp/images/tooltip.jpg"/>
    <span>Place the mouse over the Titles to get the meaning in full</span>

    <button class="button task" type="button" id="printButton"><i class="icon-print small"></i>Print</button>
</div>