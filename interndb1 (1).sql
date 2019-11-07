-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Oct 05, 2019 at 02:21 AM
-- Server version: 5.7.24
-- PHP Version: 7.2.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `interndb1`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `call_departments`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `call_departments` ()  BEGIN
	SELECT department_ID, department_name
	FROM department;
END$$

DROP PROCEDURE IF EXISTS `select_dept`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `select_dept` ()  BEGIN
	SELECT department_ID, department_name
	FROM department;
END$$

DROP PROCEDURE IF EXISTS `sp_call_positions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_call_positions` ()  BEGIN
	SELECT position_ID, position
	FROM positions;
END$$

DROP PROCEDURE IF EXISTS `sp_Call_Roles`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Call_Roles` ()  BEGIN
SELECT * From roles;
END$$

DROP PROCEDURE IF EXISTS `sp_call_status`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_call_status` ()  Select 
	status_ID, status
FROM status$$

DROP PROCEDURE IF EXISTS `sp_call_tracks`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_call_tracks` ()  BEGIN
	SELECT * FROM tracks;
END$$

DROP PROCEDURE IF EXISTS `sp_InsertIntern`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_InsertIntern` (IN `first_name` VARCHAR(30), IN `last_name` VARCHAR(30), IN `Email1` VARCHAR(100), IN `Email2` VARCHAR(100), IN `Email3` VARCHAR(100), IN `Phone1` VARCHAR(20), IN `Phone2` VARCHAR(20), IN `status_ID` SMALLINT, IN `department_ID` SMALLINT, IN `teams_ID` INT(11), IN `position_ID` SMALLINT, IN `track_ID` SMALLINT, IN `track2_ID` SMALLINT, IN `start_date` DATE, IN `end_date` DATE, IN `Orientation1_ck` TINYINT(1), IN `Orientation2_ck` TINYINT(1), IN `Orientation3_ck` TINYINT(1), IN `TimeClock_Wizard_ck` TINYINT(1), IN `Freedcamp_ck` TINYINT(1), IN `Leadership_Interest` TINYINT(1), IN `Chime_ck` TINYINT(1), IN `Console_ck` TINYINT(1), IN `ESET_ck` TINYINT(1), IN `comments` TEXT, OUT `Dupe` INT)  this_proc:	BEGIN
	declare intern_ID int;
	
	declare Seq_No int;
	declare TStartDate date;
	declare TEndDate date;
	
	set TStartDate = (select start_date from pgip_interndb.tracks where academic_track_ID = track_ID);
	if ifnull(track2_ID,0) = 0 then
		set TEndDate = (select end_date from pgip_interndb.tracks where academic_track_ID = track_ID);
	else
		set TEndDate = (select end_date from pgip_interndb.tracks where academic_track_ID = track2_ID);
	end if;
	
	if exists(select intern_ID from pgip_interndb
				where name_last = last_name and
				      name_first = first_name and
					 personal_email in (select email from pgip_interndb.intern_email)) then
		set Dupe = 1;
		LEAVE this_proc;
	end if;
	if TStartDate <> start_date then
		set TStartDate = TrackStartDate;
	end if;
	
	if TEndDate <> end_date then
		set TEndDate = TrackEndDate;
	end if;
	
	insert into pgip_interndb.intern (
		first_name, last_name, email, phone, status_id, department_ID, teams_ID, position_ID, track_ID, track2_ID, start_date, end_date,
		Orientation1_ck, Orientation2_ck, Orientation3_ck, TimeClock_Wizard_ck, Leadership_Interest, Chime_ck, Console_ck, ESET_ck, comments)
		values (first_name, last_name, Email1, Phone1, status_ID, department_ID, teams_ID, position_ID, track_ID, track2_ID,
				TStartDate, TEndDate, Orientation1_ck, Orientation2_ck, Orientation3_ck, TimeClock_Wizard_ck, Freedcamp_ck,
				Leadership_Interest, Chime_ck, Console_ck, ESET_ck, comments);
	set intern_ID = (select intern_ID
					from pgip_interndb.intern
					where first_name = first_name and
						  last_name = last_name and
						  email in (Email1, Email2, Email3)
						  );
	insert into pgip_interndb.intern_email(email, primary_ck, intern_ID)
		values(Email1, 1, intern_ID);
	
	if ifnull(Email2, '') <> '' then
		insert into interndb.intern_email(email, primary_ck, intern_ID)
			values(Email2, 0, intern_ID);
	end if;
	
	if ifnull(Email3, '') <> '' then
		insert into pgip_interndb.intern_email(email, primary_ck, intern_ID)
			values(Email3, 0, intern_ID);
	end if;
	
	if ifnull(Phone1, '') <> '' then
		insert into pgip_interndb.intern_phone(phone, primary_ck, intern_ID)
		values(concat('(', substring(Phone1, 1, 3),') ', substring(Phone1, 4, 3), '-', substring(Phone1, 7, 4)), 1, intern_ID);
	end if;
	
	if ifnull(Phone2, '') <> '' then
		insert into pgip_interndb.intern_phone(phone, primary_ck, intern_ID)
		values(concat('(', substring(Phone2, 1, 3),') ', substring(Phone2, 4, 3), '-', substring(Phone2, 7, 4)), 0, intern_ID);
	end if;
	
	if ifnull(position_ID, '')<> '' then
		insert into pgip_interndb.position(position)
		values(position_ID);
	end if;
	
end$$

DROP PROCEDURE IF EXISTS `sp_Insert_Update_Personnel`$$
CREATE DEFINER=`Fitness_Anonymous`@`%` PROCEDURE `sp_Insert_Update_Personnel` (IN `PersonnelID` INT(9), IN `firstname` VARCHAR(50), IN `lastname` VARCHAR(50), IN `role_ID` INT(9), IN `department_ID` INT(9), IN `Track_ID` INT(9), IN `personal_Email` VARCHAR(120), IN `PurdueGlobal_Email` VARCHAR(120), IN `PGIPTech_Email` VARCHAR(120))  BEGIN
DECLARE EMAILID int;

	IF (PersonnelID = 0) THEN
    	INSERT INTO intern_email (`email_ID`, `Personal_Email`, `PurdueGlobal_Email`, `PGIPTech_Email`) VALUES (NULL, personal_Email, 					PurdueGlobal_Email, PGIPTech_Email);
        
        Set EmailID = Last_Insert_ID();
        
        INSERT INTO personnel (`Intern_ID`, `Department_ID`, `Role_ID`, `Email_ID`, `Track_ID`, `FirstName`, `LastName`, `Gitano`, `Active`) VALUES (NULL, department_ID, role_ID, EmailID, Track_ID, firstname, lastname, '0','1');
     ELSE 
     	UPDATE personnel SET personnel.FirstName = firstname, personnel.LastName = lastname, personnel.Role_ID = role_ID, personnel.Department_ID = department_ID, personnel.Track_ID = Track_ID WHERE personnel.Intern_ID = PersonnelID;
        
        Set EMAILID = (SELECT personnel.Email_ID FROM personnel WHERE personnel.Intern_ID = PersonnelID);
        
        UPDATE intern_email SET intern_email.Personal_Email = personal_Email, intern_email.PurdueGlobal_Email = PurdueGlobal_Email, intern_email.PGIPTech_Email = PGIPTech_Email WHERE intern_email.email_ID=EmailID;
        
       END IF;
       
END$$

DROP PROCEDURE IF EXISTS `sp_InternUpdate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_InternUpdate` (IN `InternID` INT, IN `LastName` VARCHAR(30), IN `FirstName` VARCHAR(30), IN `Email1` VARCHAR(100), IN `Email2` VARCHAR(100), IN `Email3` VARCHAR(100), IN `Phone1` VARCHAR(20), IN `Phone2` VARCHAR(20), IN `StatusID` INT, IN `DeptID` INT, IN `TeamID` INT, IN `PositionID` INT, IN `Track1ID` INT, IN `Track2ID` INT, IN `TrackStartDate` DATE, IN `TrackEndDate` DATE, IN `Orientation1` TINYINT(1), IN `Orientation2` TINYINT(1), IN `Orientation3` TINYINT(1), IN `TCW` TINYINT(1), IN `FreedCamp` TINYINT(1), IN `Leadership` TINYINT(1), IN `Chime` TINYINT(1), IN `Console` TINYINT(1), IN `Comments` TEXT)  BEGIN
		declare TStartDate date;
		declare TEndDate date;
		declare PosStartDate date;
		declare Seq_No int;
		declare NewStatus int;
		declare NewDept int;
		declare NewTeam int;
		declare NewPos int;
		
		set TStartDate = (select start_date from pgip_interndb.tracks where academic_track_ID = Track1ID);
		if ifnull(Track2ID,0) = 0 then
			set TEndDate = (select end_date from pgip_interndb.tracks where academic_track_ID = Track1ID);
		else
			set TEndDate = (select end_date from pgip_interndb.tracks where academic_track_ID = Track2ID);
		end if;
		
		if (select status_id from pgip_interndb.intern where intern_ID = InternID) <> StatusID then	
			set NewStatus = 1;
		else
			set NewStatus = 0;
		end if;
		
		if (select department_ID from pgip_interndb.intern where intern_ID = InternID) <> DeptID then
			set NewDept = 1;
		else
			set NewDept = 0;
		end if;
		
		if (select team_ID from pgip_interndb.intern where intern_ID = InternID) <> TeamID then
			set NewTeam = 1;
		else
			set NewTeam = 0;
		end if;
		
		if (select position_ID from pgip_interndb.intern where intern_ID = InternID) <> PositionID then
			set NewPos = 1;
		else
			set NewPos = 0;
		end if;
		
		if StatusID in (1,2,3) then
			update pgip_interndb.intern
			set last_name = LastName,
				first_name = FirstName,
				email = Email1,
				phone = Phone1,
				status_id = StatusID,
				department_ID = DeptID,
				team_ID = TeamID,
				position_ID = PositionID,
				tracks_id = Track1ID,
				tracks2_id = Track2ID,
				track_start = TStartDate,
				track_end = TEndDate,
				Orientation1_ck = Orientation1,
				Orientation2_ck = Orientation2,
				Orientation3_ck = Orientation3,
				TimeClock_Wizard_ck = TCW,
				Freedcamp_ck = FreedCamp,
				Leadership_Interest = Leadership,
				Chime_ck = Chime,
				Console_ck = Console,
				Comments = Comments
			where intern_ID = InternID;
			
			if not exists (select email from pgip_interndb.intern_email
					where intern_ID = InternID and email = Email1 and primary_ck = 1) then
					update pgip_interndb.intern_email
					set email = Email1
					where intern_ID = InternID and primary_ck = 1;
			end if;
			
			if (select count(8) from pgip_interndb.intern_email
					where intern_ID = InternID and primary_ck = 0) >= 0 then
				delete from pgip_interndb.intern_email where intern_ID = InternID and primary_ck = 0;
				
				if ifnull(Email2,'')<> '' then
					insert into pgip_interndb.intern_email(email, primary_ck, intern_ID)
						values(Email2, 0, InternID);
				end if;
				
				if ifnull(Email3,'') <> '' then
				insert into pgip_interndb.intern_email(email, primary_ck, intern_ID)
					values(Email3, 0, InternID);
			end if;
		end if;
	
		if not exists (select phone from pgip_interndb.intern_phone 
					where intern_ID = InternID and phone = Phone1 and primary_ck = 1) then 
			update 		pgip_interndb.intern_phone
			set 		phone = concat('(', substring(Phone1, 1, 3),') ', substring(Phone1, 4,3), '-', substring(Phone1, 7,4))
            where		intern_ID = InternID and primary_ck = 1;
            
            if (select count(*) from pgip_interndb.intern_phone where intern_ID = InternID) = 0 then
				insert into pgip_interndb.intern_phone(phone, primary_ck, intern_ID)
					values(concat('(', substring(Phone1, 1, 3),') ', substring(Phone1, 4,3), '-', substring(Phone1, 7,4)), 1, InternID);
			end if;
		end if;        
        
        if (select count(*) from pgip_interndb.intern_phone 
					where intern_ID = InternID and primary_ck = 0) >= 0 then
			
            delete from pgip_interndb.intern_phone where intern_ID = InternID and primary_ck = 0;
	
			if ifnull(Phone2,'') <> '' then
				insert into pgip_interndb.intern_phone(phone, primary_ck, intern_ID)
					values(concat('(', substring(Phone2, 1, 3),') ', substring(Phone2, 4,3), '-', substring(Phone2, 7,4)), 0, InternID);
			end if;
		end if;
		
		if StatusID in (2,3) and
			(NewStatus = 1 or NewDept = 1 or NewTeam = 1 or NewPos = 1) then
			set Seq_No = (select max(intern_pos_seq) from pgip_interndb.intern_positions where intern_ID = InternID);
			
			##Close out most recent record
			update pgip_interndb.intern_positions
			set end_date = now()-interval 240 minute
			where intern_ID = InternID and intern_pos_seq = Seq_No;
			
			set Seq_No = Seq_No + 1;
			
			insert into pgip_interndb.intern_positions(
				intern_ID, intern_pos_seq, status_ID, department_ID, team_ID, positions_ID, start_date, end_date)
				values(InternID, Seq_No, StatusID, DeptID, TeamID, PositionID, now()+interval 1200 minute, '9999-12-31');
		end if;
			
	end if;
		
END$$

DROP PROCEDURE IF EXISTS `sp_Personnel`$$
CREATE DEFINER=`Fitness_Anonymous`@`%` PROCEDURE `sp_Personnel` (IN `Active` INT(1))  BEGIN
IF (Active = 0) THEN
	SELECT * FROM vw_personnel;
ELSEIF(Active = 1) THEN
	SELECT * FROM vw_personnel WHERE vw_personnel.active = 1;
ELSE
	SELECT * FROM vw_personnel WHERE vw_personnel.active = 0;
   
END IF;
END$$

DROP PROCEDURE IF EXISTS `sp_Update_PersonnelStatus`$$
CREATE DEFINER=`Fitness_Anonymous`@`%` PROCEDURE `sp_Update_PersonnelStatus` (IN `PersonnelID` INT(8), IN `Active` INT(1))  BEGIN
UPDATE personnel SET personnel.Active = Active WHERE personnel.Intern_ID = PersonnelID;
END$$

DROP PROCEDURE IF EXISTS `ViewAllInterns`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ViewAllInterns` ()  BEGIN
	SELECT * FROM interns;
	END$$

DROP PROCEDURE IF EXISTS `view_emails`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_emails` ()  BEGIN
	SELECT * FROM intern_email;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
CREATE TABLE IF NOT EXISTS `department` (
  `department_ID` smallint(6) NOT NULL,
  `department_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`department_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`department_ID`, `department_name`) VALUES
(1, 'Leadership'),
(2, 'IT Maintenance & Training'),
(3, 'IT Support'),
(5, 'IT Systems'),
(6, 'Software Dev'),
(7, 'Cybersecurity'),
(8, 'Web/BD');

-- --------------------------------------------------------

--
-- Table structure for table `grade_hours`
--

DROP TABLE IF EXISTS `grade_hours`;
CREATE TABLE IF NOT EXISTS `grade_hours` (
  `week_ID` smallint(6) NOT NULL AUTO_INCREMENT,
  `intern_ID` smallint(6) NOT NULL,
  `week_No` smallint(6) DEFAULT NULL,
  `hours` time DEFAULT NULL,
  `grades` int(11) DEFAULT NULL,
  `comments` text,
  PRIMARY KEY (`week_ID`),
  KEY `intern_ID` (`intern_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=29 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `grade_hours`
--

INSERT INTO `grade_hours` (`week_ID`, `intern_ID`, `week_No`, `hours`, `grades`, `comments`) VALUES
(20, 3, NULL, '00:00:09', NULL, 'Was short on hours. Needs to make up next week.'),
(19, 2, NULL, '00:00:12', NULL, 'Great intern'),
(18, 1, NULL, '00:00:11', NULL, 'Made great progress this week1.'),
(17, 0, NULL, '00:00:11', NULL, 'Great job this week!'),
(21, 4, NULL, '00:00:16', NULL, 'Put in quite a few hours'),
(22, 5, NULL, '00:00:15', NULL, 'Made great progress, was able to make up for hours missed last week.'),
(23, 1, NULL, '00:00:11', NULL, 'Made great progress this week1.'),
(24, 2, NULL, '00:00:12', NULL, 'Great intern'),
(25, 3, NULL, '00:00:09', NULL, 'Was short on hours. Needs to make up next week.'),
(26, 4, NULL, '00:00:16', NULL, 'Put in quite a few hours'),
(27, 5, NULL, '00:00:15', NULL, 'Made great progress, was able to make up for hours missed last week.'),
(28, 6, NULL, '00:00:10', NULL, 'Great job.');

-- --------------------------------------------------------

--
-- Table structure for table `intern`
--

DROP TABLE IF EXISTS `intern`;
CREATE TABLE IF NOT EXISTS `intern` (
  `intern_ID` int(11) NOT NULL,
  `track_ID` int(11) DEFAULT NULL,
  `status_ID` int(11) DEFAULT NULL,
  `department_ID` int(11) DEFAULT NULL,
  `team_ID` int(11) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `first_name` varchar(30) DEFAULT NULL,
  `main_phone` varchar(20) DEFAULT NULL,
  `alt_phone` varchar(20) DEFAULT NULL,
  `Orientation1_ck` tinyint(1) DEFAULT NULL,
  `Orientation2_ck` tinyint(1) DEFAULT NULL,
  `Orientation3_ck` tinyint(1) DEFAULT NULL,
  `TimeClock_Wizard_ck` tinyint(1) DEFAULT NULL,
  `Freedcamp_ck` tinyint(1) DEFAULT NULL,
  `Leadership_Interest` tinyint(1) DEFAULT NULL,
  `Chime_ck` tinyint(1) DEFAULT NULL,
  `Console_ck` tinyint(1) DEFAULT NULL,
  `Comments` text,
  PRIMARY KEY (`intern_ID`),
  KEY `track_ID` (`track_ID`),
  KEY `status_ID` (`status_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `intern`
--

INSERT INTO `intern` (`intern_ID`, `track_ID`, `status_ID`, `department_ID`, `team_ID`, `last_name`, `email`, `first_name`, `main_phone`, `alt_phone`, `Orientation1_ck`, `Orientation2_ck`, `Orientation3_ck`, `TimeClock_Wizard_ck`, `Freedcamp_ck`, `Leadership_Interest`, `Chime_ck`, `Console_ck`, `Comments`) VALUES
(1, 1, NULL, NULL, NULL, 'Williams', NULL, 'Bob', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 2, NULL, NULL, NULL, 'McMillian', NULL, 'Tom', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 2, NULL, NULL, NULL, 'AName', NULL, 'Tim', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 2, NULL, NULL, NULL, 'Kirk', NULL, 'Bob', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, 2, NULL, NULL, NULL, 'Picard', NULL, 'Jean-Luc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6, 2, NULL, NULL, NULL, 'Williams', NULL, 'John', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `intern_email`
--

DROP TABLE IF EXISTS `intern_email`;
CREATE TABLE IF NOT EXISTS `intern_email` (
  `email_ID` smallint(6) NOT NULL AUTO_INCREMENT,
  `Personal_Email` varchar(120) DEFAULT NULL,
  `PurdueGlobal_Email` varchar(120) DEFAULT NULL,
  `PGIPTech_Email` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`email_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=47 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `intern_email`
--

INSERT INTO `intern_email` (`email_ID`, `Personal_Email`, `PurdueGlobal_Email`, `PGIPTech_Email`) VALUES
(1, '', 'DanielScerri@student.purdueglobal.edu', 'daniel.scerri@pgip-tech.com'),
(2, 'larisa.keeffe@gmail.com', 'larisakeeffe@student.purdueglobal.edu', 'larisa.keeffe@pgip-tech.com'),
(3, 'rbsoflo@gmail.com', 'risablair2@student.purdueglobal.edu', 'risa.blair@pgip-tech.com'),
(4, 'shannonmichaelroe@gmail.com ', 'shannonroe1@student.purdueglobal.edu', 'shannon.roe@pgip-tech.com'),
(5, 'shilpalnarayan@gmail.com', 'shilpalakshminar@student.purdueglobal.edu', 'shilpa.lakshminar@pgip-tech.com'),
(6, '', '', 'kevin.kinzer@pgip-tech.com'),
(7, 'Nick24w@gmail.com', '', 'nickolas.wilson@gita-tech.com'),
(8, '', 'gita.vicepresident@gmail.com', 'theresa.collins@gita-tech.com'),
(9, '', 'isaiahwalker3@student.purdueglobal.edu', 'isaiah.walker@gita-tech.com'),
(10, '', 'valeriepreter@student.purdueglobal.edu', 'valerie.preter@gita-tech.com'),
(11, '', '', 'marcia.hatten@gita-tech.com'),
(12, '', 'amymurr@student.PurdueGlobal.edu', 'amy.murr@pgip-tech.com'),
(13, 'feliciamicheline@icloud.com', 'feliciamicheline1@student.purdueglobal.edu', 'felicia.micheline@pgip-tech.com'),
(14, '', 'JamesMcClymonds@student.PurdueGlobal.edu', 'james.mcclymonds@pgip-tech.com /Hero!'),
(15, 'darkninja722@yahoo.com', 'ChristopherHenry15@student.PurdueGlobal.edu', 'christopher.henry@pgip-tech.com/Life saver'),
(16, 'thermop10@yahoo.com', '', 'kevin.mcginity@pgip-tech.com'),
(17, 'marj.furay@gmail.com', 'marjoriefuray@student.purdueglobal.edu', 'marj.furay@gita-tech.com/Doc\'s right hand'),
(18, 'robinlee.elder@gmail.com', '', 'robin.kennedy@pgip-tech.com'),
(19, '', '', ''),
(20, '', '', ''),
(21, '', 'SharleenSquires1@student.PurdueGlobal.edu', 'sharleen.squires@pgip-tech.com'),
(22, '', 'robinlancaster1@student.purdueglobal.edu', 'robin.lancaster@pgip-tech.com'),
(23, '', 'jasonkurzendoerf@student.purdueglobal.edu', 'jason.kurzendoerfer@pgip-tech.com'),
(24, '', 'RyanLindsey1@student.purdueglobal.edu', 'ryan.lindsey@pgip-tech.com'),
(25, 'antoneya.carhart@gmail.com', 'antoneyacarhart@student.purdueglobal.edu', 'antoneya.carhart@pgip-tech.com'),
(26, 'ballardlisa19@gmail.com', 'telisaballardals@student.purdueglobal.edu', 'telisa.ballard-alston@pgip-tech.com'),
(27, '', '', 'nick.abela@gita.tech'),
(28, '', 'patrickwilliams56@student.purdueglobal.edu', 'patrick.williams@gita-tech.com'),
(29, '', 'claudewill1@student.purdueglobal.edu', 'claude.will@pgip-tech.com'),
(30, 'roberthadlock@gmail.com', 'roberthadlock1@student.purdueglobal.edu', 'robert.hadlock@pgip-tech.com'),
(31, '', '', 'adam.helton@gita-tech.com'),
(32, '', '', 'richard.kleemann@gita-tech.com'),
(33, '', 'KeefeVermillion@student.purdueglobal.edu', 'keefe.vermillion@pgip-tech.com'),
(34, '', 'TinaRothenberger1@student.purdueglobal.edu', 'tina.rothenberger@pgip-tech.com'),
(35, 'brianb3944@gmail.com', 'brianbrown81@student.PurdueGlobal.edu', 'brian.brown@pgip-tech.com'),
(36, 'titom27@yahoo.com', 'gilbertmelendez1@student.purdueglobal.edu', 'gilbert.melendez@pgip-tech.com'),
(37, '', 'jimcunningham84@gmail.com', 'james.cunningham@gita-tech.com'),
(38, '', 'bobbyarmstrong1@student.purdueglobal.edu', 'bobby.armstrong@pgip-tech.com');

-- --------------------------------------------------------

--
-- Table structure for table `intern_phone`
--

DROP TABLE IF EXISTS `intern_phone`;
CREATE TABLE IF NOT EXISTS `intern_phone` (
  `intern_phone_ID` int(11) NOT NULL AUTO_INCREMENT,
  `intern_ID` int(11) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `primary_ck` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`intern_phone_ID`),
  KEY `intern_ID` (`intern_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `intern_positions`
--

DROP TABLE IF EXISTS `intern_positions`;
CREATE TABLE IF NOT EXISTS `intern_positions` (
  `position_ID` smallint(6) NOT NULL AUTO_INCREMENT,
  `intern_ID` smallint(6) DEFAULT NULL,
  `intern_pos_seq` int(11) DEFAULT NULL,
  `department_ID` int(11) DEFAULT NULL,
  `team_ID` smallint(6) DEFAULT NULL,
  `status_ID` smallint(6) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`position_ID`),
  KEY `intern_ID` (`intern_ID`),
  KEY `fk_department_ID` (`department_ID`),
  KEY `fk_team_ID` (`team_ID`),
  KEY `fk_status_ID` (`status_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `intern_training`
--

DROP TABLE IF EXISTS `intern_training`;
CREATE TABLE IF NOT EXISTS `intern_training` (
  `training_ID` smallint(6) NOT NULL AUTO_INCREMENT,
  `intern_ID` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`training_ID`),
  KEY `intern_ID` (`intern_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `intern_training`
--

INSERT INTO `intern_training` (`training_ID`, `intern_ID`) VALUES
(1, 1),
(3, 2),
(4, 3),
(5, 4),
(6, 5),
(7, 6);

-- --------------------------------------------------------

--
-- Table structure for table `personnel`
--

DROP TABLE IF EXISTS `personnel`;
CREATE TABLE IF NOT EXISTS `personnel` (
  `Intern_ID` int(9) NOT NULL AUTO_INCREMENT,
  `Department_ID` int(9) NOT NULL,
  `Role_ID` int(9) NOT NULL,
  `Email_ID` int(9) NOT NULL,
  `Track_ID` int(9) DEFAULT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Gitano` tinyint(1) NOT NULL,
  `Active` tinyint(1) NOT NULL,
  PRIMARY KEY (`Intern_ID`),
  KEY `Department_ID` (`Department_ID`),
  KEY `Role_ID` (`Role_ID`,`Email_ID`),
  KEY `Track_ID` (`Track_ID`),
  KEY `Active` (`Active`),
  KEY `Gitano` (`Gitano`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `personnel`
--

INSERT INTO `personnel` (`Intern_ID`, `Department_ID`, `Role_ID`, `Email_ID`, `Track_ID`, `FirstName`, `LastName`, `Gitano`, `Active`) VALUES
(1, 7, 7, 1, 18, 'Daniel', 'Scerri', 0, 1),
(2, 7, 7, 2, 20, 'Larisa', 'Keeffe', 0, 1),
(3, 7, 7, 3, 20, 'Risa', 'Blair', 0, 1),
(4, 7, 7, 4, 20, 'Shannon', 'Roe', 0, 1),
(5, 7, 7, 5, 20, 'Shilpa', 'Lakshminar', 0, 1),
(6, 7, 7, 6, 0, 'Kevin', 'Kinser', 0, 1),
(7, 8, 5, 7, 0, 'Nickolas', 'Wilson', 1, 1),
(8, 8, 9, 8, 0, 'Theresa', 'Collins', 1, 1),
(9, 8, 14, 9, 0, 'Isaiah', 'Walker', 1, 1),
(10, 8, 14, 10, 0, 'Valerie', 'Preter', 1, 1),
(11, 8, 15, 11, 0, 'Marcia', 'Hatten', 1, 1),
(12, 8, 15, 12, 22, 'Amy ', 'Murr', 1, 1),
(13, 8, 15, 13, 21, 'Felicia', 'Micheline', 0, 1),
(14, 1, 1, 14, 0, 'James', 'McClymonds', 1, 1),
(15, 1, 2, 15, 0, 'Christopher', 'Henry', 1, 1),
(16, 1, 1, 16, 0, 'Kevin', 'McGinty', 1, 1),
(17, 1, 1, 17, 0, 'Marjorie', 'Furay', 1, 1),
(18, 1, 3, 18, 0, 'Robin', 'Kennedy', 1, 1),
(19, 1, 0, 37, 0, 'Jim', 'Cunningham', 1, 1),
(20, 2, 4, 14, 0, 'James', 'McClymonds', 1, 1),
(21, 3, 5, 21, 0, 'Sharleen', 'Squires', 1, 1),
(22, 3, 6, 22, 0, 'Rob', 'Lancaster', 1, 1),
(23, 3, 7, 23, 18, 'Jason', 'Kurzendoerfer', 0, 1),
(24, 3, 7, 24, 22, 'Ryan', 'Lindsey', 0, 1),
(25, 3, 8, 25, 21, 'Antoneya', 'Carhart', 0, 1),
(26, 3, 8, 26, 21, 'Telisa', 'Ballard-Alston', 0, 1),
(27, 5, 9, 27, 0, 'Nick', 'Abela', 1, 1),
(28, 5, 9, 28, 0, 'Patrick', 'Williams', 1, 1),
(29, 5, 10, 29, 18, 'Claude', 'Will', 0, 1),
(30, 5, 11, 30, 21, 'Robert', 'Hadlock', 0, 1),
(31, 6, 5, 31, 0, 'Adam', 'Helton', 1, 1),
(32, 6, 9, 32, 0, 'Richard', 'Kleemann', 1, 1),
(33, 0, 12, 33, 18, 'Keefe', 'Vermillion', 0, 1),
(34, 6, 12, 34, 18, 'Tina', 'Rothenberger', 0, 1),
(35, 6, 12, 35, 22, 'Brian', 'Brown', 0, 1),
(36, 6, 12, 36, 21, 'Gilbert', 'Melendez', 0, 1),
(37, 7, 13, 37, 0, 'Jim', 'Cunningham', 1, 1),
(38, 7, 5, 38, 18, 'Bobby', 'Armstrong', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `positions`
--

DROP TABLE IF EXISTS `positions`;
CREATE TABLE IF NOT EXISTS `positions` (
  `position_ID` smallint(6) NOT NULL AUTO_INCREMENT,
  `position` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`position_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `positions`
--

INSERT INTO `positions` (`position_ID`, `position`) VALUES
(1, 'Intern');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `Role_ID` int(9) NOT NULL AUTO_INCREMENT,
  `Role` varchar(50) NOT NULL,
  PRIMARY KEY (`Role_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`Role_ID`, `Role`) VALUES
(1, 'PGTech'),
(2, 'ITS&S'),
(3, 'PMO - Strategic & CS'),
(4, 'Head of Infrastructure'),
(5, 'Manager'),
(6, 'ITPC'),
(7, 'Analyst'),
(8, 'IT Support'),
(9, 'Consultant'),
(10, 'Database'),
(11, 'Network'),
(12, 'Programmer'),
(13, 'Head of Cybersecurity'),
(14, 'Mentor'),
(15, 'Developer');

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
CREATE TABLE IF NOT EXISTS `status` (
  `status_ID` smallint(6) NOT NULL AUTO_INCREMENT,
  `status` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`status_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `status`
--

INSERT INTO `status` (`status_ID`, `status`) VALUES
(1, 'Complete');

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
CREATE TABLE IF NOT EXISTS `teams` (
  `teams_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Team` varchar(25) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`teams_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tracks`
--

DROP TABLE IF EXISTS `tracks`;
CREATE TABLE IF NOT EXISTS `tracks` (
  `track_ID` smallint(6) NOT NULL AUTO_INCREMENT,
  `track` varchar(10) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`track_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tracks`
--

INSERT INTO `tracks` (`track_ID`, `track`, `start_date`, `end_date`) VALUES
(1, '1804B', '2018-10-17', '2018-12-26'),
(2, '1807D', '2018-10-17', '2019-01-23'),
(3, '1808D', '2018-12-05', '2019-03-05'),
(4, '1805A', '2018-11-07', '2019-01-22'),
(5, '1805C', '2018-12-05', '2019-02-19'),
(6, '1901A', '2019-01-30', '2019-04-09'),
(7, '1901B', '2019-01-02', '2019-02-21'),
(8, '1901C', '2019-02-27', '2019-05-07'),
(9, '1901D', '2019-01-23', '2019-03-05'),
(10, '1902D', '2019-03-13', '2019-04-23'),
(11, '1902A', '2019-04-17', '2019-06-25'),
(12, '1902B', '2019-03-20', '2019-05-28'),
(13, '1902C', '2019-05-15', '2019-07-23'),
(14, '1903D', '2019-04-24', '2019-06-04'),
(15, '1904D', '2019-06-12', '2019-07-23'),
(16, '1903A', '2019-07-03', '2019-09-10'),
(17, '1903B', '2019-06-05', '2019-08-13'),
(18, '1903C', '2019-07-31', '2019-10-08'),
(19, '1905D', '2019-07-24', '2019-09-03'),
(20, '1906D', '2019-09-11', '2019-12-03'),
(21, '1904A', '2019-09-18', '2019-11-26'),
(22, '1904B', '2019-08-21', '2019-10-29'),
(23, '1904C', '2019-10-16', '2019-12-23'),
(24, '1905A', '2019-12-04', '2020-02-18'),
(25, '1905B', '2019-11-06', '2020-01-21');

-- --------------------------------------------------------

--
-- Table structure for table `training`
--

DROP TABLE IF EXISTS `training`;
CREATE TABLE IF NOT EXISTS `training` (
  `training_ID` smallint(6) NOT NULL AUTO_INCREMENT,
  `training` varchar(20) DEFAULT NULL,
  `completed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`training_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `training`
--

INSERT INTO `training` (`training_ID`, `training`, `completed`) VALUES
(1, 'PHP', 1),
(2, 'VS ERD', 1),
(3, 'MySQL', 1),
(4, 'VisualStudio Code', 0),
(5, 'Node.JS', 1),
(6, 'Python', 0);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_interns_training_complete`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `vw_interns_training_complete`;
CREATE TABLE IF NOT EXISTS `vw_interns_training_complete` (
`intern_ID` int(11)
,`first_name` varchar(30)
,`last_name` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_interns_training_incomplete`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `vw_interns_training_incomplete`;
CREATE TABLE IF NOT EXISTS `vw_interns_training_incomplete` (
`intern_ID` int(11)
,`first_name` varchar(30)
,`last_name` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_intern_name_and_id`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `vw_intern_name_and_id`;
CREATE TABLE IF NOT EXISTS `vw_intern_name_and_id` (
`intern_ID` int(11)
,`first_name` varchar(30)
,`last_name` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_personnel`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `vw_personnel`;
CREATE TABLE IF NOT EXISTS `vw_personnel` (
`ID` int(9)
,`firstname` varchar(50)
,`lastname` varchar(50)
,`department_name` varchar(45)
,`role` varchar(50)
,`personal_Email` varchar(120)
,`PurdueGlobal_Email` varchar(120)
,`PGIPTech_Email` varchar(120)
,`Track` varchar(10)
,`start_date` date
,`end_date` date
,`active` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_intern_start_end_dates`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `v_intern_start_end_dates`;
CREATE TABLE IF NOT EXISTS `v_intern_start_end_dates` (
`first_name` varchar(30)
,`last_name` varchar(30)
,`track_ID` smallint(6)
,`track` varchar(10)
,`start_date` date
,`end_date` date
);

-- --------------------------------------------------------

--
-- Structure for view `vw_interns_training_complete`
--
DROP TABLE IF EXISTS `vw_interns_training_complete`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_interns_training_complete`  AS  select `i`.`intern_ID` AS `intern_ID`,`i`.`first_name` AS `first_name`,`i`.`last_name` AS `last_name` from ((`intern` `i` join `intern_training` `it` on((`i`.`intern_ID` = `it`.`intern_ID`))) join `training` `t` on((`it`.`training_ID` = `t`.`training_ID`))) where (`t`.`completed` = 1) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_interns_training_incomplete`
--
DROP TABLE IF EXISTS `vw_interns_training_incomplete`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_interns_training_incomplete`  AS  select `i`.`intern_ID` AS `intern_ID`,`i`.`first_name` AS `first_name`,`i`.`last_name` AS `last_name` from ((`intern` `i` join `intern_training` `it` on((`i`.`intern_ID` = `it`.`intern_ID`))) join `training` `t` on((`it`.`training_ID` = `t`.`training_ID`))) where (`t`.`completed` = 0) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_intern_name_and_id`
--
DROP TABLE IF EXISTS `vw_intern_name_and_id`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_intern_name_and_id`  AS  select `intern`.`intern_ID` AS `intern_ID`,`intern`.`first_name` AS `first_name`,`intern`.`last_name` AS `last_name` from `intern` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_personnel`
--
DROP TABLE IF EXISTS `vw_personnel`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_personnel`  AS  select `personnel`.`Intern_ID` AS `ID`,`personnel`.`FirstName` AS `firstname`,`personnel`.`LastName` AS `lastname`,`department`.`department_name` AS `department_name`,`roles`.`Role` AS `role`,`intern_email`.`Personal_Email` AS `personal_Email`,`intern_email`.`PurdueGlobal_Email` AS `PurdueGlobal_Email`,`intern_email`.`PGIPTech_Email` AS `PGIPTech_Email`,`tracks`.`track` AS `Track`,`tracks`.`start_date` AS `start_date`,`tracks`.`end_date` AS `end_date`,`personnel`.`Active` AS `active` from ((((`personnel` left join `roles` on((`roles`.`Role_ID` = `personnel`.`Role_ID`))) left join `department` on((`department`.`department_ID` = `personnel`.`Department_ID`))) left join `intern_email` on((`intern_email`.`email_ID` = `personnel`.`Email_ID`))) left join `tracks` on((`tracks`.`track_ID` = `personnel`.`Track_ID`))) ;

-- --------------------------------------------------------

--
-- Structure for view `v_intern_start_end_dates`
--
DROP TABLE IF EXISTS `v_intern_start_end_dates`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_intern_start_end_dates`  AS  select `i`.`first_name` AS `first_name`,`i`.`last_name` AS `last_name`,`t`.`track_ID` AS `track_ID`,`t`.`track` AS `track`,`t`.`start_date` AS `start_date`,`t`.`end_date` AS `end_date` from (`intern` `i` join `tracks` `t` on((`t`.`track_ID` = `i`.`track_ID`))) ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
