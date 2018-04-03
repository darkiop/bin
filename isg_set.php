<?php
/**
 * set Parameters for Stiebel Eltron over ISG Web (Version: 8.5.6)
 * 
 * call http://isg-url/isg_set.php?parameter=wert
 *      http://isg-url/isg_set.php?luefterstufetag=3
 *
 * call with cli 'php isg_set.php parameter=wert'
 *
 */

// debug true/false
$debug = false;

// isg login true/false
$login = false;

// auth
$isg_website = "http://isg";
$isg_user = "";
$isg_pw = "";

// ccu2 sv
$ccu_ip = "192.168.1.74";
$ccu_url_set_sv_luefterstufetag = "http://".$ccu_ip."/addons/db/state.cgi?item=ISG_LUEFTERSTUFE&value=";
$ccu_url_set_sv_betriebsart = "http://".$ccu_ip."/addons/db/state.cgi?item=ISG_BETRIEBSART&value=";

// iobroker datapoint
$iobroker_ip = "192.168.1.43:8087";
$iobroker_dp_betriebsart = "hm-rega.0.4147";
$iobroker_dp_luefterstufetag = "hm-rega.0.4156";
$iobroker_set_luefterstufetag = "http://".$iobroker_ip."/set/".$iobroker_dp_luefterstufetag."?value=";
$iobroker_set_betriebsart = "http://".$iobroker_ip."/set/".$iobroker_dp_betriebsart."?value=";

// redirect url (iobroker.vis view)
$redirect = "http://odin:8082/vis/index.html?material#1_page_Klima";

// argv to $_GET (for use with cli)
if (isset($argv)) {
    if ($debug) { var_dump($argv); };
    foreach ($argv as $arg) {
        $e=explode("=",$arg);
        if(count($e)==2)
            $_GET[$e[0]]=$e[1];
        else   
            $_GET[$e[0]]=0;
    }
    if ($debug) { var_dump($_GET); };
}

if (!$_GET) {
    echo "Kein Parameter angegeben!";
    exit;
}

// set isg parameters
function set_isg_para($para, $value) {

    global $isg_website;
    global $isg_user;
    global $isg_pw;

    $cu = curl_init(); 
    curl_setopt($cu, CURLOPT_URL, $isg_website."/save.php");
    curl_setopt ($cu, CURLOPT_POST, 1); 
    
    if($login == false) {
        curl_setopt ($cu, CURLOPT_POSTFIELDS, "make=send");
    } elseif ($login == true) {
        // TODO geht nicht ...
        curl_setopt ($cu, CURLOPT_POSTFIELDS, "make=send&pass=".$isg_pw."&user=".$isg_user."");
    }

    curl_setopt($cu, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt ($cu, CURLOPT_COOKIEJAR, 'cookie.txt');
    curl_setopt ($cu, CURLOPT_RETURNTRANSFER, 1);
    $req = curl_exec ($cu); // request mit Anmeldedaten abschicken

    curl_setopt ($cu, CURLOPT_POSTFIELDS, "data=".$para);
    $req1 = curl_exec ($cu); // request mit den Änderungsdaten abschicken 
    
    $response = curl_getinfo( $cu ); 
    curl_close ($cu);

}

// set ccu sv and iobroker dp
function set_sv_and_dp($sv, $sleeptime){

    global $ccu_url_set_sv_luefterstufetag;
    global $ccu_url_set_sv_betriebsart;
    global $iobroker_set_luefterstufetag;
    global $iobroker_set_betriebsart;

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $sv);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_exec($ch);
    curl_close($ch);
    sleep($sleeptime);

}

// Lüfterstufe Tag
// Gültige Werte:
// 0 - 3
if(isset($_GET["luefterstufetag"])) {

    $value_get = $_GET["luefterstufetag"];
    $min = 0;
    $max = 3;

    if ( ($value_get >= $min) && ($value_get <= $max) ) {
        
        $para=rawurlencode("[{\"name\":\"val82\",\"value\":".$value_get."}]");
        
        if ($debug == true) { var_dump($para); $para = rawurldecode($para); var_dump($para); };
        if ($debug == false) { set_isg_para($para, $value_get); };
        
        # set ccu sv and iobroker dp
        $ccu_url_set_sv_luefterstufetag = $ccu_url_set_sv_luefterstufetag.$value_get;
        $iobroker_set_luefterstufetag = $iobroker_set_luefterstufetag.$value_get;
        set_sv_and_dp($ccu_url_set_sv_luefterstufetag, 1);
        set_sv_and_dp($iobroker_set_luefterstufetag, 1);
       
        # forward to ioBroker.vis
        header('Location:' .$redirect);

        exit;

    } else {
        
        echo "falscher Wert für die Lüfterstufe-Tag, Vorgabe: Zwischen ".$min." und ".$max." !\n";
        
        exit;

    }
    
}

// Betriebsart
// Gültige Werte:
// 11 = AUTOMATIK, 1 = BEREITSCHAFT, 3 = TAGBETRIEB, 4 = ABSENKBETRIEB,
// 5 = WARMWASSER, 14 = HANDBETRIEB, 0 = NOTBETRIEB
if(isset($_GET["betriebsart"])) {

    $value_get = $_GET["betriebsart"];
    if ($value_get == "automatik") {
        $value = "11";
    } elseif ($value_get == "warmwasser") {
        $value = "5";
    } else {
        $value = null;
        echo "falscher Wert für die Betriebsart angegeben!\n";
        echo "korrekte Werte: automatik, warmwasser\n";
        exit;
    };
    
    $para=rawurlencode("[{\"name\":\"val39s\",\"value\":".$value."}]");
    
    if ($debug == true) { var_dump($para); $para = rawurldecode($para); var_dump($para); };
    if ($debug == false) { set_isg_para($para, $value); };

    if ($value_get == "automatik") {
        $value_get = "Automatik";
    } elseif ($value_get == "warmwasser") {
        $value_get = "Warmwasser";
    }

    # set ccu sv and iobroker dp
    $ccu_url_set_sv_betriebsart = $ccu_url_set_sv_betriebsart.$value_get;
    $iobroker_set_betriebsart = $iobroker_set_betriebsart.$value_get;
    set_sv_and_dp($ccu_url_set_sv_betriebsart, 1);
    set_sv_and_dp($iobroker_set_betriebsart, 1);

    # forward to ioBroker.vis
    header('Location:' .$redirect);

    exit;

}

// Raumtemperatur Tag
// Gültige Werte:
// 10.0 - 30.0
if(isset($_GET["raumtemptag"])) {
    $value = $_GET["raumtemptag"];
    $min = 10;
    $max = 30;
    if ( ($min <= $value) && ($value <= $max) ) {
        $para=rawurlencode("[{\"name\":\"val5\",\"value\":".$value."}]");
        if ($debug == true) { var_dump($para); $para = rawurldecode($para); var_dump($para); };
        if ($debug == false) { set_isg_para($para, $value); };
    } else {
        echo "falscher Wert für die Raum-Temperatur Tag, Vorgabe: Zwischen ".$min." und ".$max." !\n";
        exit;
    }
}

// Warmwasser-Temperatur Tag
// Gültige Werte:
// 10.0 - 55.0
if(isset($_GET["warmwassertemptag"])) {
    $value = $_GET["warmwassertemptag"];
    $min = 10;
    $max = 55;
    if ( ($min <= $value) && ($value <= $max) ) {
        $para=rawurlencode("[{\"name\":\"val17\",\"value\":".$value."}]");
        if ($debug == true) { var_dump($para); $para = rawurldecode($para); var_dump($para); };
        if ($debug == false) { set_isg_para($para, $value); };
    } else {
        echo "falscher Wert für die Warmwasser-Temperatur Tag, Vorgabe: Zwischen ".$min." und ".$max." !\n";
        exit;
    }
}

?>