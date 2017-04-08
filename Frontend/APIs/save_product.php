<?php

    $IP = "localhost";
    $user = "acknotec_briq";
    $pass = "Password123";
    $db = "acknotec_briq";

    $con = mysqli_connect($IP, $user, $pass, $db);

$username = $_REQUEST['username'];
$weight = $_REQUEST['weight'];
$price = $_REQUEST['price'];
$location = $_REQUEST['location'];

$query = ("INSERT INTO `products`(`name`, `weight`, `price`, `location`) VALUES('$username','$weight','$price','$location')");

        mysqli_query($con, $query);
        
        $arr = array('response' => "1");
   	echo json_encode($arr);
  // echo "1";

?>