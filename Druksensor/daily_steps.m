
function[bar_steps] = daily_steps(steps)                                   %aantal stappen per kwartier opgeslagen in excelfile
x = datestr(steps(1,:), 'HH:MM');                                          %1e kolom: tijd, 2e kolom: aantal stappen
bar_steps = bar(x, steps(:,2), 0.8);                                       %x: vanaf begin, pas om de 4 weergeven? (indexing?)
end