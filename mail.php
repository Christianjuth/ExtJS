<?php
if (empty($_POST["name"])) {
    echo json_encode('Name is required');
}

elseif  (empty($_POST["email"])) {
    echo json_encode('Email is required');
}

elseif  (empty($_POST["message"])) {
    echo json_encode('Message is required');
}

else{
    $to = "support@ext-js.org"; // this is your Email address
    $from = "website@ext-js.org"; // this is the sender's Email address
//    $from = $_POST["email"]; // this is the sender's Email address
    $name = $_POST['name'];
    $subject = "Form submission";
    $message = "Name: " . $name . "\nEmail: " . $_POST['email'] . "\nFavorite Song: " . $_POST['favorite_song'] . "\nMessage: " . $_POST['message'];

    $headers = 'MIME-Version: 1.0' . "\r\n";
    $headers .= 'Content-type: text/plain; charset=iso-8859-1' . "\r\n";
    $headers .= 'From:' . $from . "\r\n";

    mail($to,$subject,$message,$headers);
    echo json_encode('true');
}
?>
