<?php

require_once("lib/Parsedown.php");

include_once("config/config.php");
include_once("inc/params.php");
include_once("inc/contact.php");

$FAQs = "FAQ";
if ($lang=="de") {
    $back = "zur&uuml;ck";
    $title = "FAQs f&uuml;r $appName";
    $searchFAQs = "Im FAQs suchen...";
} else {
    $back = "Back";
    $title = "FAQs for $appName";
    $searchFAQs = "Search FAQs...";
}

?>

<!DOCTYPE html>
<html>
<head>
    <title><?php echo $title; ?></title>
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.1/jquery.mobile-1.4.1.min.css" />
    <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jquerymobile/1.4.0/jquery.mobile.min.css" />
    <style type="text/css">
        #index .detail{display:none;}
        .ui-header{position: fixed; width:100%;}
        h1{margin-top:1.5em;}
    </style>
</head>
<body>
    <div data-role="page" id="index">
        <div id="faqs" data-role="content">
            <?php
                $parsedown = new Parsedown();
                $html = $parsedown->parse(file_get_contents($markdownPath));
                echo $html;
            ?>
        </div>
        <div data-role="content">
            <?php
                $parsedown = new Parsedown();
                $html = $parsedown->parse($contactMarkdown);
                echo $html;
            ?>
        </div>

        <div data-theme="a" data-role="footer" data-position="fixed">

        </div>
    </div> 
    <div data-role="page" id="detail">
        <div data-theme="a" data-role="header">
            <h3><?php echo $FAQs; ?></h3>
            <a href="#index" class="ui-btn-left"><?php echo $back; ?></a>
        </div>

        <div data-role="content">

        </div>

        <div data-theme="a" data-role="footer" data-position="fixed">

        </div>
    </div>    

    <script src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
    <script src="http://code.jquery.com/mobile/1.4.1/jquery.mobile-1.4.1.min.js"></script>
    <script type="text/javascript">
        var id = 1;
        var items = $( "#faqs > h1" );
        var listContainer = $("<ul></ul>");
        items.each( function( indexList, elementList ){
            var title = this;
            var container = $("<li></li>");
            $(this).nextUntil("h1").each( function( index, element ){
                console.log(element);
                container.append($(element).remove());
                $(element).addClass("detail");
            });
            $linkedTitle = $(title).wrapInner( "<a href='#' id='"+id+"' style='white-space:normal;'></a>").remove();
            container.prepend($linkedTitle.html());
            listContainer.append(container);
            id++;
        });
        $("#faqs").append(listContainer);

        $("ul").attr({  "data-role":"listview", 
                        "data-theme":"a", 
                        "id":"test-listview", 
                        "data-filter":"true", 
                        "data-filter-placeholder":"<?php echo $searchFAQs; ?>", 
                        "data-inset":"true"});

        $(document).on('pagebeforeshow', '#index', function(){       
            $('#test-listview li a').each(function(){
                var elementID = $(this).attr('id');      
                $(document).on('click', '#'+elementID, function(event){  
                    if(event.handled !== true) // This will prevent event triggering more then once
                    {
                        listObject.itemID = elementID;
                        listObject.answer = $(":gt(0)", $( this ).parent()).parent().html();
                        $.mobile.changePage( "#detail", { transition: "slide", changeHash:false} );
                        event.handled = true;
                    }              
                });
            });
        });

        $(document).on('pagebeforeshow', '#detail', function(){       
            var $detailHolder = $('#detail [data-role="content"]');
            $detailHolder.html(listObject.answer);
            var question = $('a', $detailHolder).first().html();
            $("a", $detailHolder).first().remove();
            $detailHolder.prepend("<h1>"+question+"</h1>");
            $("#detail img").load(function(){
                var width = $(this).width()/2;
                var height = $(this).height()/2;
                $(this).width(width);
                $(this).height(height);
            });
        });

        var listObject = {
            itemID : null
        }

    </script>
</body>
</html>