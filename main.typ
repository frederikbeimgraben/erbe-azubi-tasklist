#import "src/lib.typ": *

#show: tasklist.with(
  title: [Aufgabenliste Auszubildende],
  author: "",
)

#task-table(
  // One array per task, one entry per column, e.g.
  // ([1], [Lötübung], [...], [...], [01.11.2026], ...),
  tasks: (),
  blank-rows: 14,
)
