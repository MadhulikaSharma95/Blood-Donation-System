function send_to_backend(e){
    // console.log(e);
    id = e.id;
    // console.log(id);
    var val;
    if(id=='submit_btn'){
        val = String(document.getElementById("query").value);
    } else if(id=='q1'){
        val = "select blood_group, sum(units_available) as units_available from inventory i group by i.blood_group";
    } else if(id=='q2'){
        val = "select b_name as Blood_Bank_Name, contact_number as Contact_Number from bloodbank";
    } else if(id=='q3'){
        val = "select * from hospital";
    }
    // var val = String(document.getElementById("query").value);
    // console.log(val);
    $.ajax({url:'/api/search_query',
            type:"POST",
            data: {'query': val},
            success: function(result1){
                // console.log(typeof(result1));
                // console.log(result1);
                // console.log(result1['columns'].length);
                // var result = JSON.parse(result1);
                var result = result1;
                var v = "";
                var temp;
                if(result['len']==0){
                    v = "No results found";
                } else{
                    var i,j;
                    v+="<table id=\"result_table\" class=\"result_table\"><tr>";
                    for(i=0;i<result['columns'].length;i++){
                        v+= "<td>" + result['columns'][i] + "</td>";
                    }
                    v += "</tr>";
                    for(i=0;i<result['data'].length;i++){
                        temp = result['data'][i];
                        v += "<tr>";
                        for(j=0;j<temp.length;j++){
                            v+="<td>" + temp[j] + "</td>";
                        }
                        v+="</tr>";
                    }
                    v += "</table>";
                    // v = "some results found";
                    // console.log(v);
                }
                document.getElementById("result_div").innerHTML = v;
            },
            error: function(errorMessage){
                console.log(errorMessage.responseText);
                // alert("Error in API Call");
            }
    });
}

function reset_outcome(e){
    document.getElementById("query").value = "";
    document.getElementById("result_div").innerHTML = "";
}