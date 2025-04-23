/*

Diagnostics for Ankita

////////////////////////////////////////////////////////////////////////////////
Class:              Diagnostics
Date:               02/11/2023
Last Updated:       02/11/2023
   
////////////////////////////////////////////////////////////////////////////////
*/

global class Diagnostics
{	
	// -------- Constants --------
	// Markers
    private final static String ENTERING = 'Entering: ';
    private final static String EXITING = 'Exiting: ';
    private final static String LOG = 'Diagnostics Log:\n';
    private final static String START_ERROR = 'Exception occurred: ';
	
	// -------- Constructor --------
	// None

    // -------- Variables --------
	// Is logging enabled
	@TestVisible
	private static Boolean diagnosticsEnabled = true;
	
	// Track the current logging level
	private static Integer currentLevel = 0;
	
	// Track if an exception was thrown to quit popping logs after caught
	private static Boolean lastLog = false;
	private static Boolean exceptionThrown = false;
	
	// -------- Properties --------
	// Logging list
	@TestVisible
	private static List<Logging> logs;
	
	// Method entries and exits
	private static List<String> methodSteps;
	
	// -------- Methods --------
	// Methods for recording level and log entries
	public static void push(String methodName)
	{
		if(diagnosticsEnabled)
		{
			if(methodSteps == null)
			{
				methodSteps = new List<String>();
			}
			
			methodSteps.add(methodName);
			debug(ENTERING + methodName);
			currentLevel++;
		}
	}
	
	public static void pop()
	{
		if(diagnosticsEnabled)
		{
			if(currentLevel > 0)
			{
				try
				{
					debug(EXITING + methodSteps[currentLevel - 1]);
					methodSteps.remove(currentLevel - 1);
				}
				catch (ListException listError)
				{
					// ignored
				}
				
				currentLevel--;
			}
			
			if(currentLevel == 0 && !lastLog)
			{
				System.debug(LoggingLevel.ERROR, LOG + currentLog() + '\n');
				lastLog = exceptionThrown;
			}
		}
	}
	
	public static void popAll()
	{
		currentLevel = 0;
		pop();
	}
	
	// Recording the log messages; ignore exit method recording if push call
	// was not made; Break on fatal exception
	public static void debug(String message)
	{
		if(diagnosticsEnabled)
		{
			if(logs == null)
			{
				logs = new List<Logging>();
			}
			
			logs.add(new Logging(message));
		}
	}
	
	public static void exception(Exception error)
	{
		debug(START_ERROR + error.getLineNumber() + ' - ' + 
			error.getMessage() + '\n' + 
			error.getStackTraceString());
	}
	
	public static void exceptionFatal(Exception error)
	{
		debug(START_ERROR + error.getLineNumber() + ' - ' + 
			error.getMessage() + '\n' + 
			error.getStackTraceString());
		
		if(diagnosticsEnabled)
		{
			try
			{
				debug(EXITING + methodSteps[methodSteps.size() - 1]);
			}
			catch (ListException listError)
			{
				// ignored
			}
			
			exceptionThrown = true;
			popAll();
		}
	}
	
	// Retrieving the log messages
	private static String currentLog()
	{
		String result;
		
		if(logs != null)
		{
			result = '';
			
			for(Logging record : logs)
			{
				result += record.description + '\n';
			}
		}
		
		return result;
	}
	
	// -------- Internal Classes --------
	private class Logging
	{
		Integer level;
		String description;
		
		public Logging(String message)
		{
			level = CurrentLevel;
			description = message;
		}	
	}
}