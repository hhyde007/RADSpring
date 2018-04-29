
$(document).ready(function(){
  
        $("button[data-btn='aircraftType-refresh']").on('click', function(e){
            e.preventDefault();
            console.log('Clicked refresh button: ', e);
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
        $("button[data-btn='pilotId-edit']").on('click', function(e){
            e.preventDefault();
//            console.log('Clicked pilot edit button: ', e);
//            console.log(this);
//            console.log('PilotId = ', $(this).attr('data-pilotId'));
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
        $("button[data-btn='pilotCertification-delete']").on('click', function(e){
          e.preventDefault();
          console.log('Clicked pilot certification delete button: ', e);
          console.log(this);
          console.log('data-pilotId = ', $(this).attr('data-pilotId'));
          console.log('data-aircraftTypeId = ', $(this).attr('data-aircraftTypeId'));
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
          formDelete.action='/AircraftType/DeletePilotCertification';
          console.log('formDelete = ', formDelete);
          console.log('formDelete.action = ', formDelete.action);
          console.log('formDelete.method = ', formDelete.method);
          formDelete.submit();
        });
        $("button[data-btn='aircraftId-edit']").on('click', function(e){
            e.preventDefault();
            console.log('Clicked aircraft edit button: ', e);
            console.log(this);
            console.log('PilotId = ', $(this).attr('data-aircraftId'));
            var form=document.createElement('form');
            document.body.appendChild(form);
            var input=document.createElement('input');
            input.type='hidden';
            input.name='aircraftId';
            input.value=$(this).attr('data-aircraftId');
            form.appendChild(input);
            form.method='post';
            form.action='/Aircraft/Edit';
            console.log('form = ', form);
            console.log('form.action = ', form.action);
            console.log('form.method = ', form.method);
            form.submit();
          });
          $("button[data-btn='aircraft-delete']").on('click', function(e){
            e.preventDefault();
            console.log('Clicked aircraft delete button: ', e);
            console.log(this);
            console.log('data-aircraftId = ', $(this).attr('data-aircraftId'));
            var formDelete=document.createElement('form');
            document.body.appendChild(formDelete);
            var aircraftId=document.createElement('input');
            aircraftId.type='hidden';
            aircraftId.name='aircraftId';
            aircraftId.value=$(this).attr('data-aircraftId');
            formDelete.appendChild(aircraftId);
            var aircraftTypeId=document.createElement('input');
            aircraftTypeId.type='hidden';
            aircraftTypeId.name='aircraftTypeId';
            aircraftTypeId.value=$(this).attr('data-aircraftTypeId');
            formDelete.appendChild(aircraftTypeId);
            formDelete.method='post';
            formDelete.action='/AircraftType/DeleteAircraft';
            console.log('formDelete = ', formDelete);
            console.log('formDelete.action = ', formDelete.action);
            console.log('formDelete.method = ', formDelete.method);
            formDelete.submit();
          });
          
          var spacers = document.getElementsByClassName('spacer');
          var numSpacers = spacers.length;
          console.log('numSpacers: ', numSpacers);
          console.log('typeof numSpacers: ', typeof numSpacers);
          console.log('spacers: ', spacers);
          for (var i=0; i<numSpacers; i++){
          	console.log('spacers[i] = ', spacers[i]);
            	spacers[i].style.visibility = "hidden";
            }

});

