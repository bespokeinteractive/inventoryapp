package org.openmrs.module.inventoryapp.page.controller;

import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.api.context.Context;
import java.util.Set;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.module.inventory.InventoryService;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by USER on 3/18/2016.
 */
public class ViewCurrentStockBalanceDetailPageController {
    public void get(@RequestParam(value = "drugId", required = false) Integer drugId,
                    @RequestParam(value = "formulationId", required = false) Integer formulationId,
                    @RequestParam(value = "expiry", required = false) Integer expiry,
                    PageModel pageModel){
        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);

        pageModel.addAttribute("drugId",drugId);
        pageModel.addAttribute("formulationId",formulationId);
        pageModel.addAttribute("expiry",expiry);

        InventoryDrug drug = inventoryService.getDrugById(drugId);
        Set <InventoryDrugFormulation> formulations = drug.getFormulations();

        System.out.println(formulations.size());

        for (InventoryDrugFormulation idf : formulations){
            System.out.println(idf.getId() +" "+ formulationId);

            if (idf.getId().intValue() == formulationId.intValue()){
                System.out.println("Match");
                pageModel.addAttribute("formulation",idf);
            }
        }

        pageModel.addAttribute("drug",drug);

    }

}
