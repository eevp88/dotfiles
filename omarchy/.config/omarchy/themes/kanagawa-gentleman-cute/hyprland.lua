local active_border_color = "rgb(f095c8)"

hl.config({
  general = {
    col = {
      active_border = active_border_color,
    },
  },

  group = {
    col = {
      border_active = active_border_color,
    },
  },
})

-- Kanagawa backdrop is too strong for default opacity.
o.window({ tag = "terminal" }, { opacity = "0.99 0.985" })
