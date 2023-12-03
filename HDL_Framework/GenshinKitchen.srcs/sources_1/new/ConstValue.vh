//---------------IO Index---------------
//这些可能要改动的
//-----Input-----
`define Inp_Switch_Start 0,

`define In_Button_Get 0,
`define In_Button_Put 1,
`define In_Button_Interact 2,
`define In_Button_Move 3,
`define In_Button_Throw 4,
`define In_Button_TargetUp 5,
`define In_Button_TargetDown 6,

//-----Output-----
`define Out_LED_InfrontTargetMachine 0,
`define Out_LED_HasItemInHand 1,
`define Out_LED_IsProcessing 2,
`define Out_LED_MachineHasItem 3,

//---------------URAT Communication Protocol---------------

//Channel
`define Sender_Channel_Ignore 2'b00
`define Sender_Channel_GameStateChanged 2'b01
`define Sender_Channel_Operate 2'b10
`define Sender_Channel_TargetMachineChanged 2'b11
`define Receiver_Channel_Ignored 2'b00,
`define Receiver_Channel_FeedBack 2'b01,
`define Receiver_Channel_ScriptLoading 2'b10,
`define Receiver_Channel_Unused 2'b11

//-----Sender Code-----
//GameState
`define Sender_GameState_Start 6'b0000_01,
`define Sender_GameState_Stop 6'b0000_10,
//Operation
`define Sender_Operation_Get 6'b0_00001,
`define Sender_Operation_Put 6'b0_00010,
`define Sender_Operation_Interact 6'b0_00100,
`define Sender_Operation_Move 6'b0_01000,
`define Sender_Operation_Throw 6'b0_10000,
//Targeting Machine
`define Sender_Targeting_Initial 6'b000_001

//-----Receiver Code-----
`define Receiver_Feedback_InfrontTargetMachine 2
`define Receiver_Feedback_HasItemInHand 3
`define Receiver_Feedback_IsProcessing 4
`define Receiver_Feedback_MachineHasItem 5


//---------------Script Encode---------------