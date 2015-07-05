<!DOCTYPE html>
<html lang="en">

	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">

		<title><% title %></title>

		<link href="//cdnjs.cloudflare.com/ajax/libs/uikit/2.21.0/css/uikit.min.css" rel="stylesheet" />
		<link href="//cdnjs.cloudflare.com/ajax/libs/uikit/2.21.0/css/uikit.almost-flat.min.css" rel="stylesheet" />

		<!--[if lt IE 9]>
			<script src="//oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
			<script src="//oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
		<![endif]-->

	</head>

	<body>
		<div class="uk-container uk-container-center">
			<div class="uk-grid" data-uk-grid-margin>
				<div class="uk-width-1-1">

					<% body %>

					<article class="uk-article uk-margin-large-bottom">

						<h1 class="uk-article-title">ActionScript 3.0 Informations</h1>
						<p class="uk-article-lead">All informations gathered from the redtamarin runtime.</p>

						<%if( articles ) {%>
							<%for( var i = 0; i < articles.length; i++ ) {%>
								<h2><% articles[i].name %></h2>
								<%if( articles[i].description != "" ) {%>
								<p><% articles[i].description %></p>
								<%}%>
								<div class="uk-overflow-container">
									
									<table class="uk-table uk-table-striped">
										<tbody>
											<%for( var j = 0; j < articles[i].data.length; j++ ) {%>
												<tr>
													<td><% articles[i].data[j][0] %></td>
													<td><% articles[i].data[j][1] %></td>
												</tr>
											<%}%>
										</tbody>
									</table>

								</div>
							<%}%>
						<%}%>

					</article>

				</div>
			</div>
		</div>

		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/uikit/2.21.0/js/uikit.min.js"></script>

	<body>

</html>
