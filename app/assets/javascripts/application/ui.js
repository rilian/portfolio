var assign_fancyboxes = function(){
  $("a.fancybox").fancybox({
      'hideOnContentClick': true
  });

  $('#main .post .body a').fancybox({
    'hideOnContentClick': true
  });
};

$(document).ready(function() {
  $("a.fancybox-iframe").live('click', function(e) {
    $.fancybox({
      'content': $(this).attr('href'),
      'type': 'iframe'
    });
    e.preventDefault();
  });

  assign_fancyboxes();
});