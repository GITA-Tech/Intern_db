<?php

	require ('StoredProcedures.php');

	global $departmentDrop;
	global $roleDrop;
	global $trackDrop;
	global $starttrack;
	global $endtrack;
	
	function StatusList()
	{	
		foreach($Status as $S)
		{
			$statusDrop .= "<option value=".$S["status_ID"].">" .$S["status"]. "</option>";
		}
	}
	
	function DepartmentList($SelectedValue = null)
	{
		$SP = new StoredProcedures();
		$Departments = $SP->getDepartments();
		$departmentDrop = "<option value=0> </option>";

		foreach($Departments as $Department)
		{
			if($SelectedValue === $Department["department_name"])
				{
					$departmentDrop .= "<option value=".$Department["department_ID"]." selected='selected'>" .$Department["department_name"]. "</option>";
				}
				else
				{
					$departmentDrop .= "<option value=".$Department["department_ID"].">" .$Department["department_name"]. "</option>";
				}
		}
		
		return $departmentDrop;
	}
	
	function RoleList($SelectedValue = null)
	{
		$SP = new StoredProcedures();
		$Roles = $SP->getRoles();
		$roleDrop = "<option value=0> </option>";
		foreach($Roles as $Role)
		{
			if($SelectedValue === $Role["Role"])
			{
				$roleDrop .= "<option value=".$Role["Role_ID"]." selected='selected'>" .$Role["Role"]. "</option>";
			}
			else
			{
				$roleDrop .= "<option value=".$Role["Role_ID"].">" .$Role["Role"]. "</option>";
			}
			
		}
		return $roleDrop;
		
	}
	function TrackList($SelectedValue = null)
	{
		$SP = new StoredProcedures();
		$Tracks = $SP->getTracks();
		$trackDrop = "<option value=0></option>";
		foreach($Tracks as $Track)
		{
			if($SelectedValue === $Track["track"])
			{
				$trackDrop .= "<option value=".$Track["track_ID"]." selected='selected'>" .$Track["track"]. "</option>";
			}
			else
			{
				$trackDrop .= "<option value=".$Track["track_ID"].">" .$Track["track"]. "</option>";
			}
		}		
		return $trackDrop;			
	}
	
	function TrackStart($SelectedValue = null)
	{
		$SP = new StoredProcedures();
		$Tracks = $SP->getTracks();
		$starttrack ="";

		foreach($Tracks as $Track)
		{	
			if($SelectedValue == $Track["track_ID"])
			{				
				$starttrack = $Track["start_date"];
			}
		}

		return $starttrack;

	}
	
	function TrackEnd($SelectedValue = null)
	{

		$SP = new StoredProcedures();
		$Tracks = $SP->getTracks();
		$endtrack = "";
		foreach($Tracks as $Track)
		{			
			if($SelectedValue == $Track["track_ID"])
			{				
				$endtrack = $Track["end_date"];
			}
		}
		return $endtrack;
	}

	function InsertUpdatePersonnel($personnelID, $department_ID, $role_ID, $track_ID, $firstname, $lastname, $personal_Email, $purdueglobal_Email, $pgiptech_Email)
	{

		$SP = new StoredProcedures();
		$result = $SP->insert_update_personnel($personnelID, $department_ID, $role_ID, $track_ID, $firstname, $lastname, $personal_Email, $purdueglobal_Email, $pgiptech_Email);

		return $result;
	}

	function changeStatus($personnelID, $Active){
		$SP = new StoredProcedures();
		$result = $SP->update_personnel_status($personnelID, $Active);
		return $result;
	}


	

    if (isset($_POST['getStartDate'])) {
        echo TrackStart($_POST['getStartDate']);
	}
	
	if (isset($_POST['getEndDate'])) {
        echo TrackEnd($_POST['getEndDate']);
    }

	if (isset($_POST['InsertUpdate']))
	{
		echo InsertUpdatePersonnel(
			$_POST['personnelID'],
			$_POST['department'],
			$_POST['role'],
			$_POST['track'],
			$_POST['firstname'],
			$_POST['lastname'],
			$_POST['personalEmail'],
			$_POST['purdueglobalEmail'],
			$_POST['pgiptechEmail']
		);
	}

	if(isset($_POST["StatusChange"]))
	{    	
    	echo changeStatus($_POST["PersonnelID"], $_POST["Active"]);
	}



?>