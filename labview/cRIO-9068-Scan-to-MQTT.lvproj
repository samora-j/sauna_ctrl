<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="24008000">
	<Property Name="varPersistentID:{27D4211F-0F26-44E8-AF4B-7697EAC9B732}" Type="Ref">/RT CompactRIO Target/Chassis/Real-Time Scan Resources/Mod1/AI1</Property>
	<Property Name="varPersistentID:{4766FEEB-9EFF-47CC-B7D2-46105C0A1754}" Type="Ref">/RT CompactRIO Target/Chassis/Real-Time Scan Resources/Mod1/AI0</Property>
	<Property Name="varPersistentID:{93C3E777-1326-43A6-BB0B-8C9B60237E6C}" Type="Ref">/RT CompactRIO Target/Chassis/Real-Time Scan Resources/Mod1/AI3</Property>
	<Property Name="varPersistentID:{BE0231D0-B935-4D0D-8EEB-BEBCEBEA884A}" Type="Ref">/RT CompactRIO Target/Chassis/Real-Time Scan Resources/Mod1/AI2</Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
	<Item Name="RT CompactRIO Target" Type="RT CompactRIO">
		<Property Name="alias.name" Type="Str">RT CompactRIO Target</Property>
		<Property Name="alias.value" Type="Str">10.20.6.11</Property>
		<Property Name="CCSymbols" Type="Str">TARGET_TYPE,RT;OS,Linux;CPU,ARM;DeviceCode,76D6;</Property>
		<Property Name="crio.ControllerPID" Type="Str">76D6</Property>
		<Property Name="host.ResponsivenessCheckEnabled" Type="Bool">true</Property>
		<Property Name="host.ResponsivenessCheckPingDelay" Type="UInt">5000</Property>
		<Property Name="host.ResponsivenessCheckPingTimeout" Type="UInt">1000</Property>
		<Property Name="host.TargetCPUID" Type="UInt">8</Property>
		<Property Name="host.TargetOSID" Type="UInt">8</Property>
		<Property Name="NI.SortType" Type="Int">3</Property>
		<Property Name="target.cleanupVisa" Type="Bool">false</Property>
		<Property Name="target.FPProtocolGlobals_ControlTimeLimit" Type="Int">300</Property>
		<Property Name="target.getDefault-&gt;WebServer.Port" Type="Int">80</Property>
		<Property Name="target.getDefault-&gt;WebServer.Timeout" Type="Int">60</Property>
		<Property Name="target.IOScan.Faults" Type="Str"></Property>
		<Property Name="target.IOScan.NetVarPeriod" Type="UInt">100</Property>
		<Property Name="target.IOScan.NetWatchdogEnabled" Type="Bool">false</Property>
		<Property Name="target.IOScan.Period" Type="UInt">10000</Property>
		<Property Name="target.IOScan.PowerupMode" Type="UInt">0</Property>
		<Property Name="target.IOScan.Priority" Type="UInt">0</Property>
		<Property Name="target.IOScan.ReportModeConflict" Type="Bool">true</Property>
		<Property Name="target.IsRemotePanelSupported" Type="Bool">true</Property>
		<Property Name="target.RTCPULoadMonitoringEnabled" Type="Bool">true</Property>
		<Property Name="target.RTDebugWebServerHTTPPort" Type="Int">8001</Property>
		<Property Name="target.RTTarget.ApplicationPath" Type="Path">/home/lvuser/natinst/bin/startup.rtexe</Property>
		<Property Name="target.RTTarget.EnableFileSharing" Type="Bool">true</Property>
		<Property Name="target.RTTarget.IPAccess" Type="Str">+*</Property>
		<Property Name="target.RTTarget.LaunchAppAtBoot" Type="Bool">true</Property>
		<Property Name="target.RTTarget.VIPath" Type="Path">/home/lvuser/natinst/bin</Property>
		<Property Name="target.server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="target.server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="target.server.tcp.access" Type="Str">+*</Property>
		<Property Name="target.server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="target.server.tcp.paranoid" Type="Bool">true</Property>
		<Property Name="target.server.tcp.port" Type="Int">3363</Property>
		<Property Name="target.server.tcp.serviceName" Type="Str">Main Application Instance/VI Server</Property>
		<Property Name="target.server.tcp.serviceName.default" Type="Str">Main Application Instance/VI Server</Property>
		<Property Name="target.server.vi.access" Type="Str">+*</Property>
		<Property Name="target.server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="target.server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="target.WebServer.Config" Type="Str">Listen 8000

NI.ServerName default
DocumentRoot "$LVSERVER_DOCROOT"
TypesConfig "$LVSERVER_CONFIGROOT/mime.types"
DirectoryIndex index.htm
WorkerLimit 10
InactivityTimeout 60

LoadModulePath "$LVSERVER_MODULEPATHS"
LoadModule LVAuth lvauthmodule
LoadModule LVRFP lvrfpmodule

#
# Pipeline Definition
#

SetConnector netConnector

AddHandler LVAuth
AddHandler LVRFP

AddHandler fileHandler ""

AddOutputFilter chunkFilter


</Property>
		<Property Name="target.WebServer.Enabled" Type="Bool">false</Property>
		<Property Name="target.WebServer.LogEnabled" Type="Bool">false</Property>
		<Property Name="target.WebServer.LogPath" Type="Path">/c/ni-rt/system/www/www.log</Property>
		<Property Name="target.WebServer.Port" Type="Int">80</Property>
		<Property Name="target.WebServer.RootPath" Type="Path">/c/ni-rt/system/www</Property>
		<Property Name="target.WebServer.TcpAccess" Type="Str">c+*</Property>
		<Property Name="target.WebServer.Timeout" Type="Int">60</Property>
		<Property Name="target.WebServer.ViAccess" Type="Str">+*</Property>
		<Property Name="target.webservices.SecurityAPIKey" Type="Str">PqVr/ifkAQh+lVrdPIykXlFvg12GhhQFR8H9cUhphgg=:pTe9HRlQuMfJxAG6QCGq7UvoUpJzAzWGKy5SbZ+roSU=</Property>
		<Property Name="target.webservices.ValidTimestampWindow" Type="Int">15</Property>
		<Item Name="9068-Temp-scan-engine.vi" Type="VI" URL="../9068-Temp-scan-engine.vi"/>
		<Item Name="Main.vi" Type="VI" URL="../Main.vi"/>
		<Item Name="Chassis" Type="cRIO Chassis">
			<Property Name="crio.ProgrammingMode" Type="Str">fpga</Property>
			<Property Name="crio.ResourceID" Type="Str">RIO0</Property>
			<Property Name="crio.Type" Type="Str">cRIO-9068</Property>
			<Property Name="NI.SortType" Type="Int">3</Property>
			<Item Name="Real-Time Scan Resources" Type="Module Container">
				<Property Name="crio.ModuleContainerType" Type="Str">crio.RSIModuleContainer</Property>
				<Item Name="Mod1" Type="RIO C Series Module">
					<Property Name="crio.Calibration" Type="Str">1</Property>
					<Property Name="crio.Location" Type="Str">Slot 1</Property>
					<Property Name="crio.RequiresValidation" Type="Bool">false</Property>
					<Property Name="crio.SDcounterSlaveChannelMask" Type="Str">0</Property>
					<Property Name="crio.SDCounterSlaveMasterSlot" Type="Str">0</Property>
					<Property Name="crio.SDInputFilter" Type="Str">128</Property>
					<Property Name="crio.SupportsDynamicRes" Type="Bool">false</Property>
					<Property Name="crio.Type" Type="Str">NI 9211</Property>
					<Property Name="cRIOModule.AI0.DegreeRange" Type="Str">2</Property>
					<Property Name="cRIOModule.AI0.TCoupleType" Type="Str">0</Property>
					<Property Name="cRIOModule.AI1.DegreeRange" Type="Str">2</Property>
					<Property Name="cRIOModule.AI1.TCoupleType" Type="Str">0</Property>
					<Property Name="cRIOModule.AI2.DegreeRange" Type="Str">2</Property>
					<Property Name="cRIOModule.AI2.TCoupleType" Type="Str">0</Property>
					<Property Name="cRIOModule.AI3.DegreeRange" Type="Str">2</Property>
					<Property Name="cRIOModule.AI3.TCoupleType" Type="Str">0</Property>
					<Property Name="cRIOModule.DigitalIOMode" Type="Str">0</Property>
					<Property Name="cRIOModule.EnableSpecialtyDigital" Type="Str">false</Property>
					<Property Name="FPGA.PersistentID" Type="Str">{8EB09B9A-7706-402F-B0C5-4F48F2854298}</Property>
					<Item Name="AI0" Type="Variable">
						<Property Name="featurePacks" Type="Str">Industrial</Property>
						<Property Name="Industrial:BufferingEnabled" Type="Str">False</Property>
						<Property Name="Industrial:ChannelIndex" Type="Str">0</Property>
						<Property Name="Industrial:IODirection" Type="Str">Input</Property>
						<Property Name="Industrial:IsNetworkPublished" Type="Str">True</Property>
						<Property Name="Industrial:Mode" Type="Str">1</Property>
						<Property Name="Industrial:PhysicalName" Type="Str">AI0</Property>
						<Property Name="Network:UseBinding" Type="Str">False</Property>
						<Property Name="Network:UseBuffering" Type="Str">False</Property>
						<Property Name="numTypedefs" Type="UInt">0</Property>
						<Property Name="type" Type="Str">Industrial</Property>
						<Property Name="typeDesc" Type="Bin">(1!!!#1!A!!!!!!"!!5!#A!!!1!!!!!!!!!!!!!!!!!!</Property>
					</Item>
					<Item Name="AI1" Type="Variable">
						<Property Name="featurePacks" Type="Str">Industrial</Property>
						<Property Name="Industrial:BufferingEnabled" Type="Str">False</Property>
						<Property Name="Industrial:ChannelIndex" Type="Str">1</Property>
						<Property Name="Industrial:IODirection" Type="Str">Input</Property>
						<Property Name="Industrial:IsNetworkPublished" Type="Str">True</Property>
						<Property Name="Industrial:Mode" Type="Str">1</Property>
						<Property Name="Industrial:PhysicalName" Type="Str">AI1</Property>
						<Property Name="Network:UseBinding" Type="Str">False</Property>
						<Property Name="Network:UseBuffering" Type="Str">False</Property>
						<Property Name="numTypedefs" Type="UInt">0</Property>
						<Property Name="type" Type="Str">Industrial</Property>
						<Property Name="typeDesc" Type="Bin">(1!!!#1!A!!!!!!"!!5!#A!!!1!!!!!!!!!!!!!!!!!!</Property>
					</Item>
					<Item Name="AI2" Type="Variable">
						<Property Name="featurePacks" Type="Str">Industrial</Property>
						<Property Name="Industrial:BufferingEnabled" Type="Str">False</Property>
						<Property Name="Industrial:ChannelIndex" Type="Str">2</Property>
						<Property Name="Industrial:IODirection" Type="Str">Input</Property>
						<Property Name="Industrial:IsNetworkPublished" Type="Str">True</Property>
						<Property Name="Industrial:Mode" Type="Str">1</Property>
						<Property Name="Industrial:PhysicalName" Type="Str">AI2</Property>
						<Property Name="Network:UseBinding" Type="Str">False</Property>
						<Property Name="Network:UseBuffering" Type="Str">False</Property>
						<Property Name="numTypedefs" Type="UInt">0</Property>
						<Property Name="type" Type="Str">Industrial</Property>
						<Property Name="typeDesc" Type="Bin">(1!!!#1!A!!!!!!"!!5!#A!!!1!!!!!!!!!!!!!!!!!!</Property>
					</Item>
					<Item Name="AI3" Type="Variable">
						<Property Name="featurePacks" Type="Str">Industrial</Property>
						<Property Name="Industrial:BufferingEnabled" Type="Str">False</Property>
						<Property Name="Industrial:ChannelIndex" Type="Str">3</Property>
						<Property Name="Industrial:IODirection" Type="Str">Input</Property>
						<Property Name="Industrial:IsNetworkPublished" Type="Str">True</Property>
						<Property Name="Industrial:Mode" Type="Str">1</Property>
						<Property Name="Industrial:PhysicalName" Type="Str">AI3</Property>
						<Property Name="Network:UseBinding" Type="Str">False</Property>
						<Property Name="Network:UseBuffering" Type="Str">False</Property>
						<Property Name="numTypedefs" Type="UInt">0</Property>
						<Property Name="type" Type="Str">Industrial</Property>
						<Property Name="typeDesc" Type="Bin">(1!!!#1!A!!!!!!"!!5!#A!!!1!!!!!!!!!!!!!!!!!!</Property>
					</Item>
				</Item>
			</Item>
			<Item Name="FPGA Target" Type="FPGA Target">
				<Property Name="AutoRun" Type="Bool">false</Property>
				<Property Name="configString.guid" Type="Str">{0458F1C3-710C-4BBF-8E6A-0D18B4FD4AC7}resource=/crio_Mod2/DIO18;0;ReadMethodType=bool;WriteMethodType=bool{0493C8AC-037A-4EFE-A6DF-6B48AE214379}resource=/crio_Mod2/DIO14;0;ReadMethodType=bool;WriteMethodType=bool{0C97F71A-2739-4F88-9F35-772095FE4512}resource=/crio_Mod2/DIO0;0;ReadMethodType=bool;WriteMethodType=bool{0DB0AFEC-A425-4084-B7F1-83D3A2FF916C}resource=/crio_Mod2/DIO5;0;ReadMethodType=bool;WriteMethodType=bool{10B417EE-B698-4F54-9EDE-EFE06A0E5CF5}ResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000,000000;MaxFreq=40000000,000000;VariableFreq=0;NomFreq=40000000,000000;PeakPeriodJitter=250,000000;MinDutyCycle=50,000000;MaxDutyCycle=50,000000;Accuracy=100,000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;{20401B43-519F-4017-A068-39F255983B57}resource=/crio_Mod2/DIO31:24;0;ReadMethodType=u8;WriteMethodType=u8{25B2E6EC-A06A-4399-B2AE-45E335265121}resource=/crio_Mod2/DIO31;0;ReadMethodType=bool;WriteMethodType=bool{295F2FD9-7668-4F15-97E1-943DCD1A3F2B}resource=/crio_Mod2/DIO15:8;0;ReadMethodType=u8;WriteMethodType=u8{2FB9BDD2-F0A6-4595-BFC1-E4F2E7CDB4A7}resource=/crio_Mod2/DIO16;0;ReadMethodType=bool;WriteMethodType=bool{38096FAA-FFEB-455C-87F5-65C68B9DB76C}resource=/crio_Mod2/DIO26;0;ReadMethodType=bool;WriteMethodType=bool{3F3A5DCF-BB2E-4D43-87B8-B3AD36DFC450}resource=/crio_Mod2/DIO23:16;0;ReadMethodType=u8;WriteMethodType=u8{3F85D74E-7044-429E-9279-C2CD5FAA4A86}resource=/crio_Mod2/DIO22;0;ReadMethodType=bool;WriteMethodType=bool{4653A6EF-55DD-4EAE-A990-CA6BEC536F20}resource=/crio_Mod2/DIO21;0;ReadMethodType=bool;WriteMethodType=bool{46FEFDAC-E532-4849-878A-017687A4B974}resource=/crio_Mod2/DIO28;0;ReadMethodType=bool;WriteMethodType=bool{473DFB58-C99E-4944-81B1-9D6789832C45}resource=/crio_Mod2/DIO23;0;ReadMethodType=bool;WriteMethodType=bool{4742D59A-C35D-4F14-8B75-CA0C5D3F5C60}resource=/crio_Mod2/DIO17;0;ReadMethodType=bool;WriteMethodType=bool{50435623-E931-4D18-A8EA-32FDA1440471}resource=/crio_Mod2/DIO3;0;ReadMethodType=bool;WriteMethodType=bool{586DD5E3-9C85-4120-807C-FEFB2587B17D}resource=/crio_Mod2/DIO24;0;ReadMethodType=bool;WriteMethodType=bool{5F87414C-0647-4C8A-A311-A77C5F569E36}resource=/crio_Mod2/DIO11;0;ReadMethodType=bool;WriteMethodType=bool{6012F634-A51A-43BE-848B-B9F2D15EB3A9}resource=/crio_Mod2/DIO2;0;ReadMethodType=bool;WriteMethodType=bool{62452FE2-6534-40E6-AFC6-1AD145A38571}resource=/crio_Mod2/DIO31:0;0;ReadMethodType=u32;WriteMethodType=u32{68FED15E-178B-480F-AB2F-85C39722119B}resource=/System Reset;0;ReadMethodType=bool;WriteMethodType=bool{73AE5E3F-E3B5-4388-9F22-D97E67A830A2}resource=/Chassis Temperature;0;ReadMethodType=i16{7DEAA281-7FC6-45B7-8E9A-8C5324904520}resource=/crio_Mod2/DIO4;0;ReadMethodType=bool;WriteMethodType=bool{827CEA21-9A6B-40A8-A80D-345DA28857D5}resource=/crio_Mod2/DIO30;0;ReadMethodType=bool;WriteMethodType=bool{8EB09B9A-7706-402F-B0C5-4F48F2854298}[crioConfig.Begin]crio.Location=Slot 1,cRIOModule.EnableHsInput=false,cRIOModule.EnableHsOutput=false,cRIOModule.EnableSpecialtyDigital=false[crioConfig.End]{95824955-0C98-4AE7-B42B-A2804562D279}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9403,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.Initial Line Direction=00000000000000000000000000000000,cRIOModule.RsiAttributes=[crioConfig.End]{978ACD4D-7B29-4B6F-A49B-46EC7A2E3DC3}resource=/crio_Mod2/DIO29;0;ReadMethodType=bool;WriteMethodType=bool{A4E8A3B5-1721-45C8-9F9F-6AF0230B0C76}resource=/crio_Mod2/DIO9;0;ReadMethodType=bool;WriteMethodType=bool{AC357B8B-725E-4773-A16C-8DD31F3C8488}resource=/crio_Mod2/DIO10;0;ReadMethodType=bool;WriteMethodType=bool{AEC2CAE6-F6E2-4F14-B5B3-CB39502A4E62}resource=/crio_Mod2/DIO12;0;ReadMethodType=bool;WriteMethodType=bool{BC132BBC-38F6-432B-B6EE-04DCFD866BBB}resource=/crio_Mod2/DIO27;0;ReadMethodType=bool;WriteMethodType=bool{BD8CC1FA-2800-49E9-A38D-0DB85C0E3113}resource=/Sleep;0;ReadMethodType=bool;WriteMethodType=bool{BDB82735-C086-4EAD-9A28-57917D958202}resource=/crio_Mod2/DIO19;0;ReadMethodType=bool;WriteMethodType=bool{BE5F4632-BA03-4B7A-800D-EB6641F6ED89}resource=/crio_Mod2/DIO1;0;ReadMethodType=bool;WriteMethodType=bool{C99171D6-FC38-4129-810D-743CA66651CA}resource=/crio_Mod2/DIO15;0;ReadMethodType=bool;WriteMethodType=bool{D71E4388-3DB8-4E54-B2E9-04AB36A128DA}resource=/crio_Mod2/DIO20;0;ReadMethodType=bool;WriteMethodType=bool{D86794F3-3D1E-44E2-8876-DA170861E5FB}resource=/crio_Mod2/DIO7:0;0;ReadMethodType=u8;WriteMethodType=u8{DE7EC70B-201A-4C9F-8382-3E16CC9012EF}resource=/crio_Mod2/DIO8;0;ReadMethodType=bool;WriteMethodType=bool{E2358520-7368-4E47-864C-9AD2FED6F23E}resource=/crio_Mod2/DIO13;0;ReadMethodType=bool;WriteMethodType=bool{E3C66A96-8FEB-4CC3-80C3-2AC76560CDEF}resource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8{ED982F3E-2D56-4708-8C76-DA910BEFA1F1}resource=/crio_Mod2/DIO7;0;ReadMethodType=bool;WriteMethodType=bool{F8D84948-943D-42EE-B049-D509F84999D0}resource=/crio_Mod2/DIO6;0;ReadMethodType=bool;WriteMethodType=bool{F99F5D4A-BFAF-485B-917E-6A125B4CC552}resource=/crio_Mod2/DIO25;0;ReadMethodType=bool;WriteMethodType=bool{FDEF77D7-3C04-4A30-9038-F48C5A40CAB1}resource=/Scan Clock;0;ReadMethodType=boolcRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA</Property>
				<Property Name="configString.name" Type="Str">40 MHz Onboard ClockResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000,000000;MaxFreq=40000000,000000;VariableFreq=0;NomFreq=40000000,000000;PeakPeriodJitter=250,000000;MinDutyCycle=50,000000;MaxDutyCycle=50,000000;Accuracy=100,000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;Aromi LEDresource=/crio_Mod2/DIO2;0;ReadMethodType=bool;WriteMethodType=boolAromi Pumpresource=/crio_Mod2/DIO7;0;ReadMethodType=bool;WriteMethodType=boolAromi Switchresource=/crio_Mod2/DIO3;0;ReadMethodType=bool;WriteMethodType=boolChassis Temperatureresource=/Chassis Temperature;0;ReadMethodType=i16cRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGAKiuas LEDresource=/crio_Mod2/DIO0;0;ReadMethodType=bool;WriteMethodType=boolKiuas Switchresource=/crio_Mod2/DIO1;0;ReadMethodType=bool;WriteMethodType=boolLöyly LEDresource=/crio_Mod2/DIO4;0;ReadMethodType=bool;WriteMethodType=boolLöyly Switchresource=/crio_Mod2/DIO5;0;ReadMethodType=bool;WriteMethodType=boolLöyly Valveresource=/crio_Mod2/DIO6;0;ReadMethodType=bool;WriteMethodType=boolMod1[crioConfig.Begin]crio.Location=Slot 1,cRIOModule.EnableHsInput=false,cRIOModule.EnableHsOutput=false,cRIOModule.EnableSpecialtyDigital=false[crioConfig.End]Mod2/DIO10resource=/crio_Mod2/DIO10;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO11resource=/crio_Mod2/DIO11;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO15:8resource=/crio_Mod2/DIO15:8;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DIO15resource=/crio_Mod2/DIO15;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO16resource=/crio_Mod2/DIO16;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO17resource=/crio_Mod2/DIO17;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO18resource=/crio_Mod2/DIO18;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO19resource=/crio_Mod2/DIO19;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO20resource=/crio_Mod2/DIO20;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO21resource=/crio_Mod2/DIO21;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO22resource=/crio_Mod2/DIO22;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO23:16resource=/crio_Mod2/DIO23:16;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DIO23resource=/crio_Mod2/DIO23;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO24resource=/crio_Mod2/DIO24;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO25resource=/crio_Mod2/DIO25;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO26resource=/crio_Mod2/DIO26;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO27resource=/crio_Mod2/DIO27;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO28resource=/crio_Mod2/DIO28;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO29resource=/crio_Mod2/DIO29;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO30resource=/crio_Mod2/DIO30;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO31:0resource=/crio_Mod2/DIO31:0;0;ReadMethodType=u32;WriteMethodType=u32Mod2/DIO31:24resource=/crio_Mod2/DIO31:24;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DIO31resource=/crio_Mod2/DIO31;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO7:0resource=/crio_Mod2/DIO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DIO8resource=/crio_Mod2/DIO8;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO9resource=/crio_Mod2/DIO9;0;ReadMethodType=bool;WriteMethodType=boolMod2[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9403,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.Initial Line Direction=00000000000000000000000000000000,cRIOModule.RsiAttributes=[crioConfig.End]Pump Directionresource=/crio_Mod2/DIO13;0;ReadMethodType=bool;WriteMethodType=boolPump Enableresource=/crio_Mod2/DIO12;0;ReadMethodType=bool;WriteMethodType=boolPump Stepresource=/crio_Mod2/DIO14;0;ReadMethodType=bool;WriteMethodType=boolScan Clockresource=/Scan Clock;0;ReadMethodType=boolSleepresource=/Sleep;0;ReadMethodType=bool;WriteMethodType=boolSystem Resetresource=/System Reset;0;ReadMethodType=bool;WriteMethodType=boolUSER FPGA LEDresource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8</Property>
				<Property Name="NI.LV.FPGA.CompileConfigString" Type="Str">cRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA</Property>
				<Property Name="NI.LV.FPGA.Version" Type="Int">6</Property>
				<Property Name="Resource Name" Type="Str">RIO0</Property>
				<Property Name="Target Class" Type="Str">cRIO-9068</Property>
				<Property Name="Top-Level Timing Source" Type="Str">40 MHz Onboard Clock</Property>
				<Property Name="Top-Level Timing Source Is Default" Type="Bool">true</Property>
				<Item Name="Chassis I/O" Type="Folder">
					<Item Name="Chassis Temperature" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/Chassis Temperature</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{73AE5E3F-E3B5-4388-9F22-D97E67A830A2}</Property>
					</Item>
					<Item Name="Sleep" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/Sleep</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{BD8CC1FA-2800-49E9-A38D-0DB85C0E3113}</Property>
					</Item>
					<Item Name="System Reset" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/System Reset</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{68FED15E-178B-480F-AB2F-85C39722119B}</Property>
					</Item>
					<Item Name="USER FPGA LED" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/USER FPGA LED</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{E3C66A96-8FEB-4CC3-80C3-2AC76560CDEF}</Property>
					</Item>
					<Item Name="Scan Clock" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/Scan Clock</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{FDEF77D7-3C04-4A30-9038-F48C5A40CAB1}</Property>
					</Item>
				</Item>
				<Item Name="Mod2" Type="Folder">
					<Item Name="Kiuas LED" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO0</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{0C97F71A-2739-4F88-9F35-772095FE4512}</Property>
					</Item>
					<Item Name="Kiuas Switch" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO1</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{BE5F4632-BA03-4B7A-800D-EB6641F6ED89}</Property>
					</Item>
					<Item Name="Aromi LED" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO2</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{6012F634-A51A-43BE-848B-B9F2D15EB3A9}</Property>
					</Item>
					<Item Name="Aromi Switch" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO3</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{50435623-E931-4D18-A8EA-32FDA1440471}</Property>
					</Item>
					<Item Name="Löyly LED" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO4</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{7DEAA281-7FC6-45B7-8E9A-8C5324904520}</Property>
					</Item>
					<Item Name="Löyly Switch" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO5</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{0DB0AFEC-A425-4084-B7F1-83D3A2FF916C}</Property>
					</Item>
					<Item Name="Löyly Valve" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO6</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{F8D84948-943D-42EE-B049-D509F84999D0}</Property>
					</Item>
					<Item Name="Aromi Pump" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO7</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{ED982F3E-2D56-4708-8C76-DA910BEFA1F1}</Property>
					</Item>
					<Item Name="Mod2/DIO8" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO8</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{DE7EC70B-201A-4C9F-8382-3E16CC9012EF}</Property>
					</Item>
					<Item Name="Mod2/DIO9" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO9</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{A4E8A3B5-1721-45C8-9F9F-6AF0230B0C76}</Property>
					</Item>
					<Item Name="Mod2/DIO10" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO10</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{AC357B8B-725E-4773-A16C-8DD31F3C8488}</Property>
					</Item>
					<Item Name="Mod2/DIO11" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO11</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{5F87414C-0647-4C8A-A311-A77C5F569E36}</Property>
					</Item>
					<Item Name="Pump Enable" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO12</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{AEC2CAE6-F6E2-4F14-B5B3-CB39502A4E62}</Property>
					</Item>
					<Item Name="Pump Direction" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO13</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{E2358520-7368-4E47-864C-9AD2FED6F23E}</Property>
					</Item>
					<Item Name="Pump Step" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO14</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{0493C8AC-037A-4EFE-A6DF-6B48AE214379}</Property>
					</Item>
					<Item Name="Mod2/DIO15" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO15</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{C99171D6-FC38-4129-810D-743CA66651CA}</Property>
					</Item>
					<Item Name="Mod2/DIO16" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO16</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{2FB9BDD2-F0A6-4595-BFC1-E4F2E7CDB4A7}</Property>
					</Item>
					<Item Name="Mod2/DIO17" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO17</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{4742D59A-C35D-4F14-8B75-CA0C5D3F5C60}</Property>
					</Item>
					<Item Name="Mod2/DIO18" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO18</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{0458F1C3-710C-4BBF-8E6A-0D18B4FD4AC7}</Property>
					</Item>
					<Item Name="Mod2/DIO19" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO19</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{BDB82735-C086-4EAD-9A28-57917D958202}</Property>
					</Item>
					<Item Name="Mod2/DIO20" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO20</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{D71E4388-3DB8-4E54-B2E9-04AB36A128DA}</Property>
					</Item>
					<Item Name="Mod2/DIO21" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO21</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{4653A6EF-55DD-4EAE-A990-CA6BEC536F20}</Property>
					</Item>
					<Item Name="Mod2/DIO22" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO22</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{3F85D74E-7044-429E-9279-C2CD5FAA4A86}</Property>
					</Item>
					<Item Name="Mod2/DIO23" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO23</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{473DFB58-C99E-4944-81B1-9D6789832C45}</Property>
					</Item>
					<Item Name="Mod2/DIO24" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO24</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{586DD5E3-9C85-4120-807C-FEFB2587B17D}</Property>
					</Item>
					<Item Name="Mod2/DIO25" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO25</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{F99F5D4A-BFAF-485B-917E-6A125B4CC552}</Property>
					</Item>
					<Item Name="Mod2/DIO26" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO26</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{38096FAA-FFEB-455C-87F5-65C68B9DB76C}</Property>
					</Item>
					<Item Name="Mod2/DIO27" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO27</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{BC132BBC-38F6-432B-B6EE-04DCFD866BBB}</Property>
					</Item>
					<Item Name="Mod2/DIO28" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO28</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{46FEFDAC-E532-4849-878A-017687A4B974}</Property>
					</Item>
					<Item Name="Mod2/DIO29" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO29</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{978ACD4D-7B29-4B6F-A49B-46EC7A2E3DC3}</Property>
					</Item>
					<Item Name="Mod2/DIO30" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO30</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{827CEA21-9A6B-40A8-A80D-345DA28857D5}</Property>
					</Item>
					<Item Name="Mod2/DIO31" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO31</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{25B2E6EC-A06A-4399-B2AE-45E335265121}</Property>
					</Item>
					<Item Name="Mod2/DIO7:0" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO7:0</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{D86794F3-3D1E-44E2-8876-DA170861E5FB}</Property>
					</Item>
					<Item Name="Mod2/DIO15:8" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO15:8</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{295F2FD9-7668-4F15-97E1-943DCD1A3F2B}</Property>
					</Item>
					<Item Name="Mod2/DIO23:16" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO23:16</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{3F3A5DCF-BB2E-4D43-87B8-B3AD36DFC450}</Property>
					</Item>
					<Item Name="Mod2/DIO31:24" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO31:24</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{20401B43-519F-4017-A068-39F255983B57}</Property>
					</Item>
					<Item Name="Mod2/DIO31:0" Type="Elemental IO">
						<Property Name="eioAttrBag" Type="Xml"><AttributeSet name="">
   <Attribute name="resource">
   <Value>/crio_Mod2/DIO31:0</Value>
   </Attribute>
</AttributeSet>
</Property>
						<Property Name="FPGA.PersistentID" Type="Str">{62452FE2-6534-40E6-AFC6-1AD145A38571}</Property>
					</Item>
				</Item>
				<Item Name="HostMemoryBuffer" Type="FPGA Component Level IP">
					<Property Name="crio.OldestValidLabVIEWVersion" Type="Str">17</Property>
					<Property Name="NI.LV.CLIP.DeclarationCategory" Type="Str"></Property>
					<Property Name="NI.LV.CLIP.SocketedCLIP" Type="Bool">true</Property>
					<Property Name="NI.LV.CLIP.SocketSelection" Type="Str">HostMemoryBuffer</Property>
					<Property Name="NI.LV.FPGA.Valid" Type="Bool">true</Property>
					<Property Name="NI.SortType" Type="Int">3</Property>
				</Item>
				<Item Name="40 MHz Onboard Clock" Type="FPGA Base Clock">
					<Property Name="FPGA.PersistentID" Type="Str">{10B417EE-B698-4F54-9EDE-EFE06A0E5CF5}</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig" Type="Str">ResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000,000000;MaxFreq=40000000,000000;VariableFreq=0;NomFreq=40000000,000000;PeakPeriodJitter=250,000000;MinDutyCycle=50,000000;MaxDutyCycle=50,000000;Accuracy=100,000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.Accuracy" Type="Dbl">100</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.ClockSignalName" Type="Str">Clk40</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.MaxDutyCycle" Type="Dbl">50</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.MaxFrequency" Type="Dbl">40000000</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.MinDutyCycle" Type="Dbl">50</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.MinFrequency" Type="Dbl">40000000</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.NominalFrequency" Type="Dbl">40000000</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.PeakPeriodJitter" Type="Dbl">250</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.ResourceName" Type="Str">40 MHz Onboard Clock</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.SupportAndRequireRuntimeEnableDisable" Type="Bool">false</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.TopSignalConnect" Type="Str">Clk40</Property>
					<Property Name="NI.LV.FPGA.BaseTSConfig.VariableFrequency" Type="Bool">false</Property>
					<Property Name="NI.LV.FPGA.Valid" Type="Bool">true</Property>
					<Property Name="NI.LV.FPGA.Version" Type="Int">5</Property>
				</Item>
				<Item Name="IP Builder" Type="IP Builder Target">
					<Item Name="Dependencies" Type="Dependencies"/>
					<Item Name="Build Specifications" Type="Build"/>
				</Item>
				<Item Name="FPGA_MAin.vi" Type="VI" URL="../FPGA_MAin.vi">
					<Property Name="configString.guid" Type="Str">{0458F1C3-710C-4BBF-8E6A-0D18B4FD4AC7}resource=/crio_Mod2/DIO18;0;ReadMethodType=bool;WriteMethodType=bool{0493C8AC-037A-4EFE-A6DF-6B48AE214379}resource=/crio_Mod2/DIO14;0;ReadMethodType=bool;WriteMethodType=bool{0C97F71A-2739-4F88-9F35-772095FE4512}resource=/crio_Mod2/DIO0;0;ReadMethodType=bool;WriteMethodType=bool{0DB0AFEC-A425-4084-B7F1-83D3A2FF916C}resource=/crio_Mod2/DIO5;0;ReadMethodType=bool;WriteMethodType=bool{10B417EE-B698-4F54-9EDE-EFE06A0E5CF5}ResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000,000000;MaxFreq=40000000,000000;VariableFreq=0;NomFreq=40000000,000000;PeakPeriodJitter=250,000000;MinDutyCycle=50,000000;MaxDutyCycle=50,000000;Accuracy=100,000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;{20401B43-519F-4017-A068-39F255983B57}resource=/crio_Mod2/DIO31:24;0;ReadMethodType=u8;WriteMethodType=u8{25B2E6EC-A06A-4399-B2AE-45E335265121}resource=/crio_Mod2/DIO31;0;ReadMethodType=bool;WriteMethodType=bool{295F2FD9-7668-4F15-97E1-943DCD1A3F2B}resource=/crio_Mod2/DIO15:8;0;ReadMethodType=u8;WriteMethodType=u8{2FB9BDD2-F0A6-4595-BFC1-E4F2E7CDB4A7}resource=/crio_Mod2/DIO16;0;ReadMethodType=bool;WriteMethodType=bool{38096FAA-FFEB-455C-87F5-65C68B9DB76C}resource=/crio_Mod2/DIO26;0;ReadMethodType=bool;WriteMethodType=bool{3F3A5DCF-BB2E-4D43-87B8-B3AD36DFC450}resource=/crio_Mod2/DIO23:16;0;ReadMethodType=u8;WriteMethodType=u8{3F85D74E-7044-429E-9279-C2CD5FAA4A86}resource=/crio_Mod2/DIO22;0;ReadMethodType=bool;WriteMethodType=bool{4653A6EF-55DD-4EAE-A990-CA6BEC536F20}resource=/crio_Mod2/DIO21;0;ReadMethodType=bool;WriteMethodType=bool{46FEFDAC-E532-4849-878A-017687A4B974}resource=/crio_Mod2/DIO28;0;ReadMethodType=bool;WriteMethodType=bool{473DFB58-C99E-4944-81B1-9D6789832C45}resource=/crio_Mod2/DIO23;0;ReadMethodType=bool;WriteMethodType=bool{4742D59A-C35D-4F14-8B75-CA0C5D3F5C60}resource=/crio_Mod2/DIO17;0;ReadMethodType=bool;WriteMethodType=bool{50435623-E931-4D18-A8EA-32FDA1440471}resource=/crio_Mod2/DIO3;0;ReadMethodType=bool;WriteMethodType=bool{586DD5E3-9C85-4120-807C-FEFB2587B17D}resource=/crio_Mod2/DIO24;0;ReadMethodType=bool;WriteMethodType=bool{5F87414C-0647-4C8A-A311-A77C5F569E36}resource=/crio_Mod2/DIO11;0;ReadMethodType=bool;WriteMethodType=bool{6012F634-A51A-43BE-848B-B9F2D15EB3A9}resource=/crio_Mod2/DIO2;0;ReadMethodType=bool;WriteMethodType=bool{62452FE2-6534-40E6-AFC6-1AD145A38571}resource=/crio_Mod2/DIO31:0;0;ReadMethodType=u32;WriteMethodType=u32{68FED15E-178B-480F-AB2F-85C39722119B}resource=/System Reset;0;ReadMethodType=bool;WriteMethodType=bool{73AE5E3F-E3B5-4388-9F22-D97E67A830A2}resource=/Chassis Temperature;0;ReadMethodType=i16{7DEAA281-7FC6-45B7-8E9A-8C5324904520}resource=/crio_Mod2/DIO4;0;ReadMethodType=bool;WriteMethodType=bool{827CEA21-9A6B-40A8-A80D-345DA28857D5}resource=/crio_Mod2/DIO30;0;ReadMethodType=bool;WriteMethodType=bool{8EB09B9A-7706-402F-B0C5-4F48F2854298}[crioConfig.Begin]crio.Location=Slot 1,cRIOModule.EnableHsInput=false,cRIOModule.EnableHsOutput=false,cRIOModule.EnableSpecialtyDigital=false[crioConfig.End]{95824955-0C98-4AE7-B42B-A2804562D279}[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9403,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.Initial Line Direction=00000000000000000000000000000000,cRIOModule.RsiAttributes=[crioConfig.End]{978ACD4D-7B29-4B6F-A49B-46EC7A2E3DC3}resource=/crio_Mod2/DIO29;0;ReadMethodType=bool;WriteMethodType=bool{A4E8A3B5-1721-45C8-9F9F-6AF0230B0C76}resource=/crio_Mod2/DIO9;0;ReadMethodType=bool;WriteMethodType=bool{AC357B8B-725E-4773-A16C-8DD31F3C8488}resource=/crio_Mod2/DIO10;0;ReadMethodType=bool;WriteMethodType=bool{AEC2CAE6-F6E2-4F14-B5B3-CB39502A4E62}resource=/crio_Mod2/DIO12;0;ReadMethodType=bool;WriteMethodType=bool{BC132BBC-38F6-432B-B6EE-04DCFD866BBB}resource=/crio_Mod2/DIO27;0;ReadMethodType=bool;WriteMethodType=bool{BD8CC1FA-2800-49E9-A38D-0DB85C0E3113}resource=/Sleep;0;ReadMethodType=bool;WriteMethodType=bool{BDB82735-C086-4EAD-9A28-57917D958202}resource=/crio_Mod2/DIO19;0;ReadMethodType=bool;WriteMethodType=bool{BE5F4632-BA03-4B7A-800D-EB6641F6ED89}resource=/crio_Mod2/DIO1;0;ReadMethodType=bool;WriteMethodType=bool{C99171D6-FC38-4129-810D-743CA66651CA}resource=/crio_Mod2/DIO15;0;ReadMethodType=bool;WriteMethodType=bool{D71E4388-3DB8-4E54-B2E9-04AB36A128DA}resource=/crio_Mod2/DIO20;0;ReadMethodType=bool;WriteMethodType=bool{D86794F3-3D1E-44E2-8876-DA170861E5FB}resource=/crio_Mod2/DIO7:0;0;ReadMethodType=u8;WriteMethodType=u8{DE7EC70B-201A-4C9F-8382-3E16CC9012EF}resource=/crio_Mod2/DIO8;0;ReadMethodType=bool;WriteMethodType=bool{E2358520-7368-4E47-864C-9AD2FED6F23E}resource=/crio_Mod2/DIO13;0;ReadMethodType=bool;WriteMethodType=bool{E3C66A96-8FEB-4CC3-80C3-2AC76560CDEF}resource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8{ED982F3E-2D56-4708-8C76-DA910BEFA1F1}resource=/crio_Mod2/DIO7;0;ReadMethodType=bool;WriteMethodType=bool{F8D84948-943D-42EE-B049-D509F84999D0}resource=/crio_Mod2/DIO6;0;ReadMethodType=bool;WriteMethodType=bool{F99F5D4A-BFAF-485B-917E-6A125B4CC552}resource=/crio_Mod2/DIO25;0;ReadMethodType=bool;WriteMethodType=bool{FDEF77D7-3C04-4A30-9038-F48C5A40CAB1}resource=/Scan Clock;0;ReadMethodType=boolcRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGA</Property>
					<Property Name="configString.name" Type="Str">40 MHz Onboard ClockResourceName=40 MHz Onboard Clock;TopSignalConnect=Clk40;ClockSignalName=Clk40;MinFreq=40000000,000000;MaxFreq=40000000,000000;VariableFreq=0;NomFreq=40000000,000000;PeakPeriodJitter=250,000000;MinDutyCycle=50,000000;MaxDutyCycle=50,000000;Accuracy=100,000000;RunTime=0;SpreadSpectrum=0;GenericDataHash=D41D8CD98F00B204E9800998ECF8427E;Aromi LEDresource=/crio_Mod2/DIO2;0;ReadMethodType=bool;WriteMethodType=boolAromi Pumpresource=/crio_Mod2/DIO7;0;ReadMethodType=bool;WriteMethodType=boolAromi Switchresource=/crio_Mod2/DIO3;0;ReadMethodType=bool;WriteMethodType=boolChassis Temperatureresource=/Chassis Temperature;0;ReadMethodType=i16cRIO-9068/Clk40/falsefalseFPGA_EXECUTION_MODEFPGA_TARGETFPGA_TARGET_CLASSCRIO_9068FPGA_TARGET_FAMILYZYNQTARGET_TYPEFPGAKiuas LEDresource=/crio_Mod2/DIO0;0;ReadMethodType=bool;WriteMethodType=boolKiuas Switchresource=/crio_Mod2/DIO1;0;ReadMethodType=bool;WriteMethodType=boolLöyly LEDresource=/crio_Mod2/DIO4;0;ReadMethodType=bool;WriteMethodType=boolLöyly Switchresource=/crio_Mod2/DIO5;0;ReadMethodType=bool;WriteMethodType=boolLöyly Valveresource=/crio_Mod2/DIO6;0;ReadMethodType=bool;WriteMethodType=boolMod1[crioConfig.Begin]crio.Location=Slot 1,cRIOModule.EnableHsInput=false,cRIOModule.EnableHsOutput=false,cRIOModule.EnableSpecialtyDigital=false[crioConfig.End]Mod2/DIO10resource=/crio_Mod2/DIO10;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO11resource=/crio_Mod2/DIO11;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO15:8resource=/crio_Mod2/DIO15:8;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DIO15resource=/crio_Mod2/DIO15;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO16resource=/crio_Mod2/DIO16;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO17resource=/crio_Mod2/DIO17;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO18resource=/crio_Mod2/DIO18;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO19resource=/crio_Mod2/DIO19;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO20resource=/crio_Mod2/DIO20;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO21resource=/crio_Mod2/DIO21;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO22resource=/crio_Mod2/DIO22;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO23:16resource=/crio_Mod2/DIO23:16;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DIO23resource=/crio_Mod2/DIO23;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO24resource=/crio_Mod2/DIO24;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO25resource=/crio_Mod2/DIO25;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO26resource=/crio_Mod2/DIO26;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO27resource=/crio_Mod2/DIO27;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO28resource=/crio_Mod2/DIO28;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO29resource=/crio_Mod2/DIO29;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO30resource=/crio_Mod2/DIO30;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO31:0resource=/crio_Mod2/DIO31:0;0;ReadMethodType=u32;WriteMethodType=u32Mod2/DIO31:24resource=/crio_Mod2/DIO31:24;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DIO31resource=/crio_Mod2/DIO31;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO7:0resource=/crio_Mod2/DIO7:0;0;ReadMethodType=u8;WriteMethodType=u8Mod2/DIO8resource=/crio_Mod2/DIO8;0;ReadMethodType=bool;WriteMethodType=boolMod2/DIO9resource=/crio_Mod2/DIO9;0;ReadMethodType=bool;WriteMethodType=boolMod2[crioConfig.Begin]crio.Calibration=1,crio.Location=Slot 2,crio.Type=NI 9403,cRIOModule.DisableArbitration=false,cRIOModule.EnableDECoM=false,cRIOModule.EnableInputFifo=false,cRIOModule.EnableOutputFifo=false,cRIOModule.Initial Line Direction=00000000000000000000000000000000,cRIOModule.RsiAttributes=[crioConfig.End]Pump Directionresource=/crio_Mod2/DIO13;0;ReadMethodType=bool;WriteMethodType=boolPump Enableresource=/crio_Mod2/DIO12;0;ReadMethodType=bool;WriteMethodType=boolPump Stepresource=/crio_Mod2/DIO14;0;ReadMethodType=bool;WriteMethodType=boolScan Clockresource=/Scan Clock;0;ReadMethodType=boolSleepresource=/Sleep;0;ReadMethodType=bool;WriteMethodType=boolSystem Resetresource=/System Reset;0;ReadMethodType=bool;WriteMethodType=boolUSER FPGA LEDresource=/USER FPGA LED;0;ReadMethodType=u8;WriteMethodType=u8</Property>
					<Property Name="NI.LV.FPGA.InterfaceBitfile" Type="Str">\\fusion\GoogleDrive\HomeAutomation\projects\cRIO-MQTT\FPGA Bitfiles\crio-9068-scan-t_FPGATarget_FPGAMAin_XA2NADVDmlU.lvbitx</Property>
				</Item>
				<Item Name="Mod2" Type="RIO C Series Module">
					<Property Name="crio.Calibration" Type="Str">1</Property>
					<Property Name="crio.Location" Type="Str">Slot 2</Property>
					<Property Name="crio.RequiresValidation" Type="Bool">false</Property>
					<Property Name="crio.SDcounterSlaveChannelMask" Type="Str">0</Property>
					<Property Name="crio.SDCounterSlaveMasterSlot" Type="Str">0</Property>
					<Property Name="crio.SDInputFilter" Type="Str">128</Property>
					<Property Name="crio.SupportsDynamicRes" Type="Bool">true</Property>
					<Property Name="crio.Type" Type="Str">NI 9403</Property>
					<Property Name="cRIOModule.DigitalIOMode" Type="Str">0</Property>
					<Property Name="cRIOModule.DisableArbitration" Type="Str">false</Property>
					<Property Name="cRIOModule.EnableSpecialtyDigital" Type="Str">false</Property>
					<Property Name="cRIOModule.Initial Line Direction" Type="Str">00000000000000000000000000000000</Property>
					<Property Name="FPGA.PersistentID" Type="Str">{95824955-0C98-4AE7-B42B-A2804562D279}</Property>
				</Item>
				<Item Name="Dependencies" Type="Dependencies"/>
				<Item Name="Build Specifications" Type="Build">
					<Item Name="FPGA_MAin" Type="{F4C5E96F-7410-48A5-BB87-3559BC9B167F}">
						<Property Name="AllowEnableRemoval" Type="Bool">false</Property>
						<Property Name="BuildSpecDecription" Type="Str"></Property>
						<Property Name="BuildSpecName" Type="Str">FPGA_MAin</Property>
						<Property Name="Comp.BitfileName" Type="Str">crio-9068-scan-t_FPGATarget_FPGAMAin_XA2NADVDmlU.lvbitx</Property>
						<Property Name="Comp.CustomXilinxParameters" Type="Str"></Property>
						<Property Name="Comp.MaxFanout" Type="Int">-1</Property>
						<Property Name="Comp.RandomSeed" Type="Bool">false</Property>
						<Property Name="Comp.Version.Build" Type="Int">0</Property>
						<Property Name="Comp.Version.Fix" Type="Int">0</Property>
						<Property Name="Comp.Version.Major" Type="Int">1</Property>
						<Property Name="Comp.Version.Minor" Type="Int">0</Property>
						<Property Name="Comp.VersionAutoIncrement" Type="Bool">false</Property>
						<Property Name="Comp.Vivado.EnableMultiThreading" Type="Bool">true</Property>
						<Property Name="Comp.Vivado.OptDirective" Type="Str"></Property>
						<Property Name="Comp.Vivado.PhysOptDirective" Type="Str"></Property>
						<Property Name="Comp.Vivado.PlaceDirective" Type="Str"></Property>
						<Property Name="Comp.Vivado.RouteDirective" Type="Str"></Property>
						<Property Name="Comp.Vivado.RunPowerOpt" Type="Bool">false</Property>
						<Property Name="Comp.Vivado.Strategy" Type="Str">Default</Property>
						<Property Name="Comp.Xilinx.DesignStrategy" Type="Str">balanced</Property>
						<Property Name="Comp.Xilinx.MapEffort" Type="Str">default(noTiming)</Property>
						<Property Name="Comp.Xilinx.ParEffort" Type="Str">standard</Property>
						<Property Name="Comp.Xilinx.SynthEffort" Type="Str">normal</Property>
						<Property Name="Comp.Xilinx.SynthGoal" Type="Str">speed</Property>
						<Property Name="Comp.Xilinx.UseRecommended" Type="Bool">true</Property>
						<Property Name="DefaultBuildSpec" Type="Bool">true</Property>
						<Property Name="DestinationDirectory" Type="Path">FPGA Bitfiles</Property>
						<Property Name="NI.LV.FPGA.LastCompiledBitfilePath" Type="Path">//fusion/GoogleDrive/HomeAutomation/projects/cRIO-MQTT/FPGA Bitfiles/crio-9068-scan-t_FPGATarget_FPGAMAin_XA2NADVDmlU.lvbitx</Property>
						<Property Name="NI.LV.FPGA.LastCompiledBitfilePathRelativeToProject" Type="Path">FPGA Bitfiles/crio-9068-scan-t_FPGATarget_FPGAMAin_XA2NADVDmlU.lvbitx</Property>
						<Property Name="ProjectPath" Type="Path">//fusion/GoogleDrive/HomeAutomation/projects/cRIO-MQTT/cRIO-9068-Scan-to-MQTT.lvproj</Property>
						<Property Name="RelativePath" Type="Bool">true</Property>
						<Property Name="RunWhenLoaded" Type="Bool">false</Property>
						<Property Name="SupportDownload" Type="Bool">true</Property>
						<Property Name="SupportResourceEstimation" Type="Bool">false</Property>
						<Property Name="TargetName" Type="Str">FPGA Target</Property>
						<Property Name="TopLevelVI" Type="Ref">/RT CompactRIO Target/Chassis/FPGA Target/FPGA_MAin.vi</Property>
					</Item>
				</Item>
			</Item>
		</Item>
		<Item Name="MQTT-HomeAssistant-Discovery.vi" Type="VI" URL="../MQTT-HomeAssistant-Discovery.vi"/>
		<Item Name="RT-Main.vi" Type="VI" URL="../RT-Main.vi"/>
		<Item Name="MQTT_Functions.lvlib" Type="Library" URL="../LVMQTT-master/MQTT_Functions.lvlib"/>
		<Item Name="Blink.vi" Type="VI" URL="../Blink.vi"/>
		<Item Name="DIO_Test.vi" Type="VI" URL="../DIO_Test.vi"/>
		<Item Name="Sauna_DIO.vi" Type="VI" URL="../Sauna_DIO.vi"/>
		<Item Name="ReadMQTTandUpdateFPGA.vi" Type="VI" URL="../ReadMQTTandUpdateFPGA.vi"/>
		<Item Name="ReadFPGAandPublishMQTT.vi" Type="VI" URL="../ReadFPGAandPublishMQTT.vi"/>
		<Item Name="ReadTempAndUpdateFPGA.vi" Type="VI" URL="../ReadTempAndUpdateFPGA.vi"/>
		<Item Name="FPGA VI Ref.ctl" Type="VI" URL="../FPGA VI Ref.ctl"/>
		<Item Name="Piston Pump Test.vi" Type="VI" URL="../Piston Pump Test.vi"/>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="nisyscfg.lvlib" Type="Library" URL="/&lt;vilib&gt;/nisyscfg/nisyscfg.lvlib"/>
				<Item Name="whitespace.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/whitespace.ctl"/>
				<Item Name="Trim Whitespace.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace.vi"/>
				<Item Name="NI_Real-Time Target Support.lvlib" Type="Library" URL="/&lt;vilib&gt;/NI_Real-Time Target Support.lvlib"/>
				<Item Name="ni_emb.dll" Type="Document" URL="/&lt;vilib&gt;/ni_emb.dll"/>
				<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="Trim Whitespace One-Sided.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace One-Sided.vi"/>
			</Item>
			<Item Name="NiFpgaLv.dll" Type="Document" URL="NiFpgaLv.dll">
				<Property Name="NI.PreserveRelativePath" Type="Bool">true</Property>
			</Item>
		</Item>
		<Item Name="Build Specifications" Type="Build">
			<Item Name="Blink" Type="{69A947D5-514E-4E75-818E-69657C0547D8}">
				<Property Name="App_copyErrors" Type="Bool">true</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{6DBCEC38-6146-4915-A484-EB6BC0CF4BCC}</Property>
				<Property Name="App_INI_GUID" Type="Str">{0B95C27D-654C-461F-9B87-31BD43CBAE06}</Property>
				<Property Name="App_serverConfig.httpPort" Type="Int">8002</Property>
				<Property Name="Bld_autoIncrement" Type="Bool">true</Property>
				<Property Name="Bld_buildCacheID" Type="Str">{80937A5B-4357-41BB-9C68-23AB7A606FAD}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">Blink</Property>
				<Property Name="Bld_excludeInlineSubVIs" Type="Bool">true</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">../builds/blink</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToProject</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{61E77468-8BFE-4B3C-80D8-39347602352A}</Property>
				<Property Name="Bld_targetDestDir" Type="Path">/home/lvuser/natinst/bin</Property>
				<Property Name="Bld_version.build" Type="Int">1</Property>
				<Property Name="Bld_version.major" Type="Int">1</Property>
				<Property Name="Destination[0].destName" Type="Str">startup.rtexe</Property>
				<Property Name="Destination[0].path" Type="Path">/home/lvuser/natinst/bin/startup.rtexe</Property>
				<Property Name="Destination[0].path.type" Type="Str">&lt;none&gt;</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">/home/lvuser/natinst/bin/data</Property>
				<Property Name="Destination[1].path.type" Type="Str">&lt;none&gt;</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Source[0].itemID" Type="Str">{04F8DE63-47E1-4A1C-BAF4-82B150A1C558}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/RT CompactRIO Target/Blink.vi</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">2</Property>
				<Property Name="TgtF_fileDescription" Type="Str">Blink</Property>
				<Property Name="TgtF_internalName" Type="Str">Blink</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">Copyright © 2023 </Property>
				<Property Name="TgtF_productName" Type="Str">Blink</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{9B703ED5-628C-4287-BF56-1560872ADF0C}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">startup.rtexe</Property>
				<Property Name="TgtF_versionIndependent" Type="Bool">true</Property>
			</Item>
			<Item Name="Sauna" Type="{69A947D5-514E-4E75-818E-69657C0547D8}">
				<Property Name="App_copyErrors" Type="Bool">true</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{1CFF9E49-0A1D-4ABA-842B-C4C08E38BD95}</Property>
				<Property Name="App_INI_GUID" Type="Str">{C7FD73EE-4974-4A7C-85DD-84A70EC9E7CA}</Property>
				<Property Name="App_serverConfig.httpPort" Type="Int">8002</Property>
				<Property Name="App_serverType" Type="Int">0</Property>
				<Property Name="Bld_autoIncrement" Type="Bool">true</Property>
				<Property Name="Bld_buildCacheID" Type="Str">{1C811B57-CDB6-43EB-A67B-F645A394BF34}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">Sauna</Property>
				<Property Name="Bld_excludeInlineSubVIs" Type="Bool">true</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">../builds</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToProject</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{293CA807-B2FF-4CA9-A255-EBADCBAA7EF2}</Property>
				<Property Name="Bld_targetDestDir" Type="Path">/home/lvuser/natinst/bin</Property>
				<Property Name="Bld_version.build" Type="Int">1</Property>
				<Property Name="Bld_version.major" Type="Int">1</Property>
				<Property Name="Destination[0].destName" Type="Str">startup.rtexe</Property>
				<Property Name="Destination[0].path" Type="Path">/home/lvuser/natinst/bin/startup.rtexe</Property>
				<Property Name="Destination[0].path.type" Type="Str">&lt;none&gt;</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">/home/lvuser/natinst/bin/data</Property>
				<Property Name="Destination[1].path.type" Type="Str">&lt;none&gt;</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Source[0].itemID" Type="Str">{9937B8C0-B7A4-4ED0-A325-70CFE1FC15A2}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/RT CompactRIO Target/RT-Main.vi</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">2</Property>
				<Property Name="TgtF_fileDescription" Type="Str">Sauna</Property>
				<Property Name="TgtF_internalName" Type="Str">Sauna</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">Copyright © 2024 </Property>
				<Property Name="TgtF_productName" Type="Str">Sauna</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{20E98A0E-A010-4376-B30B-DDF4F8A448FC}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">startup.rtexe</Property>
				<Property Name="TgtF_versionIndependent" Type="Bool">true</Property>
			</Item>
		</Item>
	</Item>
</Project>
