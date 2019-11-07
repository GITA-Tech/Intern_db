<?php

if (isset($_POST['active']))
	{


$con; 
require_once dirname(__FILE__).'/DbConnect.php';
$db = new DbConnect();
$con = $db->connect();

$request=$_REQUEST;
$col =array(
    0   =>  'id',
    1   =>  'firstname',
    2   =>  'lastname',
    3   =>  'department',
	4	=>	'role', 
	5	=>	'personal_Email',
	6	=>	'PurdueGlobal_email',
	7	=>	'PGIPTech_email',
	8	=>	'Track',
	9	=>	'start_date',
	10	=>	'end_date'
);  //create column like table in database

// $_POST['active'] is the dropdown value on the index "dropActive"

if($_POST['active']==3)
	{
		$sql ="SELECT * FROM vw_personnel";
	}
else
	{
		$sql ="SELECT * FROM vw_personnel WHERE active = '".$_POST['active']."'";
	}
	
$query=mysqli_query($con,$sql);

$totalData=mysqli_num_rows($query);

$totalFilter=$totalData;

//Search
if($_POST['active']==3)
	{
		$sql ="SELECT * FROM vw_personnel WHERE 1=1";
	}
else
	{
		$sql ="SELECT * FROM vw_personnel WHERE 1=1 AND active = '".$_POST['active']."'";
	}
if(!empty($request['search']['value'])){
    $sql.=" AND (ID Like '".$request['search']['value']."%' ";
    $sql.=" OR firstname Like '".$request['search']['value']."%' ";
	$sql.=" OR lastname Like '".$request['search']['value']."%' ";
	$sql.=" OR department_name Like '".$request['search']['value']."%' ";
	$sql.=" OR role Like '".$request['search']['value']."%' ";
	$sql.=" OR personal_Email Like '".$request['search']['value']."%' ";
	$sql.=" OR PurdueGlobal_Email Like '".$request['search']['value']."%' ";
	$sql.=" OR PGIPTech_Email Like '".$request['search']['value']."%' ";
	$sql.=" OR Track Like '".$request['search']['value']."%' ";
	$sql.=" OR start_date Like '".$request['search']['value']."%' ";
	$sql.=" OR end_date Like '".$request['search']['value']."%' )";
}
$query=mysqli_query($con,$sql);
$totalData=mysqli_num_rows($query);

//Order
$sql.=" ORDER BY ".$col[$request['order'][0]['column']]."   ".$request['order'][0]['dir']."  LIMIT ".
    $request['start']."  ,".$request['length']."  ";

$query=mysqli_query($con,$sql);

$data=array();

while($row=mysqli_fetch_array($query)){
    $subdata=array();
    $subdata[]=$row[0]; //id
    $subdata[]=$row[1]; //first name
    $subdata[]=$row[2]; //last name
    $subdata[]=$row[3]; //department
	$subdata[]=$row[4]; //role
	$subdata[]=$row[5]; //personal email
	$subdata[]=$row[6]; //purdue global email
	$subdata[]=$row[7]; //pgip-tech email
	$subdata[]=$row[8]; //track
	$subdata[]=$row[9]; //track start date
	$subdata[]=$row[10]; //track end date
	//Button for edit
	$EditButton = '<button type="button" id="getEdit" class="btn btn-primary btn-xs" data-toggle="modal" data-target="#myModal" data-id="'.$row[0].'"><i class="glyphicon glyphicon-pencil">&nbsp;</i>Edit</button>';	//age           //create event on click in button edit in cell datatable for display modal dialog           $row[0] is id in table on database

	//Dynamic Active button based on person's current status
	if($row[11] == 1){
		$AcivateButton = '<button type="button" id="changeStatus" class="btn btn-danger btn-xs" onClick="ChangeStatus('.$row[0].',0)"><i class="glyphicon glyphicon-remove-circle">&nbsp;</i>Terminate</button>';
	}
	else{
		$AcivateButton = '<button type="button" id="changeStatus" class="btn btn-success btn-xs" onClick="ChangeStatus('.$row[0].',1)"><i class="glyphicon glyphicon-ok-circle">&nbsp;</i>Activate</button>';
	}

	//Addes buttons to table
	$subdata[]=$EditButton.$AcivateButton;
    $data[]=$subdata;
}

$json_data=array(
    "draw"              =>  intval($request['draw']),
    "recordsTotal"      =>  intval($totalData),
    "recordsFiltered"   =>  intval($totalFilter),
    "data"              =>  $data
);

echo json_encode($json_data);
	}

?>
