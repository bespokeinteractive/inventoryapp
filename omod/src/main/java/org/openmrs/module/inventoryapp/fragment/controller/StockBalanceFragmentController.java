package org.openmrs.module.inventoryapp.fragment.controller;

import org.apache.commons.lang3.StringUtils;
import org.openmrs.Role;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryStore;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugTransactionDetail;
import org.openmrs.module.hospitalcore.model.InventoryStoreRoleRelation;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.module.inventory.util.PagingUtil;
import org.openmrs.module.inventory.util.RequestUtil;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


public class StockBalanceFragmentController {
    public void controller() {

    }

    public List<SimpleObject> fetchStockBalance(@RequestParam(value="categoryId",required=false)  Integer categoryId,
                                                @RequestParam(value="drugName",required=false)  String drugName,
                                                @RequestParam(value = "currentPage", required = false) Integer currentPage,
                                                HttpServletRequest request,
                                                 UiUtils uiUtils) {
        List<SimpleObject> stockBalanceList = null;
        InventoryService inventoryService = (InventoryService) Context.getService(InventoryService.class);
        List <Role>role=new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles());

        InventoryStoreRoleRelation inventoryStoreRoleRelation=null;
        Role rolePerson = null;
        for(Role roleUser : role){
            if(inventoryService.getStoreRoleByName(roleUser.toString())!=null){
                inventoryStoreRoleRelation = inventoryService.getStoreRoleByName(roleUser.toString());
                rolePerson= roleUser;
            }
        }
        InventoryStore store =null;
        if(inventoryStoreRoleRelation!=null){
            store = inventoryService.getStoreById(inventoryStoreRoleRelation.getStoreid());
        }
        int total = inventoryService.countViewStockBalance(store.getId(), categoryId, drugName, "" ,"", "" , false);
        String temp = "";

        if(categoryId != null){
            temp = "?categoryId="+categoryId;
        }
        if(drugName != null){
            if(StringUtils.isBlank(temp)){
                temp = "?drugName="+drugName;
            }else{
                temp +="&drugName="+drugName;
            }
        }
        PagingUtil pagingUtil = new PagingUtil( RequestUtil.getCurrentLink(request)+temp ,0,currentPage,total );
        List<InventoryStoreDrugTransactionDetail> stockBalances = inventoryService.listViewStockBalance(store.getId(), categoryId, drugName,"","","",false,pagingUtil.getStartPos(),0);

        if (stockBalances!=null) {
            Collections.sort(stockBalances);
            stockBalanceList = SimpleObject.fromCollection(stockBalances, uiUtils, "drug.id","drug.name","drug.category.name","drug.category.id","formulation.id","formulation.name","formulation.dozage","quantity","issueQuantity","currentQuantity","drug.reorderQty");

        }
        return stockBalanceList;
    }
}