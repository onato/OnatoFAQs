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
    $subject = $line;
    $pattern = '/^\* .*/';
    if (substr($line, 0, 1) == "#") {
        $pattern = '/^# .*/';
    }
    if(preg_match($pattern, $subject)) {
        if (strlen($currentTitle)>0) {
            $faqs[] = array("title"=>$currentTitle, "detail"=>$currentContent);
        }
        $currentTitle = $line;
        $currentContent = "";
    }else{
        $currentContent .= $line."\n";
    }

}

$help = array('faqs' => $faqs, 'contact' => $contactMarkdown);

print_r(json_encode($help));

?>

