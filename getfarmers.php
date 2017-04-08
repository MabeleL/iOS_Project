<?php

    $IP = "localhost";
    $user = "acknotec_briq";
    $pass = "Password123";
    $db = "acknotec_briq";

    $con = mysqli_connect($IP, $user, $pass, $db);

$query = "SELECT * FROM users where type='farmer' and Active=1";

        $result = $con->query($query);

		if ($result->num_rows > 0) {	
		
		
			// output data of each row
			while($row = $result->fetch_assoc()) {
			//echo$row['type']
			$arr[] = array('username' => $row['username'], 'phone' => $row['phone']); // return json object

//echo json_encode($arr);
			
			}
			echo json_encode($arr);
		} else {
			$arr = array('response' => "0");
   				echo json_encode($arr);
   			//echo "0";
		}
		$con->close();
?>