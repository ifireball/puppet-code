function filter_column(th, filter_func) {
	var col_idx = th.closest('tr').children('th').index(th);
	var hide_class = '_src_hidden' + col_idx;
	var src_class = '_src_col' + col_idx;
	// console.log("Found column at offset: " + col_idx);
	if(!th.hasClass('_searchable')) {
		th.addClass('_searchable');
		th.closest('table')
		.find('tbody > tr > :nth-child(' + col_idx + 1 + ')')
		//.find('tbody tr td')
		.addClass(src_class);
		$('head').append('<style type="text/css">' + 
			'tr.' + hide_class + ' { display: none; }' +
			'</style>');
	}
	th.closest('table').find('.' + src_class)
	.each(function(i, e_td) {
		var td = $( e_td );
		if(filter_func(td)) {
			td.closest('tr').removeClass(hide_class);
		} else {
			td.closest('tr').addClass(hide_class);
		}
	});
}

function create_dd_menu() {
	return $('<ul class="dropdown-menu pull-right" role="menu"></ul>');
}

function create_col_dd(menu) {
	return $('<form class="form-inline pull-right" role="form" action="">')
		.on('submit', function(e) {
			e.preventDefault();
			$( this ).find('.dropdown-toggle').first()
				.dropdown('toggle');
		})
		.append($('<div class="btn-group btn-group-xs pull-right">' +
			'<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">' +
			'<span class="caret"></span>' +
			'</button>' +
			'</div>').append(menu).on('shown.bs.dropdown', function(e) {
				$( this ).find('input').first().focus();
			})
		)
}

function add_dd_sort_items(menu) {
	menu.append('<li role="presentation" class="dropdown-header">Sort</li>')
		.append($('<li role="presentation"><label><input type="radio" class="_tbl_sort">Ascending</label></li>'))
		.append($('<li role="presentation"><label><input type="radio" class="_tbl_sort">Descending</label></li>'))
		.find('input._tbl_sort').click(function(e) {
			var $this = $( this );
			$this.closest('table').find('input._tbl_sort').prop('checked', false);
			$this.prop('checked', true);
		});
	return menu;
}

function add_dd_search_item(menu) {
	return menu.append('<li role="presentation" class="dropdown-header">Find</li>')
		.append($('<li role="presentation">')
			.append($('<div class="input-group input-group-sm">')
				.append($('<input class="form-control" type="text" name="search" placeholder="Search..." value="">')
					.click(function(e) {
						e.stopPropagation();
					})
					.keyup(function(e) {
						var $this = $( this );
						var term = $this.val();
						//console.log("serching: " + term)
						$this.closest('.input-group').find('button')
						.prop('disabled', term == '');
						filter_column($this.closest('th'), function(td) {
							return td.text().indexOf(term) >= 0;
						});
					})
				)
				.append($('<span class="input-group-btn">')
					.append($('<button class="btn btn-default" type="button" disabled>' + 
						'<span class="glyphicon glyphicon-remove"></span>' + 
						'</button>')
					).click(function(e) {
						var $this = $( this );
						$this.closest('.input-group')
						.children(':text').val('')
						.trigger('keyup');
					})
				)
			)
		);
}

function add_dd_calendar_item(menu) {
	return menu;
	// TODO
}

function add_dd_lut_items(menu, th) {
	menu.append('<li role="presentation" class="dropdown-header">Show</li>')
		.append($('<li role="presentation"><label><input type="radio" class="_tbl_filter">All</label></li>'));
	return menu;
}

function educate_name_columns() {
	$("th.tcol-name").append(create_col_dd(
		add_dd_sort_items(add_dd_search_item(create_dd_menu()))
	));
}

function educate_date_columns() {
	$("th.tcol-date").append(create_col_dd(
		add_dd_sort_items(add_dd_calendar_item(create_dd_menu()))
	));
}

function educate_lut_columns() {
	$("th.tcol-lut").each(function(i, e_th) {
		var th = $( e_th )
		th.append(create_col_dd(add_dd_lut_items(create_dd_menu(), th)));
	});
}

function educate_columns() {
	educate_name_columns();
	educate_date_columns();
	educate_lut_columns();
}

$( document ).ready(function() {
	educate_columns();
});

