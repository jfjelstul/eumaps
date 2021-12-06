
# eumaps

`eumaps` makes it easy to make professional-quality choropleth maps of the European Union (EU) with only a few lines of code — and without knowing anything about map-making.

`eumaps` breaks down the process of making a map into three basic steps: (1) specifying the geography to plot, (2) specifying the color palette to use, and (3) specifying a theme that defines the aesthetics of the map.

`eumaps` includes a wide array of intuitive customization options. And it’s based on `ggplot`, so the output is customizable. 

The data for the country borders comes from Natural Earth, a public domain database.

## Installation

You can install the latest development version of the `eumaps` package from GitHub:

```r
# install.packages("devtools")
devtools::install_github("jfjelstul/eumaps@0.1.0")
```

## Citation

If you use the `eumaps` package to make a map for a project or paper, please cite the package:

> Joshua Fjelstul (2021). eumaps: Tools to make maps of the European Union. R package version 0.1.0.

The `BibTeX` entry for the package is:

```
@Manual{,
  title = {eumaps: Tools to make maps of the European Union},
  author = {Joshua Fjelstul},
  year = {2021},
  note = {R package version 0.1.0},
}
```

## Problems

If you notice an error in the data or a bug in the `R` package, please report it [here](https://github.com/jfjelstul/eumaps/issues).

## Quick start

The main function of the `eumaps` package is `make_map()`. The `make_map()` function has three inputs: an object of the class `eumaps.geography` created by `create_geography()` that the specifies geography to plot, an object of class `eumap.palette` created by `create_palette()` that specifies the color palette to use, and an object of class `eumaps.theme` created by `create_theme()` that specifies the theme. You can also choose a title for your map using `title`.

The `geography` input, which needs to be an object of class `eumaps.geography` created by `create_geography()`, specifies the geography to plot. The appropriate geography to plot is influenced by which countries are member states on the date of the data, whether the map should center on a subset of member states, the aspect ratio of the map, how zoomed out the map should be, whether the map should include non-member states, whether there should be insets for some member states, what projection the map should use, and whether the map should use high or low resolution border data. See the section below on creating the geography for more details. 

The `palette` input, which needs to be an object of class `eumaps.palette` created by `create_palette()`, specifies a mapping between a continuous variable and a color ramp with a fixed number of colors. It also specifies the colors and labels to use for member states with missing data, for member states where the data is not applicable, and for non-member states. See the section below on creating a color palette for more details.

The `theme` input, which needs to be an object of class `eumaps.theme` created by `create_theme()`, specifies the aesthetics of the map, including the style of the map border, the country borders, the title, the legend, and any insets. See the sectino below on creating a theme for more details. 

The `eumaps` package makes it easy to customize the look of your map. The functions `create_geography()`, `create_palette()`, and `create_theme()` let you customize nearly every aspect of the map. 

Here's an example that uses the default options. Only `create_palette()` requires you to choose some values. 

```r
# simulate data
data <- simulate_data(
  min = -1, 
  max = 1
)

# make map
map <- make_map(
  geography = create_geography(),
  palette = create_palette(
    member_states = data$member_state,
    values = data$value,
    value_min = -1,
    value_max = 1,
    count_colors = 8,
    color_low = "#E74C3C",
    color_high = "#3498DB",
    color_mid = "#FFFFFF"
  ),
  theme = create_theme()
)
```

## Creating the geography

The function `create_geometry()` creates the geography for a map made by `eumaps::make_map()`. It creates a object of type `eumaps.geography`, which you can pass to the `geography` argument of `make_maps()`. You can use `create_geography()` to set a variety of options that make it easy to make the map look exactly how you want.

All the examples below use the following `palette` and `theme` objects.

```r
# simulate data
data <- simulate_data(
  min = -1, 
  max = 1
)

# create palette
palette <- create_palette(
  member_states = data$member_state,
  values = data$value,
  value_min = -1,
  value_max = 1,
  count_colors = 8,
  color_low = "#E74C3C",
  color_high = "#3498DB",
  color_mid = "#FFFFFF"
)

# create theme
theme <- create_theme()
```

And each map is made using the following code:

```r
# make map
map <- make_map(
  geography = geography,
  palette = palette,
  theme = theme,
)
```

The only thing that is changing is the `geography` object.

### Choosing member states

`create_geography()` will automatically center the map on all countries that are member states on the date indicated by the argument `date`. This way, you never have to specify the bounds of the map, which can be complicated, depending on the map projection you want to use. You also don't have to know the accession dates of the member states. By default, `date` is set to today's date. You can use the optional argument `subset` to center the map on a subset of member states.

The first example is centered on all current member states, the second is centered on all member states on `2000-01-01`, and the third is centered on the original member states (France, Germany, Italy, Belgium, the Netherlands, and Luxembourg). 

### The aspect ratio

You can use `aspect_ratio` to specify the aspect ratio of the map. A value greater than `1` makes a map that is wider than it is tall and a value less than `1` makes a map that is taller than it is wide. The minimum value is `0.5` and the maximum value is `2`.

The first example shows an aspect ratio of `0.8`, and the second shows an aspect ratio of `1.2`.

```r
# example 1 (using the default values for all other arguments)
geography <- create_geography(
  aspect_ratio = 0.8
)

# example 2 (using the default values for all other arguments)
geography <- create_geography(
  aspect_ratio = 1.2
)
```

### Zooming

You can use `zoom` to choose a zoom factor. A value of `1` focuses the map tightly around the selected member states, and values less than `1` zoom out the map. The minimum value is `0.5`. The default is `0.9`. 

The first example shows a zoom of `0.9`, and the second shows a zoom of `0.7`.

```r
# example 1 (using the default values for all other arguments)
geography <- create_geography(
  zoom = 0.9
)

# example 2 (using the default values for all other arguments)
geography <- create_geography(
  zoom = 0.7
)
```

### Showing non-member states

You can use `show_non_member_states` to choose whether or not to plot non-member states. The default value is `TRUE`.

The first example shows non-member states, and the second does not. 

### Insets

You can use `insets` to create insets for member states whose values would be hard to read otherwise. By default, `insets` equals `NULL`, in which case no insets are created. You can provide a vector of member state names to create insets for those member states. You can create insets for Luxembourg, Malta, and Cyprus. The insets will appear in the top right corner of the map in the order given by the vector.

The first example includes insets for Luxembourg and Malta, and the second includes insets for Luxembourg, Malta, and Cyprus.

```r
# example 1 (using the default values for all other arguments)
geography <- create_geography(
  insets = c("Luxembourg", "Malta")
)

# example 2 (using the default values for all other arguments)
geography <- create_geography(
  insets = c("Luxembourg", "Cyprus", "Malta")
)
```

### Map projection

You can use `projection` to choose between 5 common map projections that are appropriate for Europe. You can run `list_projections()` to see the possible values. The default value is `lambert_azimuthal_equal_area` for the Lambert azimuthal equal-area projection (`EPSG:3035`). 

The first example uses a Lambert azimuthal equal-area projection, and the second uses a Mercator projection. 

```r
# example 1 (using the default values for all other arguments)
geography <- create_geography(
  projection = "lambert_azimuthal_equal_area"
)

# example 2 (using the default values for all other arguments)
geography <- create_geography(
  projection = "mercator"
)
```

### Resolution

You can use `resolution` to choose between low or high resolution border data. The default value is `high` and the alternative is `low`. The map will take longer to render if you use the high resolution data. The function always uses high resolution border data for the insets.

The first example uses the high resolution border data, and the second uses the low resolution data. 

```r
# example 1 (using the default values for all other arguments)
geography <- create_geography(
  resolution = "high"
)

# example 2 (using the default values for all other arguments)
geography <- create_geography(
  resolution = "low"
)
```


