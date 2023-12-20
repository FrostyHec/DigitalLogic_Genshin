//---------------IO Index---------------
//这些可能要改动的
//-----Input-----
//表示[7:0]的位宽中哪一位是用来干嘛的，
//比如我要拿state状态时，我就写switches[`In_Switch_state]即可
`define In_Switch_GameStart 0
`define In_Switch_GameEnd 1
`define In_Switch_TargetUp 6
`define In_Switch_TargetDown 7


`define In_Button_Get 0
`define In_Button_Put 1
`define In_Button_Interact 2
`define In_Button_Move 3
`define In_Button_Throw 4



//-----Output-----
`define Out_LED_InfrontTargetMachine 0
`define Out_LED_HasItemInHand 1
`define Out_LED_IsProcessing 2
`define Out_LED_MachineHasItem 3

//-----Encoder-----
// `define Encoder_Btn_TargetUp 1
// `define Encoder_Btn_TargetDown 0
// `define Encoder_btn


//---------------URAT Communication Protocol---------------

//Channel
`define Sender_Channel_Ignore 2'b00
`define Sender_Channel_GameStateChanged 2'b01
`define Sender_Channel_Operate 2'b10
`define Sender_Channel_TargetMachineChanged 2'b11
`define Receiver_Channel_Ignored 2'b00
`define Receiver_Channel_FeedBack 2'b01
`define Receiver_Channel_ScriptLoading 2'b10
`define Receiver_Channel_Unused 2'b11

//-----Sender Code-----
//Ignore
`define Sender_Data_Ignore 6'b000_000
//GameState
`define Sender_GameState_Start 6'b0000_01
`define Sender_GameState_Stop 6'b0000_10
//Operation
`define Sender_Operation_Get 6'b0_00001
`define Sender_Operation_Put 6'b0_00010
`define Sender_Operation_Interact 6'b0_00100
`define Sender_Operation_Move 6'b0_01000
`define Sender_Operation_Throw 6'b0_10000
//Targeting Machine
`define Targeting_Initial 6'b000_001
`define Targeting_Max 6'b010_100

//-----Receiver Code-----
`define Receiver_Feedback_InfrontTargetMachine 2
`define Receiver_Feedback_HasItemInHand 3
`define Receiver_Feedback_IsProcessing 4
`define Receiver_Feedback_MachineHasItem 5


//--------------The Game Itself---------------
//-----targets-----
//-----stroage create-----
`define Game_Flower_box 6'b000_001
`define Game_Wheat_box 6'b000_010
`define Game_Meat_box 6'b000_011
`define Game_Salt_box 6'b000_100
`define Game_Berry_box 6'b000_101
`define Game_Chili_box 6'b000_110

//-----tables-----
`define Game_Table_1 6'b001_001
`define Game_Table_2 6'b001_011
`define Game_Table_3 6'b001_110
`define Game_Table_4 6'b010_001
`define Game_Table_5 6'b010_011

//-----trash bin-----
`define Game_Trash_bin 6'b010_100

//-----peocess machines-----
`define Game_Stone_Mill 6'b000_111 //manual
`define Game_Cutting_Machine 6'b001_000 //automatic

//-----combine machines-----
`define Game_Workbench 6'b001_111 //manual
`define Game_Mixer 6'b010_000 //automatic

//-----cooking machines-----
`define Game_Stove 6'b001_010 //fully automatic
`define Game_Oven_1 6'b001_100
`define Game_Oven_2 6'b001_101


`define Game_Customer 6'b010_010

//Endcoder
`define oe_get 5'b000_01
`define oe_put 5'b000_10
`define oe_int 5'b001_00
`define oe_mov 5'b010_00
`define oe_thr 5'b100_00
`define gst_st 2'b01
`define gst_ed 2'b10