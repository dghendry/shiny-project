# filename: key_ideas
#----------------------------------------------
# This R script illustrates the key ideas for 
# fully understanding the ideas in the default
# Shiny application (when created from RStudio)
#----------------------------------------------
#install.packages("shiny")
library("shiny")
library("ggplot2")

#----------------------------------------------
# faithful() data set - Built-in data frame 
# Waiting time between eruptions and the duration 
# of the eruption of Old Faithful geyser 
# [,1] numeric: Eruption time in mins
# [,2] numeric: Waiting time to next eruption 
#
# https://www.youtube.com/watch?v=4mZY7uxb7Gc
#----------------------------------------------
?faithful()
View(faithful)
nrow(faithful)
str(faithful)

#----------------------------------------------
# Recall how we can access a column in a data frame
#----------------------------------------------
# By $ notation, t is a temperary variable 
t <- faithful$waiting
View(t)

# By numeric index - second column 
t <- faithful[,2]
View(t)

# By name of column
t <- faithful[,"waiting"]
View(t)

#----------------------------------------------
# seq() generates a regular sequence of numbers, 
# returning a vector
# length.out is the desired length of the sequence
# Hence, we can use seq() to generate a list of 
# bins.
#----------------------------------------------
?seq()

v_bins_4 <- seq(from=1, to=10, length.out = 4)
print(v_bins_4)
length(v_bins_4)

v_bins_2 <- seq(from=1, to=10, length.out = 2)
print(v_bins_2)

v_bins_10 <- seq(from=1, to=10, length.out = 10)
print(v_bins_10)

v_bins_20 <- seq(from=1, to=10, length.out = 20)
print(v_bins_20)

#----------------------------------------------
# hist() is a R built-in fuction for drawing 
# histograms 
#----------------------------------------------
?hist()

# Default histogram 
hist(x=faithful$waiting)

# The minimum and maximum values in the histogram
min(faithful$waiting)
max(faithful$waiting)

# Show the histogram with specific breaks (aka "bins")
hist(x=faithful$waiting, breaks=c(1,25,50,75,100))

#----------------------------------------------
# Create a function for exploring how histograms work
# Notes: 
# (1) What does the "\n" do? 
# (2) For a list of colors in R, see: http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
#     some examples: chocolate, darkslategray1, darkgray, ... 
#----------------------------------------------
draw_histogram <- function(x_vector, breaks_vector){
  hist(x = x_vector, 
       breaks = breaks_vector, 
       main ="Main title: Histogram Example:\nErruption Durations", 
       xlab = "Erruption Durations",
       col = 'red', 
       border = 'white'
       )
}

# Try function with 5 bins
bins <- c(1,25,50,75,100)
draw_histogram(faithful$waiting,bins)

# Try function with 11 bins
bins <- c(1,10,20,30,40,50,60,70,80,90,100)
draw_histogram(faithful$waiting,bins)

# Use seq() to create the bins 
bins <- seq(1,100, length.out = 11)
draw_histogram(faithful$waiting,bins)

# Compute the bins based on the data 
low_bound <- min(faithful$waiting)
hi_bound <- max(faithful$waiting)
num_bins <- 10

bins <- seq(
  from=low_bound, 
  to=hi_bound, 
  length.out=num_bins+1)

print(bins)
draw_histogram(faithful$waiting,bins)

#----------------------------------------------
# Show a scatter plot of the data with ggplot2
#----------------------------------------------
ggplot(faithful) +
  geom_point(mapping = aes(x=faithful$eruptions, y=faithful$waiting))


