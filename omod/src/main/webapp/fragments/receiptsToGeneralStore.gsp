
<script>
    var receiptsDataString;
    jq(function () {
        var receiptsData = getReceitsToGeneralStore();
        receiptsDataString = JSON.stringify(receiptsData);
        function ReceiptsDataListView() {
            var self = this;
            // Editable data
            self.receiptsDataItems = ko.observableArray([]);
            ;
            var mappedReceiptsDataItems = jQuery.map(receiptsData, function (item) {
                return item;
            });

            self.viewDetails = function (item) {
                window.location.replace("detailedReceiptOfDrug.page?receiptId=" + item.id);

            }
            self.receiptsDataItems(mappedReceiptsDataItems);

        }

        var list = new ReceiptsDataListView();
        ko.applyBindings(list, jq("#receiptslist")[0]);
    });
    function getReceitsToGeneralStore(receiptName, fromDate, toDate) {
        var toReturn;
        jQuery.ajax({
            type: "GET",
            url: '${ui.actionLink("inventoryapp", "receiptsToGeneralStore", "fetchReceiptsToGeneralStore")}',
            dataType: "json",
            global: false,
            async: false,
            data: {
                receiptName: receiptName,
                fromDate: fromDate,
                toDate: toDate
            },
            success: function (data) {
                toReturn = data;
            }
        });
        return toReturn;
    }
</script>

<table id="receiptslist">
    <label for="receiptName">Description</label>
    <input type="text" id="receiptName" name="receiptName" placeholder="Receipt Name" class="searchFieldBlur"
           title="Receipt Name"/>
    <label for="rFromDate">From</label>
    <input type="text" id="rFromDate" class="date-pick searchFieldChange searchFieldBlur" readonly="readonly"
           name="rFromDate"
           title="Double Click to Clear" ondblclick="this.value = '';"/>
    <label for="toDate">To</label>
    <input type="text" id="toDate" class="date-pick searchFieldChange searchFieldBlur" readonly="readonly" name="toDate"
           title="Double Click to Clear" ondblclick="this.value = '';"/>
    <thead>
    <th>S.No</th>
    <th>Description</th>
    <th>Created On</th>
    </thead>
    <tbody data-bind="foreach: receiptsDataItems">
    <td data-bind="text: \$index() + 1"></td>
    <td><a data-bind="html:description ,click:\$parent.viewDetails"></a></td>
    <td data-bind="text: createdOn"></td>
    </tbody>
</table>

<a href="addReceiptsToGeneralStore.page">Add Receipts</a>
