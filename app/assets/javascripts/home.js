$(function() {
  $('.thumbnails a.fancybox').popover({
    placement: 'bottom'
  }).fancybox({
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