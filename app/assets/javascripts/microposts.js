$(function() { 
  $('#micropost_content').bind('keyup',function(){
    var count = 140 - $('#micropost_content').val().length;
    $('#letters_counter').text(count+" letters left");
    }).change();
  });