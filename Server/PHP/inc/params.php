<?php

$appName = $_GET["appName"];
if (!isset($appName)) {
    echo $appName;
    header("HTTP/1.0 404 Not Found");
}
$upperCasedAppName = ucfirst($appName);

$lang = "en";
if (array_key_exists("language", $_GET)) {
    $lang = $_GET["language"];
}
if (array_key_exists("lang", $_GET)) {
    $lang = $_GET["lang"];
}

$appPath = "apps/".$appName."/".$lang."/";
$markdownPath = ($appPath.$appName."-".$lang.".markdown");
if (!file_exists($markdownPath)) {
    header("HTTP/1.0 404 Not Found");
    exit();
}

?>