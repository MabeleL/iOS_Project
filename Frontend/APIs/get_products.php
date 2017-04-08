<?php

    $IP = "localhost";
    $user = "acknotec_briq";
    $pass = "Password123";
    $db = "acknotec_briq";

$username = $_REQUEST['username'];

    $con = mysqli_connect($IP, $user, $pass, $db);

$query = "SELECT * FROM products,users where products.name=users.username and users.username='$username'";

        $result = $con->query($query);

		if ($result->num_rows > 0) {	
		
		
			// output data of each row
			while($row = $result->fetch_assoc()) {
			//echo$row['type']
			$arr = array('weight' => $row['weight'], 'price' => $row['price'], 'location' => $row['location']);

echo json_encode($arr);
			
			}
		} else {
			$arr = array('response' => "0");
   				echo json_encode($arr);
   			//echo "0";
		}
		//echo json_encode($arr);
		$con->close();
?>