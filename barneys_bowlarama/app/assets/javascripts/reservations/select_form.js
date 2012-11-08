var office_hour_list;
var current_office_hour;
var holidays;

$(document).ready(function(){

  office_hour_list = eval($("#office_hour_list").val());
  holidays = eval($("#holiday_list").val());

  init_select_form();

});


function get_current_office_hour(date) {
  return office_hour_list[date.getDay()];
}


function init_select_form() {

  $.datepicker.regional['de'] = {
    closeText: 'schließen',
    prevText: '&#x3c;zurück',
    nextText: 'Vor&#x3e;',
    currentText: 'heute',
    monthNames: ['Januar','Februar','März','April','Mai','Juni',
    'Juli','August','September','Oktober','November','Dezember'],
    monthNamesShort: ['Jan','Feb','Mär','Apr','Mai','Jun',
    'Jul','Aug','Sep','Okt','Nov','Dez'],
    dayNames: ['Sonntag','Montag','Dienstag','Mittwoch','Donnerstag','Freitag','Samstag'],
    dayNamesShort: ['So','Mo','Di','Mi','Do','Fr','Sa'],
    dayNamesMin: ['So','Mo','Di','Mi','Do','Fr','Sa'],
    weekHeader: 'Wo',
    dateFormat: 'dd.mm.yy',
    firstDay: 1,
    isRTL: false,
    showMonthAfterYear: false,
    yearSuffix: ''};

  $.datepicker.setDefaults($.datepicker.regional['de']);

  var start_time = new Date($("#current_start_time").val() * 1000 );
  var start_time_2 = new Date($("#current_start_time").val() * 1000);
  start_time_2.setHours(start_time_2.getHours() + 1);

  current_office_hour = get_current_office_hour(start_time);

  $("#date").datepicker( $.datepicker.regional[ "de" ] );
  $("#date").datepicker( "option", "minDate", start_time);
  $("#date").datepicker( "option", "onSelect", function(dateText, inst) { 
    tmp = $(this).datepicker('getDate');
    $("#date_field").val(tmp);
    current_office_hour = get_current_office_hour(tmp);
    update_timepicker_range();
  });
  $("#date").datepicker( "option", "beforeShowDay", is_available);

  $('#start_time').timepicker({'timeFormat': 'H:i', 'minTime': start_time, 'maxTime': current_office_hour[1]});
  $('#end_time').timepicker({'timeFormat': 'H:i', 'minTime': start_time_2, 'maxTime': current_office_hour[2]});

  $("#date").datepicker('setDate', start_time);
  $('#start_time').timepicker('setTime', start_time);
  $('#end_time').timepicker('setTime', start_time_2);

  $('#start_time').bind('changeTime', update_timepicker);
};


function is_available(date) {
  dmy = date.getDate() + "-" + (date.getMonth()+1) + "-" + date.getFullYear();
  if ($.inArray(dmy, holidays) < 0) {
    return [true,"","offen"];
  } else {
    return [false,"", holidays[$.inArray(dmy, holidays) + 1]];
  }
}


function update_timepicker_range() {
  today = new Date();
  today.setHours(0);
  today.setMinutes(0);
  today.setSeconds(0);
  today.setMilliseconds(0);

  if($("#date").datepicker('getDate') - today == 0) {
    var start_time = new Date($("#current_start_time").val() * 1000 );
    var start_time_2 = new Date($("#current_start_time").val() * 1000);
    start_time_2.setHours(start_time_2.getHours() + 1);
    $('#start_time').timepicker('option', {'minTime': start_time, 'maxTime': current_office_hour[1]});
    $('#end_time').timepicker('option', {'minTime': start_time_2, 'maxTime': current_office_hour[2]});
  } else {
    $('#start_time').timepicker('option', {'minTime': current_office_hour[0], 'maxTime': current_office_hour[1]});
    $('#end_time').timepicker('option', {'minTime': current_office_hour[0], 'maxTime': current_office_hour[2]});
  }

  $('#start_time').val('');
  $('#end_time').val('');
}



function update_timepicker() {

  var start_time = $('#start_time').timepicker('getTime');
  start_time.setHours(start_time.getHours() + 1);

  if($('#end_time').is('[readonly]')) {
    $('#end_time').timepicker({'timeFormat': 'H:i', 'minTime': start_time, 'maxTime': current_office_hour[2]});
    $('#end_time').removeAttr('readonly');
  }

  var end_time = $('#end_time').timepicker('getTime');

  if(start_time >= end_time) {
    $('#end_time').timepicker('setTime', start_time);

    if(formatAMPM(start_time) == current_office_hour[2]) {
      $('#end_time').timepicker('remove');
      $('#end_time').attr('readonly', true);
    } 

  }

};


function formatAMPM(date) {
  var hours = date.getHours();
  var minutes = date.getMinutes();
  var ampm = hours >= 12 ? 'pm' : 'am';
  var hours = hours % 12;
  hours = hours ? hours : 12; // the hour '0' should be '12'
  minutes = minutes < 10 ? '0'+minutes : minutes;
  strTime = hours + ':' + minutes + ampm;
  return strTime;
}


