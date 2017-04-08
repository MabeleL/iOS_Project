<?php

    $IP = "localhost";
    $user = "acknotec_briq";
    $pass = "Password123";
    $db = "acknotec_briq";

    $con = mysqli_connect($IP, $user, $pass, $db);
    
    
$username = $_REQUEST['username'];
$password = $_REQUEST['password'];

$query = "SELECT * FROM users where username='$username' and password='$password' and Active=1";

        $result = $con->query($query);

		if ($result->num_rows > 0) {
		
		
		
			// output data of each row
			while($row = $result->fetch_assoc()) {
			if ($row['type'] == "Farmer")
			{
			$arr = array('response' => "1");
   				echo json_encode($arr);
   				}
   				else
   				{
   				$arr = array('response' => "2");
   				echo json_encode($arr);
   				}
			}
		} else {
			$arr = array('response' => "0");
   				echo json_encode($arr);
   			//echo "0";
		}
		$con->close();
?>