/*
	Created By : Ankita Dhamgaya
  Dispatcher for all triggers, keeping track of what to call for which object

  Class:              TriggerDispatcher
  Date:               02/11/2023
  Last Updated:       02/11/2023

  ////////////////////////////////////////////////////////////////////////////////
*/

global class TriggerDispatcher {

	// -------- Variables --------
	// Map for matching running handlers
	@TestVisible
	private static Map<String, ITriggerHandler> handlers = new Map<String, ITriggerHandler> ();

	// For setting test run fo Test_TriggerFramework
	private static ApexTrigger testFile;
	private static Boolean testRun = false;

	// boolean for recursion fix
	global static Boolean fixRecursion = true;

	// -------- Methods --------
	// Only method called from the trigger; this determines the handler to
	// create and calls the methods in the handler based on its status
	global static void execute(Schema.sObjectType soType, List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
		ITriggerHandler handler;
		String executingOn = getObjectName(soType);

        System.debug('====getObjectName=========33================>'+executingOn);
		if (executingOn != null) {
			handler = activateHandler(executingOn);
		}

		if (handler == null) {
			throw new NoHandlerException('Handler is Null');
		} else {
			if (testRun) {
				return;
			}
			if (handler.isRunning()) {
				handler.qualifyReEntryRecords(newList, oldList, newMap, oldMap);
				handler.reEntry();
				handler.finish(false);
			} else {
				handler.startRunning();
				handler.qualifyStartingRecords(newList, oldList, newMap, oldMap);
				handler.start();
				handler.finish(true);
				if (fixRecursion) {
					handler.stopRunning();
				}
			}
		}
	}

	// Return the object name the trigger is being run on
	private static String getObjectName(Schema.sObjectType soType) {
		if (soType == null) {
			return null;
		}

		final Map<String, String> OBJ_HANDLER_NAMES = new Map<String, String> {
			'AccountContactRelation' => 'AccountContactRelat',
			'Business_Registration__c' => 'BusinessRegistration',
			'Credit_Application__c' => 'CreditApplication',
			'Credit_Check_Request__c' => 'CreditApp',
			'Customer_Portal_Ping_User__c'  => 'CustomerPortal_PU',
			'dfsle__Envelope__c' => 'Envelope',
			'dfsle__EnvelopeStatus__c' => 'EnvelopeStatus',
			'dfsle__RecipientStatus__c' => 'RecipientStatus',
			'DS_Agreement__c' => 'DSAgreement',
			'Electric_Rate_Usage_Input__c' => 'ElectricRateUsageInput',
			'Interconnection_Application__c' => 'Interconnection',
			'Invoice_Compliance_Document__c' => 'InvoiceComplianceDoc',
			'Lead_Score_Configurator__c' => 'LeadScoreConfigurator',
			'Lead_Score_Criteria__c' => 'LeadScoreCriteria',
			'NIC_Task_Placeholder__c' => 'NICTask',
			'Payment_Receipt_Email__c' => 'PaymentReceipt',
			'Schedule_Preference__c' => 'SchedulePreference',
			'ServiceAppointment' => 'ServiceAppointment',
			'Service_Zip_Code__c' => 'ServiceZipCode',
			'Site_Information_Form__c' => 'Site',
			'sked__Job__c' => 'SkeduloJob',
			'sked__Job_Allocation__c' => 'skedJobAllocation',
			'sked__Region__c' => 'skedRegion',
			'sked__Resource__c' => 'skedResource',
			'TwilioSF__Message__c' => 'TwilioMessages',
			'Project_Task_Dependency__c' => 'PtTskDependency',
			'Sunpower_Spectrum_Debug_Log__c' => 'SpectrumDebugLog',
			'FPO_Order_Line__c' => 'FPOOrderLineTrigger',
			'Residential_Project_Risk_Record__c' => 'RPRiskRecord'};

		String result;
		String soName = soType.getDescribe().getName();
		if (OBJ_HANDLER_NAMES.containsKey(soName)) {
			result = OBJ_HANDLER_NAMES.get(soName);
		} else {
			result = soName;
		}
		// Cut the '__c' part.
		if (String.IsNotBlank(result) && result.toLowerCase().endsWith('__c')) {
			Integer index = result.toLowerCase().indexOf('__c');
			result = result.substring(0, index);
		}
		return result;
	}

	// Return the appropriate handler if exists, or creates a new one
	private static ITriggerHandler activateHandler(String executingOn) {
		ITriggerHandler result;

		if (testRun) {
			result = determineHandler(executingOn,
			(testFile.UsageBeforeInsert || testFile.UsageBeforeUpdate || testFile.UsageBeforeDelete),
			(testFile.UsageAfterInsert || testFile.UsageAfterUpdate || testFile.UsageAfterDelete || testFile.UsageAfterUndelete),
			(testFile.UsageBeforeInsert || testFile.UsageAfterInsert),
			(testFile.UsageBeforeUpdate || testFile.UsageAfterUpdate),
			(testFile.UsageBeforeDelete || testFile.UsageAfterDelete),
			                          testFile.UsageAfterUndelete);
		} else {
			result = determineHandler(executingOn, Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUnDelete);
		}
        System.debug('==result=======127===========>'+result);
		return result;
	}

	// Determine and return the handler for both normal and test coverage
	private static ITriggerHandler determineHandler(String executingOn, Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUnDelete) {
		ITriggerHandler result;
		String handlerName;

		if (isBefore) {
			if (isInsert) {
				handlerName = executingOn + 'BeforeInsertHandler';

				if (handlers.containsKey(handlerName) && !Util.isSkipTrigger(handlerName, null)) {
					result = handlers.get(handlerName);
				}
			} else if (isUpdate) {
				handlerName = executingOn + 'BeforeUpdateHandler';

				if (handlers.containsKey(handlerName) && !Util.isSkipTrigger(handlerName, null)) {
					result = handlers.get(handlerName);
				}
			} else if (isDelete) {
				handlerName = executingOn + 'BeforeDeleteHandler';

				if (handlers.containsKey(handlerName) && !Util.isSkipTrigger(handlerName, null)) {
					result = handlers.get(handlerName);
				}
			}
		} else if (isAfter) {
			if (isInsert) {
				handlerName = executingOn + 'AfterInsertHandler';
				if (handlers.containsKey(handlerName) && !Util.isSkipTrigger(handlerName, null)) {
					result = handlers.get(handlerName);
				}
			} else if (isUpdate) {
				handlerName = executingOn + 'AfterUpdateHandler';

				if (handlers.containsKey(handlerName) && !Util.isSkipTrigger(handlerName, null)) {
					result = handlers.get(handlerName);
				}
			} else if (isDelete) {
				handlerName = executingOn + 'AfterDeleteHandler';

				if (handlers.containsKey(handlerName) && !Util.isSkipTrigger(handlerName, null)) {
					result = handlers.get(handlerName);
				}
			} else if (isUnDelete) {
				handlerName = executingOn + 'AfterUnDeleteHandler';

				if (handlers.containsKey(handlerName) && !Util.isSkipTrigger(handlerName, null)) {
					result = handlers.get(handlerName);
				}
			}
		}

		if (result == null) {
			Type classType = Type.forName(handlerName);
			result = (classType == null) ? null : (ITriggerHandler) classType.newInstance();
			handlers.put(handlerName, result);
		}
		return result;
	}

	// For other classes to determine if a handler is running
	global static Boolean isHandlerRunning(String handlerName) {
		Boolean result = false;

		if (handlers.containsKey(handlerName)) {
			result = handlers.get(handlerName).isRunning();
		}
		return result;
	}

	// For resetting the trigger dispatcher during testing
	@TestVisible
	private static Boolean resetHandler(String handlerName) {
		Boolean result = false;

		ITriggerHandler handler = handlers.get(handlerName);

		if (handler != null) {
			handler.stopRunning();
			result = true;
		}
		return result;
	}

	// For framework testing
	@TestVisible
	private static void setFrameworkTestParameters(ApexTrigger file, Boolean run) {
		testFile = file;
		testRun = run;
	}
}