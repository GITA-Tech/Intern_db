<?php
/**
 for display full info. and edit data
 */
// start again

//Setup Connection
require ('Functions.php');
$con; 
require_once dirname(__FILE__).'/DbConnect.php';
$db = new DbConnect();
$con = $db->connect();


if(isset($_REQUEST['id'])){
    $id=intval($_REQUEST['id']);
    if($id=="0")
    {
        $per_id="New Member";
        $per_firstname="";
        $per_lastname="";
        $per_department="";
        $per_role="";
        $per_personalemail="";
        $per_purdueglobalemail="";
        $per_pgiptechemail="";
        $per_track="";
        $per_startdate="";
        $per_enddate="";

        $form_Type = "Add New Member";
    }
    else
    {
        $sql="select * from vw_personnel WHERE ID=$id";
        $run_sql=mysqli_query($con,$sql);
        while($row=mysqli_fetch_array($run_sql)){
            $per_id=$row[0];
            $per_firstname=$row[1];
		    $per_lastname=$row[2];
		    $per_department=$row[3];
		    $per_role=$row[4];
		    $per_personalemail=$row[5];
		    $per_purdueglobalemail=$row[6];
		    $per_pgiptechemail=$row[7];
		    $per_track=$row[8];
		    $per_startdate=$row[9];
		    $per_enddate=$row[10];
        }

        $form_Type = "Edit: ".$per_firstname." ".$per_lastname;
    }//end while
    //var_dump($run_sql);
    ?>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>

    <!--Builds Form Fields-->
    <form class="form-horizontal" method="post">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" onclick="close_click()">&times;</button>
                <h4 class="modal-title"><?php echo $form_Type ?></h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="box-body">
                        <div class="form-group">
                            <label class="col-sm-4 control-label" for="txtid">ID</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="txtid" name="txtid" value="<?php echo $per_id;?>" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label" for="txtfirstname">First Name</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="txtfirstname" name="txtfirstname" value="<?php echo $per_firstname;?>">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label" for="txtlastname">Last Name</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="txtlastname" name="txtlastname" value="<?php echo $per_lastname;?>">
                            </div>
                        </div>
						<div class="form-group">
                            <label class="col-sm-4 control-label" for="txtdepartment">Department</label>
                            <div class="col-sm-6">                                
								<select class = "form-control" id="txtdepartment" name="txtdepartment">
									<?php echo DepartmentList($per_department); ?>
								</select>
                            </div>
                        </div>
						<div class="form-group">
                            <label class="col-sm-4 control-label" for="txtrole">Role</label>
                            <div class="col-sm-6">                                
                                <select class = "form-control" id="txtrole" name="txtrole">
									<?php echo RoleList($per_role); ?>
								</select>
                            </div>
                        </div>
						<div class="form-group">
                            <label class="col-sm-4 control-label" for="txtpersonalEmail">Personal Email</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="txtpersonalEmail" name="txtpersonalEmail" value="<?php echo $per_personalemail;?>">
                            </div>
                        </div>
						<div class="form-group">
                            <label class="col-sm-4 control-label" for="txtPurdueGlobalEmail">Purdue Global Email</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="txtPurdueGlobalEmail" name="txtPurdueGlobalEmail" value="<?php echo $per_purdueglobalemail;?>">
                            </div>
                        </div>
						<div class="form-group">
                            <label class="col-sm-4 control-label" for="txtPGIPEmail">PGIP-Tech Email</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="txtPGIPEmail" name="txtPGIPEmail" value="<?php echo $per_pgiptechemail;?>">
                            </div>
                        </div>
						<div class="form-group">
                            <label class="col-sm-4 control-label" for="txttrack">Track</label>
                            <div class="col-sm-6">
                                <select class="form-control" id="txttrack" name="txttrack" onchange="OnSelectionChange(this.value)">
									<?php echo TrackList($per_track); ?>
								</select>
                            </div>
                        </div>
						<div class="form-group">
                            <label class="col-sm-4 control-label" for="txtstartDate">Start Date</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="txtstartDate" name="txtstartDate" value="<?php echo $per_startdate;?>" readonly>
                            </div>
                        </div>
						<div class="form-group">
                            <label class="col-sm-4 control-label" for="txtendDate">End Date</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="txtendDate" name="txtendDate" value="<?php echo $per_enddate;?>" readonly>
                            </div>
                        </div>
                        <div class="form-group">                            
                            <div class="col-sm-6">                            
                                <button type="button" class="form-control" id="btnsubmit" name="btnsubmit" onclick="submit_click()">Submit</button>
                            </div>
                        </div>	

                    </div>
                </form>
            </div>
        </div>
    </form>

<script type="text/javascript" >
function OnSelectionChange(strvalue)
{
    //Called when track is changed. Fetch start and end dates.
    $.ajax({
    url: 'Functions.php',
    type: 'post',
    data: { "getStartDate": strvalue},
    success: function(response) 
    { 
        document.getElementById("txtstartDate").value = response; 
    }
    });

    $.ajax({
    url: 'Functions.php',
    type: 'post',
    data: { "getEndDate": strvalue},
    success: function(response) 
    { 
        document.getElementById("txtendDate").value = response; 
    }
    });
}
</script>

<script>type="text/javascript"
//either adds or edits a user based on if an ID was passed in.
function submit_click(){    
    if(document.getElementById("txtid").value == "New Member")
    {
        var personnelID=0;
    }
    else
    {
        var personnelID = document.getElementById("txtid").value;
    }

    if(personnelID==0)
        {
            var message = "Are you sure you want to add this member?";
            var alertMessage = "Member add successful.";
        } 
        else
        {
            var message = "Are you sure you want to edit this member?";
            var alertMessage = "Member update successful.";
        }
    
    if(confirm(message))
    {

    var firstname = document.getElementById("txtfirstname").value;
    var lastname = document.getElementById("txtlastname").value;
    var department = document.getElementById("txtdepartment").value;
    var role = document.getElementById("txtrole").value;
    var track = document.getElementById("txttrack").value;
    var personalEmail = document.getElementById("txtpersonalEmail").value;
    var purdueglobalEmail = document.getElementById("txtPurdueGlobalEmail").value;
    var pgiptechEmail = document.getElementById("txtPGIPEmail").value;

    if(firstname === "")
    {
        alert("You must enter a first name.");
        return false;
    }
    else if(lastname === "")
    {
        alert("You must enter a last name.");
        return false;
    }
    else{}


    //Calls Function PHP InsertUpdatePersonnel function
    $.ajax({
    url: 'Functions.php',
    type: 'post',
    data: { "InsertUpdate": 1,
            "personnelID": personnelID,
            "firstname": firstname,
            "lastname": lastname,
            "department": department,
            "role": role,
            "track":track,
            "personalEmail":personalEmail,
            "purdueglobalEmail": purdueglobalEmail,
            "pgiptechEmail": pgiptechEmail    
            },


    success: function(response) 
    { 
        
        if(response == 1){
            alert(alertMessage);
        }
        else{
            alert("An error as occured.");
        }
        
    }
    });    
    }
    else
    {
        return false;
    }    

}



</script>

<script>
    function close_click()
{
   //Reload Page 
   location.reload();

}
    </script>





<?php
}//end if ?>





