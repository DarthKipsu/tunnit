var loadCalendar = function() {
    $('#calendar').fullCalendar({
        defaultView: 'agendaWeek',
        firstDay: 1,
        timeFormat: 'H(:mm)',
        weekNumbers: true,
        businessHours: {
            start: '8:00',
            end:   '16:00',
            dow: [ 1, 2, 3, 4, 5]
        },
        scrollTime: '7:00',
        aspectRatio: 1.7,
        eventBackgroundColor: '#1abc9c',
        eventBorderColor: '#16a085',
        eventTextColor: '#fff',
        events: '/events.json'
    });

    $('#event-start').tooltip();
    $('#event-duration').tooltip();
}
$(document).ready(loadCalendar);
$(document).on('page:load', loadCalendar);
