jQuery(function($){
    var date = new Date();
    var m = date.getMonth(), d = date.getDate(), y = date.getFullYear();

    var dayss = $('#disableDays').val();
    var dA = dayss.split(", ");

    var disabledDays = [dA[0] ];

    for (var i=1; i<dA.length; i++ ) {
        disabledDays.push(dA[i]);
    }

    var z1min = $("#openTime").val();
    var z1max = $("#closeTime").val();

    var timeMin = "01:00am";
    var timeMax = $('#maxPlayTime').val();

    var z2min = $("#openTime").val();
    var z2max = $("#closeTime").val();


    function disableAllTheseDays(date) {
        var m = date.getMonth(), d = date.getDate(), y = date.getFullYear();
        for (i = 0; i < disabledDays.length; i++) {
            if($.inArray((m+1) + '-' + d + '-' + y,disabledDays) != -1) {
                return [false];
            }
        }
        return [true];
    }


    $.datepicker.regional['de'] = {clearText: 'löschen', clearStatus: 'aktuelles Datum löschen',
        closeText: 'schließen', closeStatus: 'ohne Änderungen schließen',
        prevText: '&#x3c;zurück', prevStatus: 'letzten Monat zeigen',
        nextText: 'Vor&#x3e;', nextStatus: 'nächsten Monat zeigen',
        currentText: 'heute', currentStatus: '',
        monthNames: ['Januar','Februar','März','April','Mai','Juni',
        'Juli','August','September','Oktober','November','Dezember'],
        monthNamesShort: ['Jan','Feb','Mär','Apr','Mai','Jun',
        'Jul','Aug','Sep','Okt','Nov','Dez'],
        monthStatus: 'anderen Monat anzeigen', yearStatus: 'anderes Jahr anzeigen',
        weekHeader: 'Wo', weekStatus: 'Woche des Monats',
        dayNames: ['Sonntag','Montag','Dienstag','Mittwoch','Donnerstag','Freitag','Samstag'],
        dayNamesShort: ['So','Mo','Di','Mi','Do','Fr','Sa'],
        dayNamesMin: ['So','Mo','Di','Mi','Do','Fr','Sa'],
        dayStatus: 'Setze DD als ersten Wochentag', dateStatus: 'Wähle D, M d',
        dateFormat: 'dd.mm.yy', firstDay: 1,
        initStatus: 'Wähle ein Datum', isRTL: false};
    $.datepicker.setDefaults($.datepicker.regional['de']);

    $( "#datum1").datepicker({minDate: new Date(y, m, d), beforeShowDay: disableAllTheseDays,onSelect: function(dateText, inst) { 
      var dateAsString = dateText; //the first parameter of this function
      var dateAsObject = $(this).datepicker( 'getDate' ); //the getDate method
      $("#date_field").val(dateAsObject);
   }
});



    $('#zeit1').timepicker({ 'timeFormat': 'H:i','minTime': z1min, 'maxTime': z1max});
    $('#zeit3').timepicker({ 'timeFormat': 'H:i','minTime': timeMin, 'maxTime': timeMax});

    $('#zeit1').change(function(){

        var z1 = $("#zeit1").val();

      /*  if(z1.charAt(3)=="3") {
            var z1Slice = "";
            if(z1.charAt(0) == '0' ){
                z1Slice = z1.slice(1,2);
            }
            else {
                z1Slice = z1.slice(0,2);
            }

        var z1Zahl = parseInt(z1Slice); 
        z1Zahl = z1Zahl + 1;
        z1Slice = z1Zahl.toString();
        z1 = z1Slice + ":00";

        }
        else {
            z1 = z1.replace(':00', ':30');
        } 
        */

        var z1Minute =":00";
        if(z1.charAt(3)=="3") { 
            z1Minute =":30";
        }
        if(z1.charAt(0) == '0' ){
                z1Slice = z1.slice(1,2);
            }
        else {
                z1Slice = z1.slice(0,2);
            }
        var z1Zahl = parseInt(z1Slice); 
        z1Zahl = z1Zahl + 1;
        z1Slice = z1Zahl.toString();

        z2min = z1Slice + z1Minute;

        $('#zeit2').timepicker({ 'timeFormat': 'H:i','minTime': z2min, 'maxTime': z2max});
        $("#zeit2").removeAttr("disabled");
        $('#zeit2').val(z2min);

    });

    $("#zeit1").click(function() {
        $('#zeit2').remove();
        $('#zeitText2').append('<input id="zeit2" disabled="disabled" type="text" name="search[to]"/>');
        $('#zeit2').attr('disabled', 'disabled');
    });
});

