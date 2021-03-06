suppressWarnings(suppressMessages(library(shiny)))
library(httr)
library(readr)
library(xml2)

source("R/read_input.R")
source("R/decode.R")

# Random number associated with the session used in exported file names.
seed <- sample(10^6, 1)

PlotCohorts <- function(x, highlighted, color = "grey") {
	
	# cat(stderr(), "\n\n\n", x)

	n <- nrow(x)
	k <- ncol(x)
	if (n < 16) {
		par(mfrow = c(n, 1), mai = c(0, .5, .5, 0))
	} else if (n < 64) {
		par(mfrow = c(n / 2, 2), mai = c(0, .5, .5, 0))
	} else {
		par(mfrow = c(n / 4, 4), mai = c(0, .5, .5, 0))
	}
	for (i in 1:n) {
		cc <- rep(color, k)
		if (!is.null(highlighted)) {
			ind <- highlighted[which(ceiling((highlighted) / k) == i)] %% k

			# correct for 0 instead of k added
			ind[ind==0] <- k

			cc[ind] <- "greenyellow"
		}

		# -1 added below
		barplot(x[i, ], main = paste0("Cohort ", i-1), col = cc, border = cc,
						names.arg = "")

		# cat(stderr(), "iteration: ", i, "\n")
		# cat(stderr(), x[i, ], "\n")
		# cat(stderr(), ind, "\n")
	}
}

shinyServer(function(input, output, session) {
	Params <- reactive({
		param_file <- input$params

		input$run
		
		query <- parseQueryString(session$clientData$url_search)
		pK = query[['key']]
		if (!is.null(pK) && pK != "") {
			
			# cat(stderr(), "private key is: \n")
			# cat(stderr(), pK)
			
			url_csvs <- paste("http://rappor-js.herokuapp.com/api/v1/getCSV/", pK, "/params", sep="")
			# cat(stderr(), url_csvs)
			
			x <- GET(url_csvs)
			params <- ReadParameterFile(content(x), readCSV = FALSE)
			
		}
		else if (!is.null(param_file)) {
			params <- ReadParameterFile(param_file$datapath)
			updateSelectInput(session, "size", selected = params$k)
			updateSelectInput(session, "hashes", selected = params$h)
			updateSelectInput(session, "instances", selected = params$m)
			updateSliderInput(session, "p", value = params$p)
			updateSliderInput(session, "q", value = params$q)
			updateSliderInput(session, "f", value = params$f)
		} else {
			return(NULL)
		}
		params
	})

	Counts <- reactive({
		params <- Params()
		counts_file <- input$counts

		input$run
		
		query <- parseQueryString(session$clientData$url_search)
		pK = query[['key']]
		if (!is.null(pK)) {
			
			# cat(stderr(), "private key is: \n")
			# cat(stderr(), pK)
			
			url_csvs = paste("http://rappor-js.herokuapp.com/api/v1/getCSV/", pK, "/counts", sep="")
			# cat(stderr(), url_csvs)
			
			x = GET(url_csvs)
			counts <- ReadCountsFile(content(x, col_names=FALSE), params, readCSV = FALSE)
			
		}
		else if (is.null(counts_file)) {
			return(NULL)
		}
		else {
			counts <- ReadCountsFile(counts_file$datapath, params)
		}

		updateNumericInput(session, "N", value = sum(counts[, 1]))
		counts
	})

	# output$countsUploaded <- reactive({
	# 	ifelse(is.null(input$counts), FALSE, TRUE)
	# })
	# outputOptions(output, 'countsUploaded', suspendWhenHidden=FALSE)

	Map <- reactive({
		params <- Params()

		input$run
		
		query <- parseQueryString(session$clientData$url_search)
		pK = query[['key']]
		
		if (!is.null(pK)) {
			url_csvs = paste("http://rappor-js.herokuapp.com/api/v1/getCSV/", pK, "/map", sep="")
			
			x = GET(url_csvs)
			mapx = content(x, col_names=FALSE)
			map <- ReadMapFile(mapx, params, readCSV=FALSE)
			
		} 
		else {
			map_file <- input$map
			if (is.null(map_file)) {
				return(NULL)
			}
			map <- ReadMapFile(map_file$datapath, params)
		}
		
		updateSelectInput(session, "selected_string", choices = map$strs, selected = map$strs[1])
		map
	})

	# output$mapUploaded <- reactive({
	# 	ifelse(is.null(input$map), FALSE, TRUE)
	# })
	# outputOptions(output, 'mapUploaded', suspendWhenHidden=FALSE)

	DecodingParams <- reactive({
		list(alpha = as.numeric(0.15),
				 correction = "FDR")
	})

	output$mapUploaded <- reactive({
		ifelse(input$run > 0, TRUE, FALSE)
	})

	output$countsUploaded <- reactive({
		ifelse(input$run > 0, TRUE, FALSE)
	})
	outputOptions(output, 'mapUploaded', suspendWhenHidden=FALSE)
	outputOptions(output, 'countsUploaded', suspendWhenHidden=FALSE)

	Analyze <- reactive({
		# cat(stderr(), "map and then counts and then params:\n")
		# cat(stderr(), is.null(input$map))
		# cat(stderr(), is.null(input$counts))
		# cat(stderr(), is.null(input$params))

		if (input$run == 0) {
			return()
		}
		
		params <- Params()
		map <- Map()
		counts <- Counts()
		decoding_params <- DecodingParams()

		# cat(stderr(), "\n\n\nreached just fine\n\n\n")

		fit <- Decode(counts, map$map, params,
									alpha = decoding_params$alpha,
									correction = decoding_params$correction)
		
		# cat(stderr(), "Analyze done\n")
		fit
	})

	# Results summary.
	output$pr <- renderTable({
		Analyze()$summary
	},
													 include.rownames = FALSE, include.colnames = FALSE)

	# Results table.
	output$tab <- renderDataTable({
		 Analyze()$fit
	 },
		 options = list(iDisplayLength = 100))

	# Results barplot.
	output$res_barplot <- renderPlot({
		fit <- Analyze()$fit

		par(mai = c(2, 1, 1, .5))

		bp <- barplot(fit$proportion, col = "palegreen",
						main = "Discovered String Distribution")
		abline(h = Analyze()$privacy[7, 2], col = "darkred", lty = 2, lwd = 2)
		text(bp[, 1], 0, paste(fit$strings, " "), srt = 45, adj = c(1, 1), xpd = NA)
		legend("topright", legend = "Detection Frequency", lty = 2, lwd = 2, col = "darkred",
					 bty = "n")
	})

	# Epsilon.
	output$epsilon <- renderTable({
		Analyze()$privacy
	},
																include.rownames = FALSE, include.colnames = FALSE, digits = 4)

	output$map <- renderPlot({
		image(as.matrix(Map()$map), col = c("white", "darkred"), xaxt = "n", yaxt = "n", bty = "n")
	})

	# Estimated bits patterns.
	output$ests <- renderPlot({
		ests <- Analyze()$ests
		ind <- which(input$selected_string == Map()$strs)
		high <- unlist(Map()$map_pos[ind, -1])
		PlotCohorts(ests, high, color = "darkred")
	})

	# Collisions.
	output$collisions <- renderPlot({
		params <- Params()
		map <- Map()
		tab <- table(unlist(map$map_pos[, -1]))
		tab <- tab[as.character(1:(params$k * params$m))]
		tab[is.na(tab)] <- 0
		tab <- matrix(tab, nrow = params$m, byrow = TRUE)

		ind <- which(input$selected_string == map$strs)
		high <- unlist(map$map_pos[ind, -1])

		PlotCohorts(tab, high, color = "navajowhite")
	})

	# Observed counts.
	output$counts <- renderPlot({
		counts <- as.matrix(Analyze()$counts)
		ind <- which(input$selected_string == Map()$strs)
		high <- unlist(Map()$map_pos[ind, -1])
		PlotCohorts(counts, high, color = "darkblue")
	})

	# Downloadable datasets.
	output$download_fit <- downloadHandler(
																				 filename = function() { paste("results_", seed, "_", date(), '.csv', sep='') },
																				 content = function(file) {
																										 write.csv(Analyze()$fit, file, row.names = FALSE)
																									 }
																				 )

	output$download_summary <- downloadHandler(
																				 filename = function() { paste("summary_", seed, "_", date(), '.csv', sep='') },
																				 content = function(file) {
																										 write.csv(rbind(Analyze()$summary, Analyze()$privacy, Analyze()$params),
																															 file, row.names = FALSE)
																									 }
																				 )

	output$example_params <- renderTable({
		as.data.frame(ReadParameterFile("params.csv"))
	},
																include.rownames = FALSE)

	output$example_counts <- renderTable({
		counts <- ReadCountsFile("counts.csv", ReadParameterFile("params.csv"))[, 1:10]
		cbind(counts, rep("...", nrow(counts)))
	},
																include.rownames = FALSE, include.colnames = FALSE)

	output$example_map <- renderTable({
		map <- ReadMapFile("map.csv", ReadParameterFile("params.csv"))
		map$map_pos[1:10, ]
	},
																include.rownames = FALSE, include.colnames = FALSE)

})
