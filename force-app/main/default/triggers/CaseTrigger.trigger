trigger CaseTrigger on Case (before insert, before update) { // there is no point in having before + after update
    new.CaseTriggerHandler().run();
}