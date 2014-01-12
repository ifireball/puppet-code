function auto_tab(style = 'tab') {
	$("." + style + "-content-marker").each( function(i, e_tc) {
		var tc = $( e_tc );
		tc.addClass('tab-content');
		var nav = $('<ul class="nav nav-' + style + 's"></ul>');
		tc.children('.tab-pane').each( function(i, e_tp) {
			var tp = $(e_tp);
			var h = tp.children('.tab-head').first();
			var a = $('<a href="#' + tp.attr('id') + '" data-toggle="' + style + '">' + 
				h.html() + '</a>');
			tc.css('padding-top','15px');
			h.remove();
			$('<li></li>').append(a).appendTo(nav);
		});
		nav.insertBefore(tc)
		nav.children('li').first().addClass('active');
		tc.children('.tab-pane').first().addClass('active');
	});
}

$( document ).ready(function() {
	auto_tab('tab');
	auto_tab('pill');
});

