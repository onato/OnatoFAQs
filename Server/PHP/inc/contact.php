<?php

include("inc/contact-".$lang.".markdown.php");

$contactMarkdown = $defaultContactInfo;
$contactPath = $appPath."contact-".$lang.".markdown";

if (file_exists($contactPath)) {
	$contactMarkdown = file_get_contents($contactPath);
}

?>