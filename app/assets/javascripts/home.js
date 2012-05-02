$(function() {
  $('a.has_popover').popover({
    placement: 'bottom'
  });

  $('a.fancybox').fancybox({
    arrows: true,
    nextClick: true,
    mouseWheel: true,
    loop: true,
    type: 'image',
    openSpeed: 'fast',
    closeSpeed: 'fast',
    openEffect: 'elastic',
    closeEffect: 'elastic'
  });
});