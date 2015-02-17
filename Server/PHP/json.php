<?php
header('Content-Type: application/json');
header('Content-type: text/html; charset=UTF-8');

include_once("config/config.php");
include_once("inc/params.php");
include_once("inc/contact.php");

$lines = file($markdownPath);
$faqs = array();

$currentTitle = "";
$currentContent = "";

foreach ($lines as $line) {
    if(isTitleLine($line)) {
        $hasFinishedSection = strlen($currentTitle)>0;
        if ($hasFinishedSection) {
            $faqs[] = array("title"=>$currentTitle, "detail"=>$currentContent);
        }
        $currentTitle = rtrim($line, "\n");
        $currentContent = "";
    }else{
        $currentContent .= $line;
    }
}

$help = array('faqs' => $faqs, 'contact' => $contactMarkdown);

print_r(json_encode($help));

function isTitleLine($line) {
    return preg_match('/^# .*/', $line);
}

?>

