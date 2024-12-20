return {
  loop = { prefix = 'loo', body = 'for ${1:k}, ${2:v} in ${3|ipairs,pairs|}(${0:t}) do\nend' },
}
