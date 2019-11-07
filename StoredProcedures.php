<?php
	
	class StoredProcedures{

		private $con; 

		function __construct(){

			require_once dirname(__FILE__).'/DbConnect.php';

			$db = new DbConnect();

			$this->con = $db->connect();

		}
	
		public function getDepartments()
		{
			$rows = array();
			$Sql = 'CALL call_departments()';			
			$stmt = $this->con->prepare($Sql);
			$stmt->execute();
			$result = $stmt->get_result();		
			
			while ($row = $result->fetch_assoc())
			{
				$row_array["department_ID"] = $row["department_ID"];
				$row_array["department_name"] = $row["department_name"];
				array_push($rows,$row_array);
			}			
			return $rows;			
		}
		
		public function getRoles()
		{
			$rows = array();
			$Sql = 'CALL sp_Call_Roles()';
			//$Sql = 'SELECT Role_ID, Role From roles;';
			$stmt = $this->con->prepare($Sql);
			$stmt->execute();
			$result = $stmt->get_result();		
			
			while ($row = $result->fetch_assoc())
			{
				$row_array["Role_ID"] = $row["Role_ID"];
				$row_array["Role"] = $row["Role"];
				array_push($rows,$row_array);
			}				
			return $rows;			
		}
		
		public function getTracks()
		{
			$rows = array();
			$Sql = 'CALL sp_call_tracks()';
			//$Sql = 'SELECT track_ID, track, start_date, end_date From tracks;';			
			$stmt = $this->con->prepare($Sql);
			$stmt->execute();
			$result = $stmt->get_result();		
			
			while ($row = $result->fetch_assoc())
			{
				$row_array["track_ID"] = $row["track_ID"];
				$row_array["track"] = $row["track"];
				$row_array["start_date"] = $row["start_date"];
				$row_array["end_date"] = $row["end_date"];				
				array_push($rows,$row_array);
			}			
			return $rows;			
		}
		
		public function getStatus()
		{
			$rows = array();
			$Sql = 'CALL sp_call_status()';			
			$stmt = $this->con->prepare($Sql);
			$stmt->execute();
			$result = $stmt->get_result();		
			
			while ($row = $result->fetch_assoc())
			{
				$row_array["status_ID"] = $row["status_ID"];
				$row_array["status"] = $row["status"];
				array_push($rows,$row_array);
			}			
			return $rows;			
		}	
		
		public function insert_update_personnel($personnelID, $department_ID, $role_ID, $track_ID, $firstname, $lastname, $personal_Email, $purdueglobal_Email, $pgiptech_Email)
		{
			$Sql = 'CALL sp_Insert_Update_Personnel(?,?,?,?,?,?,?,?,?)';
			$stmt = $this->con->prepare($Sql);		
			$stmt->bind_param("issiiisss",$personnelID, $firstname, $lastname, $role_ID, $department_ID, $track_ID, $personal_Email, $purdueglobal_Email, $pgiptech_Email);
			if($stmt->execute()){
					return 1; 
				}else{
					return 2; 
				}
		}


		public function update_personnel_status($personnelID, $active)
		{
			$Sql = 'CALL sp_Update_PersonnelStatus(?,?)';
			$stmt = $this->con->prepare($Sql);		
			$stmt->bind_param("ii",$personnelID, $active);
			if($stmt->execute()){
					return 1; 
				}else{
					return 2; 
				}
		}
		
		
		
	}
?>