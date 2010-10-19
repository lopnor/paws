$(function(){
  $('.vote a').click(function() {
    var url = $(this).attr('href');
    var arr = $(this).attr('id').split('_');
    var id = arr[2];

    $.post(
      url,
      {
        value: arr[1],
      },
      function(data){
        var div = $('#vote_'+id);
        var up = div.find('span.plus').first();
        var down = div.find('span.minus').first();
        up.find('a').text('+' + (data.plus || '0'));
        down.find('a').text('-' + (data.minus || '0'));
        if( data.user > 0 ) {
          up.addClass('user');
          down.removeClass('user');
        }
        if( data.user < 0 ) {
          down.addClass('user');
          up.removeClass('user');
        }
      },
      'json'
    );
    return false;
  });
  $('span.ownership a.ownership').click(function(){
    var id = ($(this).attr('id').split('_'))[1];
    var url = $(this).attr('href');
    $.post(
      url,
      {
        issue_id: id,
        token: document.paws_token
      },
      function(data) {
        var span = $('span.ownership');
        span.text('you are owner of this issue.');
      }
    );
    return false;
  });
});
