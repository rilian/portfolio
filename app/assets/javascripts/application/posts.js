var Posts = (function(){
  return {
      add_fields: function(link, association, content) {
        var new_id = new Date().getTime();
        var regexp = new RegExp("new_" + association, "g");
        $(link).before(content.replace(regexp, new_id));
      },

      remove_fields: function(link) {
        $(link).prev("input[type=hidden]").val("1");
        $(link).closest(".fields").hide();
      },

      fill_file_upload: function (element, result) { // private
        if(result.error) {
          alert('Error uploading image!');
        } else {
          element.find("input.file-upload-cache").val(result.name);
          element.find("input.file-upload-cache-changed").val(true);

          //use thumb for video file, if needed
          if(result.type == 'image') {
            var $container = element.parents("div.file-upload-container").length > 0 ? element.parents("div.file-upload-container") : element;
            $container.find("div.cache-image-holder").html('' +
                '<a href="' + result.url + '" class="fancybox image-container"><img src="' + result.thumbnail_url + '"></a>' +
                '<!--<a href="#" class="to_body">Insert into body</a>-->');
            assign_fancyboxes();
            assign_copy_image_to_text();
          }
        }
      }
    };
})();

function assign_copy_image_to_text() {
  $("#main").on("click", '.to_body', function(e) {
    var body = $('textarea#post_body');
    var domain = document.location.protocol + '//' + document.location.host;
    var text = body.val() + "\n" + ' !' + domain + $(this).parents('.cache-image-holder').find('a.image-container img').attr('src') + '!:' + domain + $(this).parents('.cache-image-holder').find('a.image-container').attr('href');
    body.val(text);
    e.preventDefault();
  });
}

$(function() {

  // attach file-upload event after 1st click on container div
  $("#main").on("click", 'div.file-upload', function() {
    var file_upload_container = $(this);
    file_upload_container.find('.file-upload-input').fileupload({
      dataType: 'json',
      method: 'POST',
      url: file_upload_container.data('upload_href'),
      done: function (e, data) {
        if(data.result.error) {
          alert(data.result.error);
        }else{
          Posts.fill_file_upload(file_upload_container, data.result);
        }
        file_upload_container.parents('div.file-upload-container').find('span.callback_displayer').html('Uploading Finished').addClass("green-text");
      },
      add: function(e, data) {
        data.submit();
      },
      progress: function(e, data) {
        var progress = data.total != 0 ? parseInt(data.loaded / data.total * 100, 10) : 100;
        file_upload_container.parents('div.file-upload-container').find('span.callback_displayer').html(progress + "%").addClass("red-text");
      },
      fail: function(e, data) {
        alert(data.errorThrown || 'Interrupted');
      }
    });
  });

  assign_copy_image_to_text();
});

