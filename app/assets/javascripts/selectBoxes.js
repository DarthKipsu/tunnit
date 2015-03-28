var selects = function() {
    $('.select2').select2()
}
$(document).ready(selects)
$(document).on('page:load', selects)
