<?php

$recipients = $_GET['phoneNumber'];
$message = $_GET['text'];

// Be sure to include the file you've just downloaded
require_once('AfricasTalkingGateway.php');
// Specify your login credentials
$username   = "jerrydindi";
$apikey     = "8cabd113e66832a8d1c8c34fac7badadaa2ed974cb28a3b898f6fbb0690a7b83";
// NOTE: If connecting to the sandbox, please use your sandbox login credentials
// Specify the numbers that you want to send to in a comma-separated list
// Please ensure you include the country code (+250 for Rwanda in this case)
//$recipients = "+254727399505"; //"+250736YYYXXX,+250734XXXZZZ";
// And of course we want our recipients to know what we really do
//$message    = "I'm a lumberjack and its ok, I sleep all night and I work all day";
// Create a new instance of our awesome gateway class
$gateway    = new AfricasTalkingGateway($username, $apikey);
// NOTE: If connecting to the sandbox, please add the sandbox flag to the constructor:
/*************************************************************************************
             ****SANDBOX****
$gateway    = new AfricasTalkingGateway($username, $apiKey, "sandbox");
**************************************************************************************/
// Any gateway error will be captured by our custom Exception class below,
// so wrap the call in a try-catch block
try
{
  // Thats it, hit send and we'll take care of the rest.
  $results = $gateway->sendMessage($recipients, $message);

  foreach($results as $result) {
    // status is either "Success" or "error message"
 /*   echo " Number: " .$result->number;
    echo " Status: " .$result->status;
    echo " MessageId: " .$result->messageId;
    echo " Cost: "   .$result->cost."\n"; */

    if ($result->status == "Success")
    {
    	$arr = array('response' => "1");
   	echo json_encode($arr);
    }
    else
    {
    	$arr = array('response' => "0");
   	echo json_encode($arr);
    }
  }
}
catch ( AfricasTalkingGatewayException $e )
{
  echo "Encountered an error while sending: ".$e->getMessage();
}
// DONE!!!
?>