$(document).ready(function() {
	$('#keyword_form').submit(function(event) {
        event.preventDefault();
        $.get('search/'+$('#keyword').val(), 
    		function(data) {
    			$('#result').html(data);
    		});
    });
});