
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

# View(CO2)
barplot(table(CO2$Type))
