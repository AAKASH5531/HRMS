/*
 
    Created By : Ankita Dhamgaya
    Handler interface, listing the required methods for implementation
    
    Class:              ITriggerHandler
    Date:               02/11/2023
    Last Updated:       02/11/2023 
  ////////////////////////////////////////////////////////////////////////////////
*/

global interface ITriggerHandler
{
	Boolean isRunning();
	void startRunning();
	void stopRunning();
	void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap);
	void start();
	void qualifyReEntryRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap);
	void reEntry();
	void finish(Boolean fromStart);
}