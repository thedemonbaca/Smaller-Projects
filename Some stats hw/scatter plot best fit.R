#plot with best fit line
plot(Pac.Contribution..aggregate.sum. ~ Leadership.Majority, data= m, xlab="Majority Leadership", 
	ylab="PAC Contributions", col= "blue")
	title(main="Scatter plot with best-fit line", font.main= 4)
	abline(lm(Pac.Contribution..aggregate.sum. ~ Leadership.Majority, 
	data= m), col= "red")