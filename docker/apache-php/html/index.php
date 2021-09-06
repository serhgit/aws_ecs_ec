<?
if ($db_details = json_decode(getenv('db_details', false),true)) {

  $conn = new mysqli($db_details["db_write_host"],$db_details["db_user"], $db_details["db_password"],$db_details["db_name"], 3306);
  if ($conn->connect_error) {
        die ("ERROR: Unable to connect: " . $conn->connect_error);
  }

echo 'Connected to the database.<br>';
  if ($res = $conn->query("SELECT FirstName,LastName FROM test_table")) {
?>
       <html>
       <style>
       table, th, td {
         border:1px, solid black;
       }
       </style>
       <body>
         <table style: border 1px, solid black>
<?
        while ($row = $res->fetch_row())
        {

?>
                  <tr>
<?
                printf("%s %s\n","<td>".$row[0]."</td>","<td>".$row[1]."</td>");
?>
                </tr>
<?
        }
?>
        </table>
        </body>
        </html>
<?
  }
}

?>

