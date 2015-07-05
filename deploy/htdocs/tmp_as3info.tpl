<!DOCTYPE html>
<html lang="en">

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title><% title %></title>
	</head>

	<body>
		<% body %>

		<pre>
		<%if( buildinfo && (buildinfo.length > 0) ) {%>
			<% buildinfo.toString() %>
		<%}%>
		</pre>
	<body>

</html>
