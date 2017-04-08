<?php

    $IP = "localhost";
    $user = "acknotec_briq";
    $pass = "Password123";
    $db = "acknotec_briq";

    $con = mysqli_connect($IP, $user, $pass, $db);

$username= $_REQUEST['username'];
$password = $_REQUEST['password'];
$phone= $_REQUEST['phone'];
$type= $_REQUEST['type'];
$name= $_REQUEST['name'];

$query = ("INSERT INTO `users`(`username`, `phone`, `password`, `active`, `type`) values('$username','$phone','$password','1','$type')");

        mysqli_query($con, $query);
        
        $arr = array('response' => "1");
   	echo json_encode($arr);
  // echo "1";

?>