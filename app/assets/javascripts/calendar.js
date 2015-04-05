function _createJSONeventFrom(event) {
    return {
        'event': {
            'start(1i)': event.start.format('YYYY'),
            'start(2i)': event.start.format('MM'),
            'start(3i)': event.start.format('DD'),
            'start(4i)': event.start.format('HH'),
            'start(5i)': event.start.format('mm'),
            'end(1i)': event.end.format('YYYY'),
            'end(2i)': event.end.format('MM'),
            'end(3i)': event.end.format('DD'),
            'end(4i)': event.end.format('HH'),
            'end(5i)': event.end.format('mm')
        }
    };
}

function _updateEvent(event) {
    $.ajax({
        url: '/events/' + event.id + '.json',
        contentType: 'application/json',
        type: 'PUT',
        data: JSON.stringify(_createJSONeventFrom(event))
    });
}

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
        events: '/events.json',

        editable: true,
        eventDrop: function(event, delta, revertFunc, jsEvent, ui, view) {
            _updateEvent(event);
        },
        eventResize: function(event, delts, revertFunc, jsEvent, ui, view) {
            _updateEvent(event);
        }
    });

    $('#event-start').tooltip();
    $('#event-duration').tooltip();
}
$(document).ready(loadCalendar);
$(document).on('page:load', loadCalendar);
