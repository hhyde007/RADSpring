    $(document).ready(function() {
        $("button[data-btn='pilot-refresh']").on('click', function(e){
            e.preventDefault();
            console.log('Clicked refresh button: ', e);
            console.log(this);
            console.log('pilotId = ', $(this).attr('data-pilotId'));
            var form=document.createElement('form');
            document.body.appendChild(form);
            var input=document.createElement('input');
            input.type='hidden';
            input.name='pilotId';
            input.value=$(this).attr('data-pilotId');
            form.appendChild(input);
            form.method='post';
            form.action='/Pilot/Edit';
            console.log('form = ', form);
            console.log('form.action = ', form.action);
            console.log('form.method = ', form.method);
            form.submit();
          });
 	   
        $("button[data-btn='aircraftTypeId-edit']").on('click', function(e){
            e.preventDefault();
            console.log('Clicked aircraftType-edit button: ', e);
            console.log(this);
            console.log('aircraftTypeId = ', $(this).attr('data-aircraftTypeId'));
            var form=document.createElement('form');
            document.body.appendChild(form);
            var input=document.createElement('input');
            input.type='hidden';
            input.name='aircraftTypeId';
            input.value=$(this).attr('data-aircraftTypeId');
            form.appendChild(input);
            form.method='post';
            form.action='/AircraftType/Edit';
            console.log('form = ', form);
            console.log('form.action = ', form.action);
            console.log('form.method = ', form.method);
            form.submit();
          });
        $("button[data-btn='pilotCertification-delete']").on('click', function(e){
            e.preventDefault();
            var formDelete=document.createElement('form');
            document.body.appendChild(formDelete);
            var input=document.createElement('input');
            input.type='hidden';
            input.name='pilotId';
            input.value=$(this).attr('data-pilotId');
            var input2=document.createElement('input');
            input2.type='hidden';
            input2.name='aircraftTypeId';
            input2.value=$(this).attr('data-aircraftTypeId');
            formDelete.appendChild(input);
            formDelete.appendChild(input2);
            formDelete.method='post';
            formDelete.action='/Pilot/DeletePilotCertification';
            formDelete.submit();
          });

        $("button[data-btn='pilotRareThing-delete']").on('click', function(e){
            e.preventDefault();
            var formDelete=document.createElement('form');
            document.body.appendChild(formDelete);
            var input=document.createElement('input');
            input.type='hidden';
            input.name='pilotId';
            input.value=$(this).attr('data-pilotId');
            formDelete.appendChild(input);
            formDelete.method='post';
            formDelete.action='/Pilot/DeletePilotRareThing';
            formDelete.submit();
          });

 	   
        $("button[data-btn='flightId-edit']").on('click', function(e) {
     	   e.preventDefault();
            console.log('Clicked flight-edit button: ', e);
            console.log(this);
            console.log('flightId = ', $(this).attr('data-flightId'));
            var form=document.createElement('form');
            document.body.appendChild(form);
            var input=document.createElement('input');
            input.type='hidden';
            input.name='flightId';
            input.value=$(this).attr('data-flightId');
            form.appendChild(input);
            form.method='post';
            form.action='/Flight/Edit';
            console.log('form = ', form);
            console.log('form.action = ', form.action);
            console.log('form.method = ', form.method);
            form.submit();
          });
        
        $("button[data-btn='flightCrewMember-delete']").on('click', function(e){
          e.preventDefault();
          console.log('Clicked flight crew member delete button: ', e);
          console.log(this);
          console.log('data-pilotId = ', $(this).attr('data-pilotId'));
          console.log('data-flightId = ', $(this).attr('data-flightId'));
          var formDelete=document.createElement('form');
          document.body.appendChild(formDelete);
          var input=document.createElement('input');
          input.type='hidden';
          input.name='pilotId';
          input.value=$(this).attr('data-pilotId');
          var input2=document.createElement('input');
          input2.type='hidden';
          input2.name='flightId';
          input2.value=$(this).attr('data-flightId');
          formDelete.appendChild(input);
          formDelete.appendChild(input2);
          formDelete.method='post';
          formDelete.action='/Pilot/DeleteFlightCrewMember';
          console.log('formDelete = ', formDelete);
          console.log('formDelete.action = ', formDelete.action);
          console.log('formDelete.method = ', formDelete.method);
          formDelete.submit();
        });

 	   
 	   var spacers = document.getElementsByClassName('spacer');
 	   var numSpacers = spacers.length;
 	   console.log('numSpacers: ', numSpacers);
 	   console.log('spacers: ', spacers);
 	   document.getElementsByClassName('spacer')[0].style.visibility = 'hidden';
 	   document.getElementsByClassName('spacer')[1].style.visibility = 'hidden';
 	   document.getElementsByClassName('spacer')[2].style.visibility = 'hidden';
 	   document.getElementsByClassName('spacer')[3].style.visibility = 'hidden';
    });
