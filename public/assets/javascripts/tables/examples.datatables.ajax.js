
(function( $ ) {

	'use strict';

	var datatableInit = function() {

		var $table = $('#datatable-ajax');
		var t = $table.DataTable({
			bProcessing: true,
            serverSide: true,
			sAjaxSource: $table.data('url'),
			iDisplayLength: 10,
            "pagingType": "full_numbers",
            "order": [[ 0, 'desc' ]],
		});
	};

	$(function() {
		datatableInit();
	});

}).apply( this, [ jQuery ]);