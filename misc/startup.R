# Define the screen resolution
screen_width <- 1920
screen_height <- 1080

# Set the initial size and position
plot_width <- 500  # Adjust this value to set the width
plot_height <- screen_height    # Adjust this value to set the height
xpos <- 800                       # Adjust this value to set the X position
ypos <- 0                         # Adjust this value to set the Y position

# Convert pixels to inches for X11()
plot_width_in <- plot_width / 96
plot_height_in <- plot_height / 96

# Open a new plotting window with specified dimensions
X11(width = plot_width_in, height = plot_height_in)

# hist((Maths+Physics+Chemistry)/10)

# wealth_percentage<-c(72.2, 31.9, 26.5, 29.1, 27.3, 8.6, 22.3, 26.5, 20.4, 12.8, 25.1, 19.2, 24.1, 58.2, 68.1);
# hist(wealth_percentage);
marks = c(32,35,83,74,55,68,38,35,55,66,65,42,68,72,84,67,36,42,58)
var(marks)

