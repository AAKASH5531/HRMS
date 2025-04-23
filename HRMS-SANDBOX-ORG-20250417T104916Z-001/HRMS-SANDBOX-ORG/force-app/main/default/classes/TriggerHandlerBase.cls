/*

  Base handler class for framework triggers, which all handler classes extend

  Class:              TriggerHandlerBase
  Author:               Ankita Dhamgaya
  Date:               03/11/2023

  ////////////////////////////////////////////////////////////////////////////////
*/

global abstract class TriggerHandlerBase implements ITriggerHandler {

	// -------- Variables --------
	// Record if running
	private Boolean initiaited = false;

	// -------- Properties --------
	// None

	// -------- Methods --------
	// Return if the handler is running
	global Boolean isRunning() {
		return initiaited;
	}

	// Set the running to true, called from the dispatcher
	global void startRunning() {
		initiaited = true;
	}

	// Set the running back to false, called from the dispatcher
	global void stopRunning() {
		initiaited = false;
	}

	// Required overrides
	global abstract void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap);
	global abstract void start();

	// Optional overrides
	global virtual void qualifyReEntryRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) { }
	global virtual void reEntry() { }
	global virtual void finish(Boolean fromStart) { }
}