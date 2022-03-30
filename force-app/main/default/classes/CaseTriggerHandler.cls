public with sharing class CaseTriggerHandler extends TriggerHandler{
    private List<Case> oldCaseList, newCaseList;
    private Map<Id, Case> oldCaseMap, newCaseMap;

    public CaseTriggerHandler(){
        oldCaseList = (List<Case>) Trigger.old;
        newCaseList = (List<Case>) Trigger.new;

        oldCaseMap = (Map<Id, Case>) Trigger.oldCaseMap;
        newCaseMap = (Map<Id, Case>) Trigger.newCaseMap;

    }

    protected override void beforeInsert(){
        CaseTriggerHelper.checkReservation(newCaseList);
    }

    protected override void beforeUpdate(){
        CaseTriggerHelper.notifyForReservation(newCaseList, oldCaseMap);
    }
}