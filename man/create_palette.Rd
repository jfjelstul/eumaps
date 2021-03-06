% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_palette.R
\name{create_palette}
\alias{create_palette}
\title{Create a color palette}
\usage{
create_palette(
  member_states,
  values,
  not_applicable = NULL,
  value_min,
  value_max,
  count_colors,
  color_low,
  color_high,
  color_mid = NULL,
  color_missing = c(0.75, 0.75, 0.75),
  color_not_applicable = c(0.85, 0.85, 0.85),
  color_non_member_state = c(0.95, 0.95, 0.95),
  label_missing = "Missing",
  label_not_applicable = "Not applicable",
  label_non_member_state = "Not a member state"
)
}
\arguments{
\item{member_states}{String. Required, without a default value. A vector
that contains member state names. Needs to be the same length as \code{values}.
You can run \code{list_member_states()} to get a list of valid member state
names. Member state names should not be repeated.}

\item{values}{Numeric. Required, without a default value. A vector that
contains values corresponding to each member state in \code{member_states} to be
used for shading the member states. Needs to be the same length as
\code{member_states}.}

\item{not_applicable}{String. Optional. A vector of member states to code as
not applicable. These member states will not be shaded using the color
ramp. You can run \code{list_member_states()} to get a list of valid member
state names. The default value is \code{NULL}.}

\item{value_min}{Numeric. Required, without a default value. The value of
the data that corresponds to the lower bound of the bin for the lowest
color in the gradient. Should be a reasonably rounded value that is just
less than the minimum value that occurs in the data.}

\item{value_max}{Numeric. Required, without a default value. The value of the data
that corresponds to the upper bound of the bin for the highest color in the
gradient. Should be a reasonably rounded value that is just greater than
the maximum value that occurs in the data.}

\item{count_colors}{Numeric. Required, without a default value. The number of colors
to use in the discrete gradient. The minimum is 2 and the maximum is 10.}

\item{color_low}{Color.. Required (does not have a default). The color to
use for the low end of the gradient. Can be any value accepted by
\code{convert_color()}.}

\item{color_high}{Color. Required, without a default value. The color to
use for the high end of the gradient. Can be any value accepted by
\code{convert_color()}.}

\item{color_mid}{Color. Optional. The color to use for the middle
of the gradient. Specifying a value creates a diverging color palette.
Usually you want this color to be white. Can be any value accepted by
\code{convert_color()}. The default value is \code{NULL}.}

\item{color_missing}{Color. Required, with a default value. The color to
use for member states with missing data. Can be any value accepted by
\code{convert_color()}. The default value is \code{c(0.75, 0.75, 0.75)}.}

\item{color_not_applicable}{Color. Required, with a default value. The
color to use for member states that are coded as not applicable. Can be any
value accepted by \code{convert_color()}. The default value is \code{c(0.85, 0.85, 0.85)}.}

\item{color_non_member_state}{Color. Required, with a default value. The
color to use for non-member states. Can be any value accepted by
\code{convert_color()}. The default value is \code{c(0.95, 0.95, 0.95)}.}

\item{label_missing}{String. Required, with a default value. The label to use in the
legend for the color for member states with missing data. The default value
is \code{Missing}.}

\item{label_not_applicable}{String. Required, with a default value. The label to use
in the legend for the color for member states that are coded as not
applicable. The default value is \verb{Not applicable}.}

\item{label_non_member_state}{String. Required, with a default value. The label to
use in the legend for the color for non-member states. The default value is
\verb{Not a member state}.}
}
\value{
This function returns an object of type \code{eumaps.palette}, which you
can pass to the \code{palette} argument of \code{make_maps()}.
}
\description{
This function creates a color palette for a map of the European
Union (EU) made by \code{eumaps::make_map()}. It creates a object of type
\code{eumaps.palette}, which you can pass to the \code{palette} argument of
\code{make_map()}. An \code{eumaps.palette} object creates a mapping between a
continuous variable and a color ramp with a fixed number of colors. It also
defines the colors and labels to use for member states with missing data,
member states where the data is not applicable, and non-member states.

An \code{eumaps.palette} object only defines the colors used for shading
countries on the map. It does not define the background color (i.e., the
color of the water), the color of country borders, or the color of the
border around the map, These are defined using \code{create_theme()}, which
returns an \code{eumaps.theme} object that you can pass to the \code{theme} argument
of \code{make_map()}.
}
\details{
This function creates a mapping between a continuous variable and a
color ramp with a fixed number of colors. To make a palette, you need to
provide two vectors: a vector that contains member state names and a vector
that contains values corresponding to each member state to be used for
shading the member states. Member state names should not be repeated. You
can run \code{list_member_states()} to get a list of valid member state names.
The function will map the values you provide to colors.

You also need to specify minimum and maximum data values (these values
should be reasonably rounded, and all of the data points that you want to
plot should fall within this range), a low color and a high color for the
color ramp (there is also an optional middle color, so you can create a
diverging color palette), and the number of colors in the color ramp
(usually, for a choropleth map, you do not want to plot more than 10
colors).

The number of colors in the color ramp determines the number of bins that
the data will be divided into. The number of bins is always the same as the
number of colors. The break points between the bins (the number of break
points is always 1 less than the number of colors/bins) will be evenly
spaced between the minimum and maximum data values you provide.

You can also use \code{create_palette()} to specify the colors to use for member
states with missing data, for member states where the data is not
applicable, and for non-member states, along with the labels to use for
these three categories in the map legend. These three colors only appear in
the legend when applicable. In other words, the color for missing values
doesn't appear in the legend if there are no missing values, the color for
member states where the data is not applicable states doesn't appear if the
data is applicable to all member states, and the color for non-member
states doesn't appear if non-member states are not plotted.
}
\examples{
# using the default values
data <- simulate_data()
palette <- create_palette(
  member_states = data$member_state,
  values = data$variable,
  value_min = 0,
  value_max = 1,
  count_colors = 8,
  color_low = "#3498DB",
  color_high = "#E74C3C",
  color_mid = "#FFFFFF"
)

# using all options
data <- simulate_data()
palette <- create_palette(
  member_states = data$member_state,
  values = data$variable,
  not_applicable = NULL,
  value_min = 0,
  value_max = 1,
  count_colors = 8,
  color_low = "#3498DB",
  color_high = "#E74C3C",
  color_mid = "#FFFFFF",
  color_missing = c(0.75, 0.75, 0.75),
  color_not_applicable = c(0.85, 0.85, 0.85),
  color_non_member_state = c(0.95, 0.95, 0.95),
  label_missing = "Missing",
  label_not_applicable = "Not applicable",
  label_non_member_state = "Not a member state"
)

}
