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
		
			<div class="uk-block uk-block-muted">

				<div class="uk-container">

					<div class="uk-grid uk-grid-match" data-uk-grid-margin>

						<h3><% blob.title %></h3>

						<div class="uk-width-medium-1-3">
							<div class="uk-panel">
								<p><% blob.col1 %></p>
							</div>
						</div>

						<div class="uk-width-medium-1-3">
							<div class="uk-panel">
								<p><% blob.col2 %></p>
							</div>
						</div>

						<div class="uk-width-medium-1-3">
							<div class="uk-panel">
								<p><% blob.col3 %></p>
							</div>
						</div>

					</div>

				</div>

			</div>
		
			<div class="uk-cover-background"
				 style="height: 300px; background-image: url(<% image %>);">
			</div>

			<% body %>

		</div>
	<body>

</html>
