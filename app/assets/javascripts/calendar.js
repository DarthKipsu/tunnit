var loadCalendar = function() {
    $('#calendar').fullCalendar({
        defaultView: 'agendaWeek',
        firstDay: 1,
        weekNumbers: true,
        businessHours: {
            start: '8:00',
            end:   '16:00',
            dow: [ 1, 2, 3, 4, 5]
        },
        scrollTime: '7:00',
        aspectRatio: 1.7,
        events: '/events.json'
    });
}
$(document).ready(loadCalendar);
$(document).on('page:load', loadCalendar);
