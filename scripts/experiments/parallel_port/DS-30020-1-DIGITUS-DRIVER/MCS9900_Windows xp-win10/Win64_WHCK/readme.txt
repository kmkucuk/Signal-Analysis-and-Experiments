The StnCoInst.ini file is used to set the MCS99xx Cascade COM ports sorting rule definition as below, 
please make sure which mode is suitable to your MCS99xx cascade hardware design before changing this setting.

"0" (default): 
COM Port No.    Cascade Master/Slave   Function No.
		1									Master								0	
		2									Master								1	
		3									Master								2	
		4									Master								3	
		5									Slave									0	
		6									Slave									1	
		7									Slave									2	
		8									Slave									3	
		
"1": 
COM Port No.    Cascade Master/Slave   Function No.
		1									Master								0	
		2									Slave									0	
		3									Master								1	
		4									Slave									1	
		6									Slave									2	
		5									Master								2	
		7									Master								3	
		8									Slave									3			
		
		