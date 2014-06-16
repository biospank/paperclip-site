$(document).ready ->
	$('#easy').popover(
		container: 'body'
		placement: 'top'
		trigger: 'over'
		delay: { show: 500, hide: 100 }	
	)
	$('#prof').popover(
		container: 'body'
		placement: 'right'
		trigger: 'over'
		delay: { show: 500, hide: 100 }	
	)
