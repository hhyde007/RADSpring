    $(document).ready(function() {
    	
        $("button[data-btn='aircraft-refresh']").on('click', function(e){
            e.preventDefault();
            console.log('Clicked refresh button: ', e);
            console.log(this);
            console.log('aircraftId = ', $(this).attr('data-aircraftId'));
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
    	
          $("button[data-btn='aircraftTypeId-edit']").on('click', function(e){
              e.preventDefault();
              console.log('Clicked AircraftType edit button: ', e);
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
});
